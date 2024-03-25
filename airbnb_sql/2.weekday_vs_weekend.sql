/*Now let's see if I can find any difference between weekday and weekend prices.
I'll use Query #1 to do this and add a Group By based on the day.*/

-- Use Query #1

SELECT city, CAST(AVG(price) as numeric (10,2)) as avg_price_usd, day
FROM airbnb_europe
GROUP BY city, day
ORDER BY avg_price_usd DESC