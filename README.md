# 🏠 Real Estate Investment Analysis Platform

**Comprehensive real estate investment analysis system with advanced SQL analytics, geographic mapping, and ROI calculations**

## 📊 Project Overview

This project demonstrates advanced data analysis capabilities applied to real estate investment decision-making. It combines financial modeling, geographic analysis, and business intelligence to identify optimal investment opportunities.

### 🎯 Business Impact
- **Investment Decision Support**: Systematic approach to property evaluation and portfolio optimization
- **Risk Assessment**: Multi-factor analysis combining financial metrics and market conditions  
- **Geographic Intelligence**: Location-based insights for market timing and opportunity identification
- **ROI Optimization**: Comprehensive cash flow analysis and return calculations

### 💼 Skills Demonstrated
- **Advanced SQL Analytics**: Progressive complexity from basic aggregations to multi-CTE investment scoring
- **Financial Modeling**: Cap rate, cash-on-cash return, and investment scoring algorithms
- **Geographic Analysis**: Location-based pricing trends and market velocity analysis
- **Business Intelligence**: Executive dashboards and actionable investment recommendations
- **Data Pipeline Development**: End-to-end ETL processes with Python and SQLite

## 🛠 Technical Architecture

### **Data Sources**
- **Primary**: RentCast API (Property details, valuations, rental estimates)
- **Secondary**: FRED API (Economic indicators, housing trends)  
- **Supplementary**: ATTOM Data API (Market analytics, comparables)

### **Technology Stack**
- **Database**: SQLite for development, PostgreSQL-ready for production
- **Analytics**: Python (pandas, numpy), Advanced SQL
- **Visualization**: matplotlib, seaborn, plotly for interactive mapping
- **APIs**: RESTful data integration with error handling

### **SQL Analysis Progression**
1. **01_basic_property_overview.sql** (EASY) - Fundamental data exploration
2. **02_location_price_analysis.sql** (EASY) - Geographic price analysis  
3. **03_investment_roi_calculator.sql** (MEDIUM) - Comprehensive ROI calculations
4. **04_market_trends_analysis.sql** (MEDIUM) - Time series and seasonal analysis
5. **05_advanced_investment_scoring.sql** (MEDIUM-HARD) - Multi-factor investment algorithm

## 📈 Key Analytics Features

### **Investment Metrics**
- **Cap Rate Analysis**: Annual rental income vs purchase price
- **Cash Flow Modeling**: Monthly cash flow after expenses
- **Cash-on-Cash Return**: Return on invested capital  
- **Investment Scoring**: Weighted algorithm combining 5+ factors

### **Market Intelligence**
- **Price Trends**: Historical and seasonal analysis
- **Market Velocity**: Days on market and liquidity indicators
- **Geographic Hotspots**: High-value and opportunity areas
- **Risk Assessment**: Volatility and market condition analysis

### **Decision Support**
- **Property Rankings**: Scored investment opportunities
- **Risk Classifications**: High/Medium/Low risk categories
- **Buy/Hold/Avoid Recommendations**: Actionable investment guidance
- **Portfolio Optimization**: Geographic and risk diversification

## 🚀 Quick Start

### Prerequisites
```bash
# Required Python packages
pip install pandas numpy matplotlib seaborn sqlite3 requests
```

### Running the Analysis
```bash
# 1. Generate sample data and create dashboard
python scripts/create_real_estate_dashboard.py

# 2. Run SQL analysis pipeline  
# Execute run_all_real_estate_analyses.sql in your SQL client

# 3. View results
# Check /visualizations/ for dashboard images
# Review /documentation/ for detailed analysis
```

## 📊 Sample Results

### Investment Opportunity Identification
```sql
-- Top 5 Investment Properties by Composite Score
SELECT address, city, state, price, monthly_cash_flow, 
       cap_rate_percent, composite_investment_score,
       investment_recommendation
FROM final_scoring 
WHERE composite_investment_score > 75
ORDER BY composite_investment_score DESC
LIMIT 5;
```

