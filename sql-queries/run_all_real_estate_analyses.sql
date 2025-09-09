-- Real Estate Investment Analysis - Master Query Runner
-- Execute all Real Estate analysis queries in sequence
-- Purpose: Comprehensive real estate investment analysis pipeline

-- =============================================
-- REAL ESTATE INVESTMENT ANALYSIS PIPELINE
-- =============================================
-- This script runs all real estate analyses in logical order
-- from basic exploration to advanced investment scoring

-- Prerequisites:
-- 1. Database with populated 'properties' table
-- 2. Optional: 'market_data' and 'economic_indicators' tables for advanced analysis
-- 3. Required fields: property_id, address, city, state, zip_code, price, 
--    bedrooms, bathrooms, square_feet, estimated_rental_income, property_taxes

PRINT 'Starting Real Estate Investment Analysis Pipeline...';
PRINT '====================================================';

-- =============================================
-- ANALYSIS 1: BASIC PROPERTY OVERVIEW (EASY)
-- =============================================
PRINT '';
PRINT '1. BASIC PROPERTY OVERVIEW';
PRINT '==========================';
\i 01_basic_property_overview.sql

-- =============================================  
-- ANALYSIS 2: LOCATION PRICE ANALYSIS (EASY)
-- =============================================
PRINT '';
PRINT '2. LOCATION-BASED PRICE ANALYSIS';
PRINT '=================================';
\i 02_location_price_analysis.sql

-- =============================================
-- ANALYSIS 3: INVESTMENT ROI CALCULATOR (MEDIUM)
-- =============================================
PRINT '';
PRINT '3. INVESTMENT ROI CALCULATOR';
PRINT '============================';
\i 03_investment_roi_calculator.sql

-- =============================================
-- ANALYSIS 4: MARKET TRENDS ANALYSIS (MEDIUM)
-- =============================================  
PRINT '';
PRINT '4. MARKET TRENDS ANALYSIS';
PRINT '=========================';
\i 04_market_trends_analysis.sql

-- =============================================
-- ANALYSIS 5: ADVANCED INVESTMENT SCORING (MEDIUM-HARD)
-- =============================================
PRINT '';
PRINT '5. ADVANCED INVESTMENT SCORING';
PRINT '==============================';
\i 05_advanced_investment_scoring.sql

-- =============================================
-- ANALYSIS SUMMARY
-- =============================================
PRINT '';
PRINT 'REAL ESTATE ANALYSIS SUMMARY';
PRINT '============================';

-- Executive summary query
WITH analysis_summary AS (
    SELECT 
        COUNT(*) as total_properties_analyzed,
        AVG(price) as avg_property_price,
        COUNT(CASE WHEN estimated_rental_income > 0 THEN 1 END) as rental_properties,
        AVG(CASE WHEN estimated_rental_income > 0 THEN estimated_rental_income * 12 / price * 100 END) as avg_cap_rate,
        COUNT(DISTINCT state) as states_covered,
        COUNT(DISTINCT city) as cities_covered
    FROM properties 
    WHERE price > 0
)

SELECT 
    'EXECUTIVE SUMMARY' as analysis_type,
    CONCAT('Analyzed ', total_properties_analyzed, ' properties') as key_insight_1,
    CONCAT('Average price: $', FORMAT(avg_property_price, 0)) as key_insight_2,
    CONCAT('Rental properties: ', rental_properties, ' (', 
           ROUND(rental_properties * 100.0 / total_properties_analyzed, 1), '%)') as key_insight_3,
    CONCAT('Average cap rate: ', ROUND(avg_cap_rate, 1), '%') as key_insight_4,
    CONCAT('Geographic coverage: ', states_covered, ' states, ', cities_covered, ' cities') as key_insight_5
FROM analysis_summary;

PRINT '';
PRINT 'Real Estate Investment Analysis Pipeline Completed Successfully!';
PRINT '================================================================';