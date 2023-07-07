use sakila;
-- 1. Number of copies of the film "Hunchback Impossible" in the inventory system:
SELECT COUNT(*) FROM inventory 
WHERE film_id = (SELECT film_id FROM film WHERE title = 'Hunchback Impossible');

-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT title FROM film 
WHERE length > (SELECT AVG(length) FROM film);

-- 3. Actors who appear in the film "Alone Trip":
SELECT actor.first_name, actor.last_name FROM actor 
WHERE actor_id IN (
    SELECT actor_id FROM film_actor 
    WHERE film_id = (SELECT film_id FROM film WHERE title = 'Alone Trip')
);

-- 4. All movies categorized as family films
SELECT film.title FROM film 
JOIN film_category ON film.film_id = film_category.film_id 
JOIN category ON film_category.category_id = category.category_id 
WHERE category.name = 'Family';

-- 5. Name and email of customers from Canada using both subqueries and joins:
-- Subquery:
SELECT first_name, last_name, email FROM customer 
WHERE address_id IN (
    SELECT address_id FROM address 
    WHERE city_id IN (
        SELECT city_id FROM city 
        WHERE country_id = (SELECT country_id FROM country WHERE country = 'Canada')
    )
);
-- join:
SELECT customer.first_name, customer.last_name, customer.email 
FROM customer 
JOIN address ON customer.address_id = address.address_id 
JOIN city ON address.city_id = city.city_id 
JOIN country ON city.country_id = country.country_id 
WHERE country.country = 'Canada';

-- 6. Films starred by the most prolific actor:
SELECT film.title FROM film 
JOIN film_actor ON film.film_id = film_actor.film_id 
WHERE film_actor.actor_id = (
    SELECT actor_id FROM film_actor 
    GROUP BY actor_id 
    ORDER BY COUNT(*) DESC 
    LIMIT 1
);

-- 7. Films rented by the most profitable customer:
SELECT film.title FROM film 
JOIN inventory ON film.film_id = inventory.film_id 
JOIN rental ON inventory.inventory_id = rental.inventory_id 
WHERE rental.customer_id = (
    SELECT customer_id FROM payment 
    GROUP BY customer_id 
    ORDER BY SUM(amount) DESC 
    LIMIT 1
);

-- 8. Client_id and total_amount_spent of clients who spent more than the average total_amount spent:
SELECT customer_id, SUM(amount) as total_amount_spent 
FROM payment 
GROUP BY customer_id 
HAVING total_amount_spent > (
    SELECT AVG(total_amount_spent) FROM (
        SELECT SUM(amount) as total_amount_spent 
        FROM payment 
        GROUP BY customer_id
    ) as subquery
);