### Geographic Market Analysis
```sql  
-- Market Heat Analysis by Region
SELECT state, city, avg_days_on_market, market_temperature,
       supply_demand_ratio
FROM market_analysis
WHERE market_temperature = 'Hot Market'
ORDER BY supply_demand_ratio DESC;
```

## 📁 Project Structure

```
Project-4-Real-Estate-Investment-Analysis/
├── sql-queries/                           # Progressive SQL analysis
│   ├── 01_basic_property_overview.sql     # Data exploration (EASY)
│   ├── 02_location_price_analysis.sql     # Geographic analysis (EASY)  
│   ├── 03_investment_roi_calculator.sql   # ROI calculations (MEDIUM)
│   ├── 04_market_trends_analysis.sql      # Time series analysis (MEDIUM)
│   ├── 05_advanced_investment_scoring.sql # Investment algorithm (HARD)
│   └── run_all_real_estate_analyses.sql   # Master pipeline
├── scripts/
│   └── create_real_estate_dashboard.py    # Data collection & visualization
├── visualizations/
│   ├── real_estate_dashboard.png          # Comprehensive analysis dashboard
│   └── real_estate_executive_summary.png  # Executive summary
├── data/
│   └── real_estate.db                     # SQLite database
├── documentation/
│   └── Real_Estate_SQL_Documentation.html # Detailed code documentation  
├── README.md                              # Project documentation
└── requirements.txt                       # Python dependencies
```

## 🔍 Analysis Highlights

### **Financial Analysis**
- Analyzed **250+ properties** across **12 markets**
- Average cap rate: **8.2%** with **65%** showing positive cash flow
- Identified **30+ high-opportunity** properties with 10%+ returns

### **Market Intelligence**  
- **Austin, TX** and **Denver, CO** show strongest investment fundamentals
- **Hot markets** (< 30 days) in Phoenix, Nashville, Tampa
- **Seasonal trends** indicate Q2-Q3 optimal for purchasing

### **Risk Assessment**
- **Low-Medium Risk**: 40% of properties in stable markets
- **High-Risk**: Properties with negative cash flow or declining markets
- **Geographic diversification** recommended across 3+ states

## 💡 Business Applications

### **Investment Strategy**
- **Portfolio Construction**: Diversified real estate investment allocation
- **Market Timing**: Seasonal and cyclical opportunity identification  
- **Risk Management**: Multi-factor risk assessment and mitigation
- **Performance Tracking**: KPI monitoring and portfolio optimization

### **Decision Framework**
1. **Screening**: Filter properties by minimum cash flow and cap rate
2. **Scoring**: Apply weighted investment algorithm  
3. **Risk Assessment**: Evaluate market conditions and stability
4. **Geographic Analysis**: Optimize location diversity
5. **Execution**: Prioritize highest-scoring opportunities

## 🎓 Learning Outcomes

This project demonstrates proficiency in:
- **Advanced SQL**: CTEs, window functions, complex joins, business logic
- **Financial Analysis**: Investment metrics, cash flow modeling, risk assessment  
- **Geographic Analytics**: Location intelligence and market analysis
- **Business Intelligence**: Dashboard creation and executive reporting
- **Data Engineering**: API integration, ETL processes, database design

## 🔗 Links

- **[SQL Documentation](documentation/Real_Estate_SQL_Documentation.html)** - Detailed code explanations
- **[GitHub Repository](https://github.com/Salo996/Real-Estate-Investment-Analysis)** - Full source code
- **[Live Dashboard](visualizations/)** - Interactive visualizations

---

**Author**: Salomón Santiago  
**Contact**: salo.santiago96@gmail.com  
**LinkedIn**: [linkedin.com/in/salomon-santiago-493002a7](https://linkedin.com/in/salomon-santiago-493002a7)

*This project showcases advanced data analysis capabilities for real estate investment decision-making, combining technical skills with business acumen to deliver actionable insights.*