/*In Query #6 I use the same logic as in Query #5. 
However, I need more clusters into which I sort the accommodation according to distance from the metro.
Here I ordered the results by distance from smallest to largest.*/

SELECT 
    CASE
        WHEN metro_distance_km >= 0 AND metro_distance_km < 0.5 THEN '0-0.5 km from metro'
        WHEN metro_distance_km >= 0.5 AND metro_distance_km < 1 THEN '0.5-1 km from metro'
        WHEN metro_distance_km >= 1 AND metro_distance_km < 1.5 THEN '1-1.5 km from metro'
        WHEN metro_distance_km >= 1.5 AND metro_distance_km < 2 THEN '1.5-2 km from metro'
        WHEN metro_distance_km >= 2 AND metro_distance_km < 2.5 THEN '2-2.5 km from metro'
        WHEN metro_distance_km >= 2.5 AND metro_distance_km < 3 THEN '2.5-3 km from metro'
        ELSE 'Beyond 3 km from the metro'
    END AS distance_group,
    CAST(AVG(price) as numeric (36,2)) as avg_price_usd
FROM airbnb_europe
GROUP BY distance_group
ORDER BY distance_group