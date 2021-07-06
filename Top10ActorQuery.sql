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