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

