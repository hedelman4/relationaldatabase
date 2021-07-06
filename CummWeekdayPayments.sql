WITH t1 AS (SELECT EXTRACT('dow' FROM r.rental_date) weekday_number, SUM(p.amount) daily_total,
SUM(SUM(p.amount)) OVER (ORDER BY EXTRACT('dow' FROM r.rental_date)) AS running_total
FROM rental r
JOIN payment p
ON r.rental_id = p.rental_id
JOIN staff s
ON s.staff_id = p.staff_id
JOIN store st
ON st.store_id = s.store_id
GROUP BY 1
ORDER BY 1)

SELECT t1.*, 
CASE WHEN t1.weekday_number = '0' THEN 'Sunday'
WHEN t1.weekday_number = '1' THEN 'Monday'
WHEN t1.weekday_number = '2' THEN 'Tuesday'
WHEN t1.weekday_number = '3' THEN 'Wednesday'
WHEN t1.weekday_number = '4' THEN 'Thursday'
WHEN t1.weekday_number = '5' THEN 'Friday'
WHEN t1.weekday_number = '6' THEN 'Saturday' END AS weekday
FROM t1;