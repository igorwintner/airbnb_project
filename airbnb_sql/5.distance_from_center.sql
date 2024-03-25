/*In Query #5 I look at whether distance from the centre has an effect on the average price of accommodation. 
Using the case statement, I sorted the distances into 4 clusters. 
Then I ordered the results from highest to lowest average price.*/ 

SELECT 
    CASE
        WHEN city_center_km >= 0 AND city_center_km < 2 THEN '0-2 km from center'
        WHEN city_center_km >= 2 AND city_center_km < 4 THEN '2-4 km from center'
        WHEN city_center_km >= 4 AND city_center_km < 6 THEN '4-6 km from center'
        ELSE 'Beyond 6 km from center'
    END AS distance_group,
    CAST(AVG(price) as numeric (36,2)) as avg_price_usd
FROM airbnb_europe
GROUP BY distance_group
ORDER BY avg_price_usd DESC;