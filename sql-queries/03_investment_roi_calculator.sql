-- Real Estate Investment Analysis - Query 3: Investment ROI Calculator
-- Difficulty Level: MEDIUM
-- Purpose: Calculate return on investment metrics for rental properties

-- Description: ROI analysis with cap rates and cash flow calculations
-- for rental property evaluation and investment decisions

SELECT 
    property_id,
    address,
    city,
    state,
    price,
    bedrooms,
    bathrooms,
    square_feet,
    estimated_rental_income as monthly_rent,
    
    -- Annual rental income
    (estimated_rental_income * 12) as annual_rental_income,
    
    -- Basic investment assumptions
    (price * 0.20) as down_payment_20_percent,
    (price * 0.80 * 0.045 / 12) as monthly_mortgage_payment, -- 4.5% interest rate
    (property_taxes / 12) as monthly_property_taxes,
    (estimated_rental_income * 0.08) as monthly_maintenance, -- 8% for maintenance
    
    -- Monthly cash flow calculation
    (estimated_rental_income - 
     (price * 0.80 * 0.045 / 12) - 
     (property_taxes / 12) - 
     (estimated_rental_income * 0.08)
    ) as monthly_cash_flow,
    
    -- Cap Rate: Annual rental income / Purchase price
    ROUND((estimated_rental_income * 12) / price * 100, 2) as cap_rate_percent,
    
    -- Cash-on-Cash Return: Annual cash flow / Down payment
    ROUND(
        ((estimated_rental_income - 
          (price * 0.80 * 0.045 / 12) - 
          (property_taxes / 12) - 
          (estimated_rental_income * 0.08)
         ) * 12) / (price * 0.20) * 100, 2
    ) as cash_on_cash_return_percent,
    
    -- Price per square foot
    ROUND(price / square_feet, 2) as price_per_sqft

FROM properties 
WHERE price > 0 
  AND estimated_rental_income > 0 
  AND property_taxes > 0
  AND square_feet > 0
  -- Only show profitable properties (positive cash flow)
  AND (estimated_rental_income - 
       (price * 0.80 * 0.045 / 12) - 
       (property_taxes / 12) - 
       (estimated_rental_income * 0.08)
      ) > 0
ORDER BY cash_on_cash_return_percent DESC
LIMIT 25;