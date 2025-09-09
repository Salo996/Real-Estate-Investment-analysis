#!/usr/bin/env python3
"""
Real Estate Investment Analysis - Dashboard Creation Script
Purpose: Fetch real estate data from APIs and create comprehensive investment analysis dashboard

Author: Salomón Santiago
Project: Real Estate Investment Analysis Platform
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import sqlite3
import requests
import json
from datetime import datetime, timedelta
import warnings
warnings.filterwarnings('ignore')

# Set visualization style
plt.style.use('seaborn-v0_8')
sns.set_palette("husl")

class RealEstateAnalyzer:
    def __init__(self):
        """Initialize the Real Estate Analyzer with API configurations"""
        self.db_name = '../data/real_estate.db'
        self.setup_database()
        
    def setup_database(self):
        """Create SQLite database and tables for real estate data"""
        conn = sqlite3.connect(self.db_name)
        cursor = conn.cursor()
        
        # Create properties table
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS properties (
            property_id INTEGER PRIMARY KEY,
            address TEXT,
            city TEXT,
            state TEXT,
            zip_code TEXT,
            price REAL,
            bedrooms INTEGER,
            bathrooms REAL,
            square_feet INTEGER,
            property_type TEXT,
            estimated_rental_income REAL,
            property_taxes REAL,
            listing_date DATE,
            days_on_market INTEGER,
            price_per_sqft REAL
        )
        ''')
        
        conn.commit()
        conn.close()
        print("✅ Database initialized successfully")
        
    def fetch_sample_data(self):
        """Generate sample real estate data for demonstration purposes"""
        print("📊 Generating sample real estate data...")
        
        # Sample data generation (in production, this would call real APIs)
        np.random.seed(42)
        
        cities = [
            ('Austin', 'TX'), ('Denver', 'CO'), ('Phoenix', 'AZ'), ('Atlanta', 'GA'),
            ('Nashville', 'TN'), ('Charlotte', 'NC'), ('Tampa', 'FL'), ('Orlando', 'FL'),
            ('Las Vegas', 'NV'), ('Sacramento', 'CA'), ('Oklahoma City', 'OK'), ('Kansas City', 'MO')
        ]
        
        properties = []
        property_id = 1
        
        for city, state in cities:
            # Generate 15-25 properties per city
            num_properties = np.random.randint(15, 26)
            
            for _ in range(num_properties):
                # Base price varies by city
                base_price_map = {
                    'Austin': 400000, 'Denver': 450000, 'Phoenix': 350000, 'Atlanta': 280000,
                    'Nashville': 320000, 'Charlotte': 290000, 'Tampa': 300000, 'Orlando': 280000,
                    'Las Vegas': 380000, 'Sacramento': 480000, 'Oklahoma City': 180000, 'Kansas City': 200000
                }
                
                base_price = base_price_map.get(city, 300000)
                
                # Property characteristics
                bedrooms = np.random.choice([2, 3, 4, 5], p=[0.2, 0.4, 0.3, 0.1])
                bathrooms = np.random.choice([1, 1.5, 2, 2.5, 3, 3.5], p=[0.1, 0.15, 0.3, 0.2, 0.2, 0.05])
                square_feet = int(np.random.normal(1200 + bedrooms * 300, 200))
                
                # Price calculation with some randomness
                price_variation = np.random.normal(1.0, 0.25)
                size_multiplier = square_feet / 1500  # Normalize around 1500 sqft
                price = int(base_price * price_variation * size_multiplier)
                price = max(price, 50000)  # Minimum price
                
                # Rental income estimation (1-2% of property value monthly)
                rental_yield = np.random.uniform(0.008, 0.02)
                estimated_rental = int(price * rental_yield)
                
                # Property taxes (0.8-2.5% annually)
                property_tax_rate = np.random.uniform(0.008, 0.025)
                property_taxes = int(price * property_tax_rate)
                
                # Days on market
                days_on_market = int(np.random.exponential(45))
                
                # Listing date (within last 18 months)
                days_ago = np.random.randint(1, 550)
                listing_date = datetime.now() - timedelta(days=days_ago)
                
                property_data = {
                    'property_id': property_id,
                    'address': f"{np.random.randint(100, 9999)} {np.random.choice(['Main', 'Oak', 'Pine', 'Elm', 'Cedar', 'Park', 'First', 'Second'])} {np.random.choice(['St', 'Ave', 'Dr', 'Ln', 'Ct'])}",
                    'city': city,
                    'state': state,
                    'zip_code': f"{np.random.randint(10000, 99999)}",
                    'price': price,
                    'bedrooms': bedrooms,
                    'bathrooms': bathrooms,
                    'square_feet': square_feet,
                    'property_type': np.random.choice(['Single Family', 'Townhouse', 'Condo'], p=[0.7, 0.2, 0.1]),
                    'estimated_rental_income': estimated_rental,
                    'property_taxes': property_taxes,
                    'listing_date': listing_date.strftime('%Y-%m-%d'),
                    'days_on_market': days_on_market,
                    'price_per_sqft': round(price / square_feet, 2)
                }
                
                properties.append(property_data)
                property_id += 1
        
        # Save to database
        df = pd.DataFrame(properties)
        conn = sqlite3.connect(self.db_name)
        df.to_sql('properties', conn, if_exists='replace', index=False)
        conn.close()
        
        print(f"✅ Generated {len(properties)} sample properties across {len(cities)} cities")
        return df
    
    def create_investment_dashboard(self, df):
        """Create comprehensive real estate investment analysis dashboard"""
        print("📈 Creating Real Estate Investment Dashboard...")
        
        # Set up the figure with subplots
        fig = plt.figure(figsize=(20, 16))
        fig.suptitle('Real Estate Investment Analysis Dashboard\nComprehensive Market Intelligence & Investment Opportunities', 
                     fontsize=20, fontweight='bold', y=0.98)
        
        # Calculate investment metrics
        df['annual_rental'] = df['estimated_rental_income'] * 12
        df['cap_rate'] = (df['annual_rental'] / df['price'] * 100).round(2)
        df['monthly_cash_flow'] = (
            df['estimated_rental_income'] - 
            (df['price'] * 0.80 * 0.045 / 12) -  # Mortgage payment (4.5% interest)
            (df['property_taxes'] / 12) -         # Monthly taxes
            (df['estimated_rental_income'] * 0.1) # Maintenance reserve
        ).round(0)
        
        # 1. Price Distribution by State
        plt.subplot(3, 4, 1)
        state_avg = df.groupby('state')['price'].mean().sort_values(ascending=False)
        bars = plt.bar(state_avg.index, state_avg.values / 1000, color='steelblue', alpha=0.8)
        plt.title('Average Property Price by State', fontweight='bold', fontsize=12)
        plt.xlabel('State')
        plt.ylabel('Price ($000s)')
        plt.xticks(rotation=45)
        
        # Add value labels on bars
        for bar in bars:
            height = bar.get_height()
            plt.text(bar.get_x() + bar.get_width()/2., height + 5,
                    f'${height:.0f}K', ha='center', va='bottom', fontsize=9)
        
        # 2. Cap Rate Distribution
        plt.subplot(3, 4, 2)
        plt.hist(df['cap_rate'], bins=20, color='lightgreen', alpha=0.7, edgecolor='black')
        plt.axvline(df['cap_rate'].median(), color='red', linestyle='--', 
                   label=f'Median: {df["cap_rate"].median():.1f}%')
        plt.title('Cap Rate Distribution', fontweight='bold', fontsize=12)
        plt.xlabel('Cap Rate (%)')
        plt.ylabel('Number of Properties')
        plt.legend()
        
        # 3. Price per Square Foot Analysis
        plt.subplot(3, 4, 3)
        city_price_sqft = df.groupby('city')['price_per_sqft'].mean().sort_values(ascending=False).head(8)
        bars = plt.barh(city_price_sqft.index, city_price_sqft.values, color='coral', alpha=0.8)
        plt.title('Price per Sq Ft by Top Cities', fontweight='bold', fontsize=12)
        plt.xlabel('Price per Sq Ft ($)')
        
        # Add value labels
        for i, bar in enumerate(bars):
            width = bar.get_width()
            plt.text(width + 2, bar.get_y() + bar.get_height()/2,
                    f'${width:.0f}', ha='left', va='center', fontsize=9)
        
        # 4. Investment Opportunity Heat Map
        plt.subplot(3, 4, 4)
        opportunity_data = df.groupby('state').agg({
            'cap_rate': 'mean',
            'monthly_cash_flow': 'mean',
            'price': 'mean'
        }).round(1)
        
        # Create investment score
        opportunity_data['investment_score'] = (
            (opportunity_data['cap_rate'] / opportunity_data['cap_rate'].max() * 50) +
            (opportunity_data['monthly_cash_flow'] / opportunity_data['monthly_cash_flow'].max() * 30) +
            ((1 / (opportunity_data['price'] / opportunity_data['price'].min())) * 20)
        ).round(1)
        
        bars = plt.bar(opportunity_data.index, opportunity_data['investment_score'], 
                      color='gold', alpha=0.8)
        plt.title('Investment Opportunity Score by State', fontweight='bold', fontsize=12)
        plt.xlabel('State')
        plt.ylabel('Investment Score')
        plt.xticks(rotation=45)
        
        # 5. Cash Flow Analysis
        plt.subplot(3, 4, 5)
        cash_flow_positive = df[df['monthly_cash_flow'] > 0]
        plt.scatter(cash_flow_positive['price'], cash_flow_positive['monthly_cash_flow'], 
                   alpha=0.6, c=cash_flow_positive['cap_rate'], cmap='viridis')
        plt.colorbar(label='Cap Rate (%)')
        plt.title('Cash Flow vs Property Price', fontweight='bold', fontsize=12)
        plt.xlabel('Property Price ($)')
        plt.ylabel('Monthly Cash Flow ($)')
        
        # 6. Market Velocity (Days on Market)
        plt.subplot(3, 4, 6)
        city_dom = df.groupby('city')['days_on_market'].mean().sort_values().head(8)
        colors = ['red' if x < 30 else 'orange' if x < 60 else 'green' for x in city_dom.values]
        bars = plt.barh(city_dom.index, city_dom.values, color=colors, alpha=0.7)
        plt.title('Market Velocity (Days on Market)', fontweight='bold', fontsize=12)
        plt.xlabel('Average Days on Market')
        
        # Add velocity indicators
        for i, bar in enumerate(bars):
            width = bar.get_width()
            market_type = 'Hot' if width < 30 else 'Warm' if width < 60 else 'Cool'
            plt.text(width + 1, bar.get_y() + bar.get_height()/2,
                    f'{width:.0f} ({market_type})', ha='left', va='center', fontsize=8)
        
        # 7. Property Size vs Rental Yield
        plt.subplot(3, 4, 7)
        rental_yield = (df['annual_rental'] / df['price'] * 100)
        size_bins = pd.cut(df['square_feet'], bins=[0, 1000, 1500, 2000, 5000], 
                          labels=['<1000', '1000-1500', '1500-2000', '>2000'])
        size_yield = df.groupby(size_bins)['cap_rate'].mean()
        
        bars = plt.bar(size_yield.index, size_yield.values, color='lightblue', alpha=0.8)
        plt.title('Rental Yield by Property Size', fontweight='bold', fontsize=12)
        plt.xlabel('Square Feet')
        plt.ylabel('Average Cap Rate (%)')
        
        # 8. Top Investment Properties
        plt.subplot(3, 4, 8)
        # Create simple investment score
        df['simple_score'] = (df['cap_rate'] * 0.4 + 
                             (df['monthly_cash_flow'] / df['monthly_cash_flow'].max() * 10) * 0.6)
        
        top_properties = df.nlargest(5, 'simple_score')[['city', 'state', 'simple_score']]
        top_properties['location'] = top_properties['city'] + ', ' + top_properties['state']
        
        bars = plt.barh(top_properties['location'], top_properties['simple_score'], 
                       color='purple', alpha=0.7)
        plt.title('Top 5 Investment Markets', fontweight='bold', fontsize=12)
        plt.xlabel('Investment Score')
        
        # 9. Monthly Trends (Simulated)
        plt.subplot(3, 4, 9)
        # Create monthly trend simulation
        months = pd.date_range(start='2023-01-01', periods=12, freq='M')
        price_trend = [300000 + i*5000 + np.random.normal(0, 15000) for i in range(12)]
        
        plt.plot(months, price_trend, marker='o', linewidth=2, color='darkgreen')
        plt.title('Average Price Trend (12 Months)', fontweight='bold', fontsize=12)
        plt.xlabel('Month')
        plt.ylabel('Average Price ($)')
        plt.xticks(rotation=45)
        plt.gca().yaxis.set_major_formatter(plt.FuncFormatter(lambda x, p: f'${x/1000:.0f}K'))
        
        # 10. ROI Comparison
        plt.subplot(3, 4, 10)
        roi_comparison = df.groupby('property_type').agg({
            'cap_rate': 'mean',
            'monthly_cash_flow': 'mean'
        }).round(1)
        
        x = np.arange(len(roi_comparison.index))
        width = 0.35
        
        plt.bar(x - width/2, roi_comparison['cap_rate'], width, label='Cap Rate (%)', alpha=0.8)
        plt.bar(x + width/2, roi_comparison['monthly_cash_flow']/50, width, 
               label='Cash Flow ($50s)', alpha=0.8)
        
        plt.title('ROI Metrics by Property Type', fontweight='bold', fontsize=12)
        plt.xlabel('Property Type')
        plt.xticks(x, roi_comparison.index, rotation=45)
        plt.legend()
        
        # 11. Risk vs Return Analysis
        plt.subplot(3, 4, 11)
        # Calculate risk (price volatility) and return (cap rate) by city
        city_metrics = df.groupby('city').agg({
            'cap_rate': 'mean',
            'price': 'std'  # Price standard deviation as risk proxy
        }).fillna(0)
        
        plt.scatter(city_metrics['price']/1000, city_metrics['cap_rate'], 
                   s=100, alpha=0.7, c=city_metrics['cap_rate'], cmap='RdYlGn')
        plt.colorbar(label='Cap Rate (%)')
        plt.title('Risk vs Return Analysis', fontweight='bold', fontsize=12)
        plt.xlabel('Price Volatility ($000s)')
        plt.ylabel('Average Cap Rate (%)')
        
        # 12. Key Performance Indicators
        plt.subplot(3, 4, 12)
        plt.axis('off')  # Turn off axis for text display
        
        # Calculate KPIs
        total_properties = len(df)
        avg_price = df['price'].mean()
        avg_cap_rate = df['cap_rate'].mean()
        positive_cash_flow = len(df[df['monthly_cash_flow'] > 0])
        cash_flow_rate = (positive_cash_flow / total_properties * 100)
        
        kpi_text = f"""
        📊 KEY PERFORMANCE INDICATORS
        
        Total Properties Analyzed: {total_properties:,}
        
        💰 Average Property Price: ${avg_price:,.0f}
        
        📈 Average Cap Rate: {avg_cap_rate:.1f}%
        
        💵 Positive Cash Flow Properties: {positive_cash_flow}
           ({cash_flow_rate:.1f}% of total)
        
        🏆 Top Performing State: {opportunity_data['investment_score'].idxmax()}
           (Score: {opportunity_data['investment_score'].max():.1f})
        
        ⚡ Fastest Moving Market: {city_dom.index[0]}
           ({city_dom.iloc[0]:.0f} days avg)
        
        🎯 Best Cash Flow Property: ${df['monthly_cash_flow'].max():,.0f}/month
        """
        
        plt.text(0.05, 0.95, kpi_text, transform=plt.gca().transAxes, fontsize=11,
                verticalalignment='top', fontfamily='monospace',
                bbox=dict(boxstyle='round,pad=0.5', facecolor='lightgray', alpha=0.8))
        
        # Adjust layout and save
        plt.tight_layout()
        plt.subplots_adjust(top=0.93, hspace=0.3, wspace=0.3)
        
        # Save dashboard
        dashboard_path = '../visualizations/real_estate_dashboard.png'
        plt.savefig(dashboard_path, dpi=300, bbox_inches='tight', 
                   facecolor='white', edgecolor='none')
        print(f"✅ Dashboard saved: {dashboard_path}")
        
        # Create executive summary
        self.create_executive_summary(df, opportunity_data)
        
        plt.show()
        
    def create_executive_summary(self, df, opportunity_data):
        """Create executive summary visualization"""
        fig, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2, figsize=(16, 12))
        fig.suptitle('Real Estate Investment Analysis - Executive Summary\nStrategic Investment Insights & Market Intelligence', 
                     fontsize=16, fontweight='bold')
        
        # 1. Investment Opportunity Ranking
        top_states = opportunity_data.sort_values('investment_score', ascending=False).head(6)
        bars1 = ax1.bar(top_states.index, top_states['investment_score'], 
                       color='darkgreen', alpha=0.8)
        ax1.set_title('Top Investment Opportunities by State', fontweight='bold')
        ax1.set_ylabel('Investment Score')
        
        # Add value labels
        for bar in bars1:
            height = bar.get_height()
            ax1.text(bar.get_x() + bar.get_width()/2., height + 1,
                    f'{height:.1f}', ha='center', va='bottom', fontweight='bold')
        
        # 2. Portfolio Allocation Recommendation  
        cash_flow_tiers = pd.cut(df['monthly_cash_flow'], 
                                bins=[-np.inf, 0, 200, 500, np.inf],
                                labels=['Negative', 'Low (0-$200)', 'Medium ($200-$500)', 'High ($500+)'])
        tier_counts = cash_flow_tiers.value_counts()
        
        colors = ['red', 'orange', 'lightgreen', 'darkgreen']
        wedges, texts, autotexts = ax2.pie(tier_counts.values, labels=tier_counts.index, 
                                          colors=colors, autopct='%1.1f%%', startangle=90)
        ax2.set_title('Cash Flow Distribution\n(Investment Quality Tiers)', fontweight='bold')
        
        # 3. Geographic Diversification
        state_counts = df['state'].value_counts().head(8)
        bars3 = ax3.barh(state_counts.index, state_counts.values, 
                        color='steelblue', alpha=0.7)
        ax3.set_title('Market Coverage by State\n(Property Count)', fontweight='bold')
        ax3.set_xlabel('Number of Properties')
        
        # 4. Key Metrics Summary Table
        ax4.axis('off')
        
        # Calculate summary metrics
        metrics_data = {
            'Metric': [
                'Total Investment Universe',
                'Average Property Price', 
                'Average Cap Rate',
                'Median Cash Flow',
                'Properties with Positive Cash Flow',
                'Best Performing State',
                'Average Days on Market',
                'Price Range'
            ],
            'Value': [
                f"{len(df):,} properties",
                f"${df['price'].mean():,.0f}",
                f"{df['cap_rate'].mean():.1f}%",
                f"${df['monthly_cash_flow'].median():,.0f}/month",
                f"{len(df[df['monthly_cash_flow'] > 0])} ({len(df[df['monthly_cash_flow'] > 0])/len(df)*100:.1f}%)",
                f"{opportunity_data['investment_score'].idxmax()}",
                f"{df['days_on_market'].mean():.0f} days",
                f"${df['price'].min():,.0f} - ${df['price'].max():,.0f}"
            ]
        }
        
        # Create table
        table_data = list(zip(metrics_data['Metric'], metrics_data['Value']))
        table = ax4.table(cellText=table_data, 
                         colLabels=['Key Investment Metrics', 'Value'],
                         cellLoc='left',
                         loc='center',
                         colWidths=[0.6, 0.4])
        
        table.auto_set_font_size(False)
        table.set_fontsize(10)
        table.scale(1.2, 2)
        
        # Style the table
        for i in range(len(table_data) + 1):
            if i == 0:  # Header row
                table[(i, 0)].set_facecolor('#4CAF50')
                table[(i, 1)].set_facecolor('#4CAF50')
                table[(i, 0)].set_text_props(weight='bold', color='white')
                table[(i, 1)].set_text_props(weight='bold', color='white')
            else:
                table[(i, 0)].set_facecolor('#f0f0f0' if i % 2 == 0 else 'white')
                table[(i, 1)].set_facecolor('#f0f0f0' if i % 2 == 0 else 'white')
        
        ax4.set_title('Executive Summary - Key Metrics', fontweight='bold', pad=20)
        
        plt.tight_layout()
        
        # Save executive summary
        summary_path = '../visualizations/real_estate_executive_summary.png'
        plt.savefig(summary_path, dpi=300, bbox_inches='tight',
                   facecolor='white', edgecolor='none')
        print(f"✅ Executive Summary saved: {summary_path}")
        
        plt.show()

def main():
    """Main execution function"""
    print("🏠 Real Estate Investment Analysis Platform")
    print("=" * 50)
    
    # Initialize analyzer
    analyzer = RealEstateAnalyzer()
    
    # Fetch and process data
    df = analyzer.fetch_sample_data()
    
    # Create comprehensive dashboard
    analyzer.create_investment_dashboard(df)
    
    print("\n🎉 Real Estate Investment Analysis Complete!")
    print("=" * 50)
    print("📂 Files created:")
    print("   • ../data/real_estate.db (SQLite database)")
    print("   • ../visualizations/real_estate_dashboard.png")
    print("   • ../visualizations/real_estate_executive_summary.png")
    print("\n💡 Next steps:")
    print("   • Run SQL queries in ../sql-queries/ directory")
    print("   • Analyze results and refine investment strategy")
    print("   • Apply findings to real-world investment decisions")

if __name__ == "__main__":
    main()