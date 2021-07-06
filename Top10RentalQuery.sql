SELECT f.title film_title, COUNT(r.rental_date) rental_count
FROM rental r
JOIN inventory i
ON i.inventory_id = r.inventory_id
JOIN film f
ON f.film_id = i.film_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;