/*In Query #8 I sorted the user ratings into 3 clusters. Low, i.e. accommodations that have ratings less than 90. Medium, i.e. ratings between 90 and 95 and High, which have ratings greater than 95.
 I only compared Amsterdam and Budapest. I have also added the average price of the accommodation in relation to one of the clusters. 
Amsterdam as the most expensive metropolis and Budapest one of the cheapest metropolises.*/

WITH clusters AS (
    SELECT 
        city,
        guest_satisfaction,
        CASE
            WHEN guest_satisfaction < 90 THEN 'Low: Less than 90'
            WHEN guest_satisfaction >= 90 AND guest_satisfaction <= 95 THEN 'Medium: 90-95'
            ELSE 'High: More than 95'
        END AS reviews_cluster,
        price
    FROM airbnb_europe
    WHERE city = 'Budapest'
    --WHERE city = 'Amsterdam'
)

SELECT 
    reviews_cluster,
    COUNT(*) AS cluster_count,
    CAST(AVG(price) AS DECIMAL(10,2)) AS avg_price_usd
FROM clusters
GROUP BY reviews_cluster
ORDER BY cluster_count DESC;
