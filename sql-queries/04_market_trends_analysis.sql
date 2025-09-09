-- Real Estate Investment Analysis - Query 4: Market Trends Analysis
-- Difficulty Level: MEDIUM
-- Purpose: Analyze market trends and seasonal patterns

-- Business Question: What are the current market trends by season and location 
-- to identify optimal buying/selling opportunities?

-- Description: Quarterly price analysis, seasonal patterns, and market heat 
-- indicators to guide investment timing decisions

SELECT 
    EXTRACT(YEAR FROM listing_date) as year,
    EXTRACT(QUARTER FROM listing_date) as quarter,
    
    -- Season classification
    CASE 
        WHEN EXTRACT(MONTH FROM listing_date) IN (12, 1, 2) THEN 'Winter'
        WHEN EXTRACT(MONTH FROM listing_date) IN (3, 4, 5) THEN 'Spring'
        WHEN EXTRACT(MONTH FROM listing_date) IN (6, 7, 8) THEN 'Summer'
        WHEN EXTRACT(MONTH FROM listing_date) IN (9, 10, 11) THEN 'Fall'
    END as season,
    
    -- Basic market metrics
    COUNT(*) as listings_count,
    ROUND(AVG(price), 0) as avg_price,
    ROUND(AVG(days_on_market), 1) as avg_days_on_market,
    ROUND(AVG(price / square_feet), 2) as avg_price_per_sqft,
    
    -- Market velocity indicator (higher = faster market)
    ROUND(1000.0 / AVG(days_on_market), 2) as market_velocity_index,
    
    -- Market classification based on days on market
    CASE 
        WHEN AVG(days_on_market) <= 30 THEN 'Hot Market'
        WHEN AVG(days_on_market) <= 60 THEN 'Warm Market'
        WHEN AVG(days_on_market) <= 90 THEN 'Balanced Market'
        ELSE 'Cold Market'
    END as market_temperature,
    
    -- Seasonal opportunity score (lower price + faster sales = better for buyers)
    ROUND(
        (1000.0 / AVG(days_on_market)) * 
        (1.0 / (AVG(price) / 100000)), 2
    ) as buyer_opportunity_score
    
FROM properties 
WHERE listing_date IS NOT NULL 
  AND listing_date >= '2022-01-01'  -- Focus on recent trends
  AND price > 0 
  AND days_on_market > 0
  AND square_feet > 0
GROUP BY 
    EXTRACT(YEAR FROM listing_date), 
    EXTRACT(QUARTER FROM listing_date),
    CASE 
        WHEN EXTRACT(MONTH FROM listing_date) IN (12, 1, 2) THEN 'Winter'
        WHEN EXTRACT(MONTH FROM listing_date) IN (3, 4, 5) THEN 'Spring'
        WHEN EXTRACT(MONTH FROM listing_date) IN (6, 7, 8) THEN 'Summer'
        WHEN EXTRACT(MONTH FROM listing_date) IN (9, 10, 11) THEN 'Fall'
    END
HAVING COUNT(*) >= 5  -- Ensure statistical significance
ORDER BY year DESC, quarter DESC
LIMIT 20;