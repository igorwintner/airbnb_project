/*In the first Query I look at the average price of accommodation in European cities.
The results are ordered from the highest average price in USD.*/

SELECT city, CAST(AVG(price) as numeric (10,2)) as avg_price_usd
FROM airbnb_europe
GROUP BY city
ORDER BY avg_price_usd DESC
