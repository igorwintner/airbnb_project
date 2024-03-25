/*In Query 4 I compare the average price ($) in European cities if the landlord has the 'Superhost' label. 
Superhost must meet certain criteria to be able to use this designation. 
These include a 4.8+ overall rating, 90% response rate or <1% cancellation rate.*/

WITH superhost AS (
    SELECT city, 
           CASE WHEN superhost = 'True' THEN 'Superhost' ELSE 'Non-Superhost' END AS host_type,
           CAST(AVG(price) as numeric (36,2)) as avg_price_usd
    FROM airbnb_europe
    WHERE superhost IN ('True', 'False')
    GROUP BY city, host_type
)
SELECT city, 
       MAX(avg_price_usd) FILTER (WHERE host_type = 'Superhost') as superhost_avg_price,
       MAX(avg_price_usd) FILTER (WHERE host_type = 'Non-Superhost') as nonsuperhost_avg_price
FROM superhost
GROUP BY city;