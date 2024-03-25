# Introduction
Here is an 🏢 analysis of the 🏘️ rental costs for apartments across nine major European cities (**Amsterdam, Athens, Barcelona, Berlin, Budapest, Lisbon, Paris, Rome, and Vienna**) as listed on Airbnb. 🌍

🔎  SQL queries can be found via this 🔗: [airbnb_sql](/airbnb_sql/)

# Background

These are some of the largest and most visited cities in Europe. 🌆 Some of them I have been to, some I would like to visit. ✈️ Thus, the price analysis can be a very good basis for future visits, both for me and for other people who might plan to check out these cities. 📊💰

One drawback I noticed with this dataset is the absence of information regarding the data collection timing. I believe the season or time of year could impact apartment prices across various European cities.

### The questions I wanted to answer through my SQL queries were:

1. What is the average price per city?
2. Is there a significant difference between weekend and weekday prices?
3. What is the availability of entire homes and private rooms?
4. Does the superhost label affect the price of accommodation?
5. How does distance from the centre affect the price of accommodation?
6. How does distance from the metro affect the price of accommodation?
7. Do reviews affect accommodation prices?

# Tech Stack
- **SQL:** Serving as the foundation of my analysis, enabling me to query the database and uncover vital insights. Specifically, I used **PostgreSQL** database management system, where I inserted the data into the database and the rest of the queries were done in **Visual Studio Code** connected to the database.

- **Tableau:** Tool I used for simple visualizations of files I exported from VS Code.

- **Git & GitHub:** Ability to share the project with others, but also easily manageable versions of my code.

# The Analysis

### 1. What is the average price per city?

In the first Query I discovered the average price of accommodation in European cities. The results are ordered from the highest average price in USD.

```sql
SELECT city, CAST(AVG(price) as numeric (10,2)) as avg_price_usd
FROM airbnb_europe
GROUP BY city
ORDER BY avg_price_usd DESC
```
Here is a table where we can see the average price of accommodation in a given city. The results are sorted from highest to lowest average price, with Amsterdam having by far the highest prices for accommodation.

|City     |Avg Price ($)|
|---------|-------------|
|Amsterdam|573.11       |
|Paris    |392.53       |
|Barcelona|293.75       |
|Berlin   |244.58       |
|Vienna   |241.58       |
|Lisbon   |238.21       |
|Rome     |205.39       |
|Budapest |176.51       |
|Athens   |151.74       |

*Table displaying average accommodation prices in USD*

### Large price range:
**Amsterdam** is almost **four times** more expensive than the cheapest **Athens**.




### 2. Is there a significant difference between weekend and weekday prices?

 Now let's see if I can find any difference between **weekday** and **weekend** prices. I used Query #1 to do this and add a Group By based on the day.
 
```sql
SELECT city, CAST(AVG(price) as numeric (10,2)) as avg_price_usd, day
FROM airbnb_europe
GROUP BY city, day
ORDER BY avg_price_usd DESC
```
![alt text](<images/Sheet 1.png>)
*Bar chart showing average prices over the weekend and during the week. Chart was made with Tableau from a file I exported from VS Code*

It can be seen from the chart that there are no significant differences in prices at the weekend and during the week. In **Amsterdam**, the difference is most pronounced, with weekend accommodation costing **USD 20** more than during the week. However, in **Paris**, for example, accommodation is **more expensive during the week** than at the weekend.

### 3. What is the availability of entire homes and private rooms?

In the third Query I discovered the type of accommodation available in European cities. 
Room type can be **Entire home/apt** or **Private room**. There are also Shared rooms in the dataset, which were significantly fewer, so they were filtered out in the condition. The results are sorted by the number of available accommodations.

```sql
SELECT city, room_type, COUNT(room_type) as count_of_apartments
FROM airbnb_europe
WHERE room_type != 'Shared room'
GROUP BY city, room_type
ORDER BY count_of_apartments DESC
```
![alt text](<images/Sheet 2.png>)
*Bar chart showing count of available entire homes vs. private rooms. Chart was made with Tableau from a file I exported from VS Code*

**Rome** boasts over **4 times** the number of available offers compared to **Amsterdam**. **Barcelona** has more than **4 times** the number of **private rooms** available than **entire houses**. Conversely, **Athens** and **Budapest** have over **12** and **8.5** times more **entire houses** than **private rooms**, respectively. This is an important consideration when searching for accommodations. In certain cities, finding an offer that fits our needs will be easier, while in others, it may prove more challenging. There are also shared rooms available, but there were very few of them, so they were filtered out.



### 4. Does the superhost label affect the price of accommodation?

Discover if it affects the price if the landlord is a superhost or not. Superhost must meet certain criteria to be able to use this designation. These include a **4.8+ overall rating**, **90% response rate** or **<1% cancellation rate**.

