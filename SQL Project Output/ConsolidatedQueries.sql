SELECT f.title film_title, COUNT(r.rental_date) rental_count
FROM rental r
JOIN inventory i
ON i.inventory_id = r.inventory_id
JOIN film f
ON f.film_id = i.film_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

SELECT (a.first_name || ' ' || a.last_name) full_name, SUM(p.amount)
FROM rental r
JOIN inventory i
ON i.inventory_id = r.inventory_id
JOIN film f
ON f.film_id = i.film_id
JOIN film_actor fa
ON f.film_id = fa.film_id
JOIN actor a
ON fa.actor_id = a.actor_id
JOIN payment p
ON r.rental_id = p.rental_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

WITH t1 AS (SELECT (c.city || ', ' || co.country) city_country, DATE_TRUNC('month',p.payment_date) AS month, SUM(p.amount) total_usd
FROM payment p
JOIN staff s
ON s.staff_id = p.staff_id
JOIN store st
ON st.store_id = s.store_id
JOIN address a
ON a.address_id = st.address_id
JOIN city c
ON c.city_id = a.city_id
JOIN country co
ON co.country_id = c.country_id
GROUP BY 1,2
ORDER BY 2),

t2 AS (SELECT t1.month AS month, MAX(t1.total_usd) max_month
FROM t1
GROUP BY 1
ORDER BY 1)

SELECT t2.*, t1.city_country
FROM t2
JOIN t1
ON t1.total_usd = t2.max_month;

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
