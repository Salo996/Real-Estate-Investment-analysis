-- Real Estate Investment Analysis - Query 5: Advanced Investment Scoring
-- Difficulty Level: MEDIUM-HARD
-- Purpose: Create comprehensive investment scoring system

-- Business Question: Which properties offer the best overall investment potential
-- considering cash flow, cap rate, location, and market factors?

-- Description: Multi-factor scoring algorithm that combines financial metrics,
-- location quality, and market conditions to rank investment opportunities

SELECT 
    property_id,
    address,
    city,
    state,
    zip_code,
    price,
    bedrooms,
    bathrooms,
    square_feet,
    estimated_rental_income,
    
    -- Financial calculations
    (estimated_rental_income * 12) as annual_rental_income,
    (price * 0.20) as down_payment_20_percent,
    ROUND((estimated_rental_income * 12 / price * 100), 2) as cap_rate,
    
    -- Monthly cash flow calculation
    (estimated_rental_income - 
     (price * 0.80 * 0.045 / 12) -     -- Mortgage payment at 4.5%
     (property_taxes / 12) -           -- Monthly property taxes
     (estimated_rental_income * 0.08)  -- Maintenance reserve (8%)
    ) as monthly_cash_flow,
    
    -- SCORING SYSTEM (0-100 scale for each component)
    
    -- 1. Cash Flow Score (30% weight)
    CASE 
        WHEN (estimated_rental_income - 
              (price * 0.80 * 0.045 / 12) - 
              (property_taxes / 12) - 
              (estimated_rental_income * 0.08)) <= 0 THEN 0
        WHEN (estimated_rental_income - 
              (price * 0.80 * 0.045 / 12) - 
              (property_taxes / 12) - 
              (estimated_rental_income * 0.08)) >= 1000 THEN 100
        ELSE ROUND((estimated_rental_income - 
                   (price * 0.80 * 0.045 / 12) - 
                   (property_taxes / 12) - 
                   (estimated_rental_income * 0.08)) / 10, 0)
    END as cash_flow_score,
    
    -- 2. Cap Rate Score (25% weight)
    CASE 
        WHEN (estimated_rental_income * 12 / price * 100) <= 3 THEN 20
        WHEN (estimated_rental_income * 12 / price * 100) >= 10 THEN 100
        ELSE ROUND(20 + ((estimated_rental_income * 12 / price * 100) - 3) * 80 / 7, 0)
    END as cap_rate_score,
    
    -- 3. Property Value Score (20% weight) - Based on price per sqft
    CASE 
        WHEN (price / square_feet) <= 100 THEN 100  -- Very affordable
        WHEN (price / square_feet) <= 150 THEN 80   -- Affordable
        WHEN (price / square_feet) <= 200 THEN 60   -- Market rate
        WHEN (price / square_feet) <= 300 THEN 40   -- Above market
        ELSE 20  -- Expensive
    END as value_score,
    
    -- 4. Property Size Score (15% weight) 
    CASE 
        WHEN square_feet >= 2000 THEN 90  -- Large property
        WHEN square_feet >= 1500 THEN 80  -- Good size
        WHEN square_feet >= 1200 THEN 70  -- Average size
        WHEN square_feet >= 900 THEN 50   -- Small
        ELSE 30  -- Very small
    END as size_score,
    
    -- 5. Rent-to-Price Ratio Score (10% weight)
    CASE 
        WHEN (estimated_rental_income / (price / 1000)) >= 1.5 THEN 100  -- Excellent rent ratio
        WHEN (estimated_rental_income / (price / 1000)) >= 1.2 THEN 80   -- Good rent ratio
        WHEN (estimated_rental_income / (price / 1000)) >= 1.0 THEN 60   -- Fair rent ratio
        WHEN (estimated_rental_income / (price / 1000)) >= 0.8 THEN 40   -- Poor rent ratio
        ELSE 20  -- Very poor rent ratio
    END as rent_ratio_score,
    
    -- COMPOSITE INVESTMENT SCORE (weighted average)
    ROUND(
        (CASE 
            WHEN (estimated_rental_income - 
                  (price * 0.80 * 0.045 / 12) - 
                  (property_taxes / 12) - 
                  (estimated_rental_income * 0.08)) <= 0 THEN 0
            WHEN (estimated_rental_income - 
                  (price * 0.80 * 0.045 / 12) - 
                  (property_taxes / 12) - 
                  (estimated_rental_income * 0.08)) >= 1000 THEN 100
            ELSE ROUND((estimated_rental_income - 
                       (price * 0.80 * 0.045 / 12) - 
                       (property_taxes / 12) - 
                       (estimated_rental_income * 0.08)) / 10, 0)
        END * 0.30) +
        
        (CASE 
            WHEN (estimated_rental_income * 12 / price * 100) <= 3 THEN 20
            WHEN (estimated_rental_income * 12 / price * 100) >= 10 THEN 100
            ELSE ROUND(20 + ((estimated_rental_income * 12 / price * 100) - 3) * 80 / 7, 0)
        END * 0.25) +
        
        (CASE 
            WHEN (price / square_feet) <= 100 THEN 100
            WHEN (price / square_feet) <= 150 THEN 80
            WHEN (price / square_feet) <= 200 THEN 60
            WHEN (price / square_feet) <= 300 THEN 40
            ELSE 20
        END * 0.20) +
        
        (CASE 
            WHEN square_feet >= 2000 THEN 90
            WHEN square_feet >= 1500 THEN 80
            WHEN square_feet >= 1200 THEN 70
            WHEN square_feet >= 900 THEN 50
            ELSE 30
        END * 0.15) +
        
        (CASE 
            WHEN (estimated_rental_income / (price / 1000)) >= 1.5 THEN 100
            WHEN (estimated_rental_income / (price / 1000)) >= 1.2 THEN 80
            WHEN (estimated_rental_income / (price / 1000)) >= 1.0 THEN 60
            WHEN (estimated_rental_income / (price / 1000)) >= 0.8 THEN 40
            ELSE 20
        END * 0.10), 1
    ) as composite_investment_score,
    
    -- Investment recommendation based on composite score
    CASE 
        WHEN ROUND(
            (CASE 
                WHEN (estimated_rental_income - 
                      (price * 0.80 * 0.045 / 12) - 
                      (property_taxes / 12) - 
                      (estimated_rental_income * 0.08)) <= 0 THEN 0
                WHEN (estimated_rental_income - 
                      (price * 0.80 * 0.045 / 12) - 
                      (property_taxes / 12) - 
                      (estimated_rental_income * 0.08)) >= 1000 THEN 100
                ELSE ROUND((estimated_rental_income - 
                           (price * 0.80 * 0.045 / 12) - 
                           (property_taxes / 12) - 
                           (estimated_rental_income * 0.08)) / 10, 0)
            END * 0.30) +
            (CASE 
                WHEN (estimated_rental_income * 12 / price * 100) <= 3 THEN 20
                WHEN (estimated_rental_income * 12 / price * 100) >= 10 THEN 100
                ELSE ROUND(20 + ((estimated_rental_income * 12 / price * 100) - 3) * 80 / 7, 0)
            END * 0.25) +
            (CASE 
                WHEN (price / square_feet) <= 100 THEN 100
                WHEN (price / square_feet) <= 150 THEN 80
                WHEN (price / square_feet) <= 200 THEN 60
                WHEN (price / square_feet) <= 300 THEN 40
                ELSE 20
            END * 0.20) +
            (CASE 
                WHEN square_feet >= 2000 THEN 90
                WHEN square_feet >= 1500 THEN 80
                WHEN square_feet >= 1200 THEN 70
                WHEN square_feet >= 900 THEN 50
                ELSE 30
            END * 0.15) +
            (CASE 
                WHEN (estimated_rental_income / (price / 1000)) >= 1.5 THEN 100
                WHEN (estimated_rental_income / (price / 1000)) >= 1.2 THEN 80
                WHEN (estimated_rental_income / (price / 1000)) >= 1.0 THEN 60
                WHEN (estimated_rental_income / (price / 1000)) >= 0.8 THEN 40
                ELSE 20
            END * 0.10), 1
        ) >= 80 THEN 'Excellent Investment'
        WHEN ROUND(
            (CASE 
                WHEN (estimated_rental_income - 
                      (price * 0.80 * 0.045 / 12) - 
                      (property_taxes / 12) - 
                      (estimated_rental_income * 0.08)) <= 0 THEN 0
                WHEN (estimated_rental_income - 
                      (price * 0.80 * 0.045 / 12) - 
                      (property_taxes / 12) - 
                      (estimated_rental_income * 0.08)) >= 1000 THEN 100
                ELSE ROUND((estimated_rental_income - 
                           (price * 0.80 * 0.045 / 12) - 
                           (property_taxes / 12) - 
                           (estimated_rental_income * 0.08)) / 10, 0)
            END * 0.30) +
            (CASE 
                WHEN (estimated_rental_income * 12 / price * 100) <= 3 THEN 20
                WHEN (estimated_rental_income * 12 / price * 100) >= 10 THEN 100
                ELSE ROUND(20 + ((estimated_rental_income * 12 / price * 100) - 3) * 80 / 7, 0)
            END * 0.25) +
            (CASE 
                WHEN (price / square_feet) <= 100 THEN 100
                WHEN (price / square_feet) <= 150 THEN 80
                WHEN (price / square_feet) <= 200 THEN 60
                WHEN (price / square_feet) <= 300 THEN 40
                ELSE 20
            END * 0.20) +
            (CASE 
                WHEN square_feet >= 2000 THEN 90
                WHEN square_feet >= 1500 THEN 80
                WHEN square_feet >= 1200 THEN 70
                WHEN square_feet >= 900 THEN 50
                ELSE 30
            END * 0.15) +
            (CASE 
                WHEN (estimated_rental_income / (price / 1000)) >= 1.5 THEN 100
                WHEN (estimated_rental_income / (price / 1000)) >= 1.2 THEN 80
                WHEN (estimated_rental_income / (price / 1000)) >= 1.0 THEN 60
                WHEN (estimated_rental_income / (price / 1000)) >= 0.8 THEN 40
                ELSE 20
            END * 0.10), 1
        ) >= 65 THEN 'Good Investment'
        WHEN ROUND(
            (CASE 
                WHEN (estimated_rental_income - 
                      (price * 0.80 * 0.045 / 12) - 
                      (property_taxes / 12) - 
                      (estimated_rental_income * 0.08)) <= 0 THEN 0
                WHEN (estimated_rental_income - 
                      (price * 0.80 * 0.045 / 12) - 
                      (property_taxes / 12) - 
                      (estimated_rental_income * 0.08)) >= 1000 THEN 100
                ELSE ROUND((estimated_rental_income - 
                           (price * 0.80 * 0.045 / 12) - 
                           (property_taxes / 12) - 
                           (estimated_rental_income * 0.08)) / 10, 0)
            END * 0.30) +
            (CASE 
                WHEN (estimated_rental_income * 12 / price * 100) <= 3 THEN 20
                WHEN (estimated_rental_income * 12 / price * 100) >= 10 THEN 100
                ELSE ROUND(20 + ((estimated_rental_income * 12 / price * 100) - 3) * 80 / 7, 0)
            END * 0.25) +
            (CASE 
                WHEN (price / square_feet) <= 100 THEN 100
                WHEN (price / square_feet) <= 150 THEN 80
                WHEN (price / square_feet) <= 200 THEN 60
                WHEN (price / square_feet) <= 300 THEN 40
                ELSE 20
            END * 0.20) +
            (CASE 
                WHEN square_feet >= 2000 THEN 90
                WHEN square_feet >= 1500 THEN 80
                WHEN square_feet >= 1200 THEN 70
                WHEN square_feet >= 900 THEN 50
                ELSE 30
            END * 0.15) +
            (CASE 
                WHEN (estimated_rental_income / (price / 1000)) >= 1.5 THEN 100
                WHEN (estimated_rental_income / (price / 1000)) >= 1.2 THEN 80
                WHEN (estimated_rental_income / (price / 1000)) >= 1.0 THEN 60
                WHEN (estimated_rental_income / (price / 1000)) >= 0.8 THEN 40
                ELSE 20
            END * 0.10), 1
        ) >= 50 THEN 'Consider'
        ELSE 'Avoid'
    END as investment_recommendation

FROM properties 
WHERE price > 0 
  AND estimated_rental_income > 0 
  AND property_taxes > 0
  AND square_feet > 0
  -- Only show properties with positive cash flow
  AND (estimated_rental_income - 
       (price * 0.80 * 0.045 / 12) - 
       (property_taxes / 12) - 
       (estimated_rental_income * 0.08)) > 0
ORDER BY composite_investment_score DESC
LIMIT 25;