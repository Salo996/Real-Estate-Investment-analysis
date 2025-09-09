-- Real Estate Investment Analysis - Query 2: Location-Based Price Analysis  
-- Difficulty Level: EASY
-- Purpose: Analyze property prices by geographic location

-- Description: Examines average property prices by state, city, and zip code
-- to identify high-value and affordable markets

-- Average prices by state
SELECT 
    state,
    COUNT(*) as property_count,
    AVG(price) as avg_price,
    AVG(price_per_sqft) as avg_price_per_sqft
FROM properties 
WHERE price > 0 AND square_feet > 0
GROUP BY state 
ORDER BY avg_price DESC 
LIMIT 15;

-- Top 10 most expensive cities
SELECT 
    city,
    state,
    COUNT(*) as property_count,
    AVG(price) as avg_price,
    ROUND(AVG(price_per_sqft), 2) as avg_price_per_sqft
FROM properties 
WHERE price > 0 AND square_feet > 0
GROUP BY city, state 
HAVING COUNT(*) >= 5  -- Only cities with at least 5 properties
ORDER BY avg_price DESC 
LIMIT 10;

-- Zip code analysis for investment opportunities
SELECT 
    zip_code,
    city,
    state,
    COUNT(*) as available_properties,
    AVG(price) as avg_price,
    AVG(estimated_rental_income) as avg_rental_income,
    ROUND(AVG(estimated_rental_income * 12 / price * 100), 2) as rental_yield_percent
FROM properties 
WHERE price > 0 AND estimated_rental_income > 0
GROUP BY zip_code, city, state
HAVING COUNT(*) >= 3
ORDER BY rental_yield_percent DESC 
LIMIT 20;