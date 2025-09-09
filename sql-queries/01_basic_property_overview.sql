-- Real Estate Investment Analysis - Query 1: Basic Property Overview
-- Difficulty Level: EASY
-- Purpose: Basic data exploration and property statistics

-- Description: This query provides fundamental insights into our real estate dataset
-- including total properties, average prices, and basic property characteristics

SELECT 
    COUNT(*) as total_properties,
    AVG(price) as avg_property_price,
    MIN(price) as min_price,
    MAX(price) as max_price,
    AVG(bedrooms) as avg_bedrooms,
    AVG(bathrooms) as avg_bathrooms,
    AVG(square_feet) as avg_square_feet
FROM properties 
WHERE price > 0 AND price < 10000000;  -- Filter out outliers

-- Additional basic exploration
SELECT 
    property_type,
    COUNT(*) as property_count,
    AVG(price) as avg_price_by_type
FROM properties 
WHERE price > 0 
GROUP BY property_type 
ORDER BY property_count DESC;