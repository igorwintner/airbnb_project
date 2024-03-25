/*In the third Query I look at the type of accommodation available in European cities. 
Room type can be Entire home/apt or Private room. There are also Shared rooms in the dataset, which were significantly fewer, so they were filtered out in the condition. 
The results are sorted by the number of available accommodations.*/

SELECT city, room_type, COUNT(room_type) as count_of_apartments
FROM airbnb_europe
WHERE room_type != 'Shared room'
GROUP BY city, room_type
ORDER BY count_of_apartments DESC