```sql
WITH superhost AS (
    SELECT city, 
           CASE WHEN superhost = 'True' THEN 'Superhost' ELSE 'Non-Superhost' END AS host_type,
           CAST(AVG(price) as numeric (10,2)) as avg_price_usd
    FROM airbnb_europe
    WHERE superhost IN ('True', 'False')
    GROUP BY city, host_type
)
SELECT city, 
       MAX(avg_price_usd) FILTER (WHERE host_type = 'Superhost') as superhost_avg_price,
       MAX(avg_price_usd) FILTER (WHERE host_type = 'Non-Superhost') as nonsuperhost_avg_price
FROM superhost
GROUP BY city;
```
Here is a table where we can see the price differences between superhosts and regular landlords:

|City     |Superhost Avg Price ($)|Nonsuperhost Avg Price ($)|
|---------|-------------------|----------------------|
|Amsterdam|539.43             |586.48                |
|Athens   |163.56             |142.88                |
|Barcelona|297.52             |292.92                |
|Berlin   |253.06             |241.65                |
|Budapest |169.18             |180.99                |
|Lisbon   |253.66             |234.01                |
|Paris    |410.99             |389.51                |
|Rome     |211.23             |202.56                |
|Vienna   |236.19             |243.72                |

*Table displaying the average price for accommodation for soperhost and regular landlords*

**Superhosts:** In some cases, superhost accommodation is cheaper than regular landlords. The biggest difference is noticeable in **Amsterdam**, where superhosts have an average price almost **50 USD lower** than regular landlords, which is very surprising. **Budapest** and **Vienna** have a similarly **lower price** for superhosts, but it is a much smaller difference of **USD 11** and **USD 7** respectively. 

**Nonsuperhosts:** In other cases, the prices for regular landlords are lower, but the differences are not substantial. Only for **Athens** and **Paris** is the difference more significant, where the price is about **USD 20 lower** for regular landlords compared to superhosts.

### 5. How does distance from the centre affect the price of accommodation?

In Query #5 I look at whether distance from the centre has an effect on the average price of accommodation. 
Using the case statement, I sorted the distances into 4 clusters. 
Then I ordered the results from highest to lowest average price.

```sql
SELECT 
    CASE
        WHEN city_center_km >= 0 AND city_center_km < 2 THEN '0-2 km from center'
        WHEN city_center_km >= 2 AND city_center_km < 4 THEN '2-4 km from center'
        WHEN city_center_km >= 4 AND city_center_km < 6 THEN '4-6 km from center'
        ELSE 'Beyond 6 km from center'
    END AS distance_group,
    CAST(AVG(price) as numeric (10,2)) as avg_price_usd
FROM airbnb_europe
GROUP BY distance_group
ORDER BY avg_price_usd DESC;
```
Here is a table where we can see how distance from the centre affects the average price of accommodation.
Accommodation are categorized into four groups:

**0-2 km** from the center, **2-4 km** from the center, **4-6 km** from the center and **more than 6 km** from the center.

|Distance Group|Avg Price ($)|
|--------------|-------------|
|0-2 km from center|270.71       |
|2-4 km from center|259.49       |
|4-6 km from center|247.11       |
|Beyond 6 km from center|213.13       

*Table displaying the the average price of accommodation in relation to the distance from the centre*

The results clearly show that the closer to the centre, the higher the price, which is to be expected. Every **2 km increases** the average price by about **$10**, but of course people often pay that on transportation in the city, so it depends on whether you prioritize convenience or price. However, if someone doesn't mind being further from the center or is directly seeking it, they can find very good **bargains** in accommodations **more than 6 km away**.

### 6. How does distance from the metro affect the price of accommodation?

In Query #6 I used the same logic as in Query #5. 
However, I needed more clusters into which I sorted the accommodation according to distance from the metro. Here I ordered the results by distance from smallest to largest.

```sql
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
    CAST(AVG(price) as numeric (10,2)) as avg_price_usd
FROM airbnb_europe
GROUP BY distance_group
ORDER BY distance_group
```

|Distance Group|Avg Price ($)|
|--------------|-------------|
|0-0.5 km from metro|270.14       |
|0.5-1 km from metro|235.50       |
|1-1.5 km from metro|256.39       |
|1.5-2 km from metro|279.96       |
|2-2.5 km from metro|261.34       |
|2.5-3 km from metro|208.80       |
|Beyond 3 km from the metro|207.47       |

*Table displaying the the average price of accommodation in relation to the distance from the metro*

What is interesting about these results is that the distance from the metro does not affect the average price of accommodation as much as the distance from the centre. We can see a relatively large price range here, with the very **highest average price** for accommodation within **1.5-2 km**. On the other hand, the price at distances of **0.5-1 km** from the metro is relatively low at **$235.5**. For distances of **more than 3 km** from the metro, the prices are logically the **lowest**, which is probably related to the overall higher distance from the centre.


### 7. Do reviews affect accommodation prices?

In Query #8 I sorted the user ratings into **3 clusters**. **Low**, i.e. accommodations that have ratings **less than 90**. **Medium**, i.e. ratings **between 90 and 95** and **High**, which have ratings **greater than 95**.

I only compared **Amsterdam** and **Budapest**, but the analysis can be applied to all the cities mentioned. I have also added the average price of the accommodation in relation to one of the clusters. Amsterdam as the most expensive metropolis and Budapest one of the cheapest metropolises.
 

```sql
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
```
### Amsterdam

|Reviews Cluster|Cluster Count|Avg Price ($)|
|---------------|-------------|-------------|
|High: More than 95|1169         |626.24       |
|Medium: 90-95  |610          |520.77       |
|Low: Less than 90|301          |472.86       |

*Table showing the number of ratings in relation to one of the 3 rating clusters and the average price in USD in relation to the cluster. (Amsterdam)*

### Budapest

|Reviews Cluster|Cluster Count|Avg Price ($)|
|---------------|-------------|-------------|
|High: More than 95|2243         |180.84       |
|Medium: 90-95  |1281         |167.06       |
|Low: Less than 90|498          |181.33       |

*Table showing the number of ratings in relation to one of the 3 rating clusters and the average price in USD in relation to the cluster. (Budapest)*

**Amsterdam:** The results were as most would have expected. The better the reviews, the higher the average price. The birthmarks are quite noticeable. For accommodations with a rating of **more than 95%**, the average price is **more than $100 higher** than accommodations with a rating **between 90-95%**, which is still very good rating. 

**Budapest:** The results are quite surprising. Very high average price is of course for accommodation with a rating of more than 95%, but **the highest average price** is for accommodation with a rating of **90 or less**, the lowest cluster, which is rather strange. Thus, in the case of Budapest, it is by far the most advantageous to look for accommodation in the **90-95%** rating range with an average price of **$167**. 

# Conclusions
1. **Average price per city**: **Amsterdam** has the highest average price for accommodation in Europe with a price tag of **$573**. The lowest is **Athens** 🏛️  with a price tag of **$151**. Amsterdam is almost four times more expensive than Athens! 💰🌍
 
2. **Difference between weekend and weekday prices**: There are no substantial differences in prices between weekends and weekdays across most cities, **Amsterdam** 🌆  stands out with a weekend accommodation cost of **$20** more than weekdays, contrasting with Paris, where weekday stays are more expensive than weekends. 📅💸

3. **Availability of entire homes and private rooms**: 
When considering accommodations, **Rome** 🏰 offers more than **4 times** the options of **Amsterdam**, while **Barcelona** 🏠 boasts over **4 times** the availability of private rooms compared to entire houses. Conversely, **Athens** 🏛️ and **Budapest** 🏡 provide over **12** and **8.5 times more** entire houses than private rooms, respectively. This diversity is crucial to keep in mind when searching for suitable stays across these cities. 🌍✨

4. **Affect of the superhost label on price of accommodation**: 
🌟 In some cases, superhost accommodations offer **lower prices** compared to regular landlords. The most noticeable contrast is seen in **Amsterdam**, where superhosts boast an average price almost **$50 lower** than regular landlords—a pleasantly surprising find! 🏠✨
On the other hand, for regular landlords, prices are generally lower, although the variances are not substantial. Notable exceptions include **Athens** and **Paris**, where prices are approximately **$20 lower** for regular landlords compared to superhosts. 🌆💰

5. **Distance from the centre and influence on average price**: 
Every **2 km** increase raises the average price by about **$10**. However people often spend that money on transportation in the city, so it depends on whether you prioritize convenience or price. 🚗💵 However, if someone doesn't mind being further from the center or is specifically seeking it, they can find **very good bargains** in accommodations **more than 6 km away**. 🏙️🏠

6. **Distance from the metro and influence on average price**:
Distance from the metro does **not affect** the average price of accommodation as much as **the distance from the centre**. 🚇 We can see a relatively large price range here, with the very highest average price for accommodation within **1.5-2 km**. 🏢 On the other hand, the price at distances of **0.5-1 km** from the metro is relatively **low** at **$235.5**. 💰 For distances of **more than 3 km** from the metro, the prices are **the lowest**. 📉💲 

7. **Reviews and price of accommodation**:
As expected, In **Amsterdam** higher reviews correlate with higher prices. 🌟 Accommodations with a rating of more than **95%** have an average price over **$100 higher** than those rated between **90-95%**, still a commendable rating range. 💰 Surprisingly, In **Budapest** the highest average price is found in accommodations with a rating of **90% or less**. Therefore, for Budapest, it's most advantageous to seek accommodations in the **90-95%** rating range, with an average price of **$167**.
Higher ratings do not always mean higher prices. 🔍