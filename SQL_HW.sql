Use sakila;

#1a. You need a list of all the actors who have Display the first and last names of all actors from the table actor.
#select first_name + " " + last_name as both_name from actor;
SELECT * FROM actor;

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT CONCAT_WS(" ", `first_name`, `last_name`) AS `whole_name` FROM `actor`;

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
#What is one query would you use to obtain this information?
SELECT * FROM actor where first_name = "Joe";

#2b. Find all actors whose last name contain the letters GEN:
SELECT * FROM actor WHERE last_name LIKE '%GEN%';

#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT * FROM actor WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name ASC;

#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country
WHERE country_id IN (
	SELECT country_id
	FROM country 
    WHERE country = 'Afghanishtan');

SELECT country_id, country
FROM country
WHERE country_id IN (
	SELECT country_id
	FROM country 
    WHERE country = 'Bangladesh');
    
SELECT country_id, country
FROM country
WHERE country_id IN (
	SELECT country_id
	FROM country 
    WHERE country = 'China');

#3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
ALTER TABLE actor
ADD middle_name VARCHAR(30) AFTER first_name;
SELECT * FROM actor;

#3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
ALTER TABLE actor MODIFY middle_name BLOB;

#3c. Now delete the middle_name column.
ALTER TABLE actor DROP middle_name;

#4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) <=2;

#4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. 
#Write a query to fix the record.
UPDATE actor SET first_name = 'HARPO' WHERE first_name = 'GROUCHO';

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, 
#if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, 
#as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! 
#(Hint: update the record using a unique identifier.)
UPDATE actor
SET first_name = 'MUCHO GROUCHO'
WHERE first_name = 'HARPO';

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
DROP TABLE if exists address;
CREATE TABLE address (
	address_id integer(10),
    address VARCHAR(25),
    address2 VARCHAR(25),
    district VARCHAR(25),
    city_id INTEGER(10),
    postal_code INTEGER(10),
    phone INTEGER(10),
    location VARCHAR(25),
    last_update NOW(),
    primary_key(fk_address_city)
    );

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT * FROM staff;
SELECT * FROM address;

SELECT staff.first_name, staff.last_name, address.address
FROM staff
JOIN address
ON staff.address_id = address.address_id;

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT * FROM staff;
SELECT * FROM payment;

SELECT first_name, last_name, sum(amount) Total
FROM staff s
JOIN payment p
ON (s.staff_id = p.staff_id)
WHERE payment_date >='2005-08-01 00:00:00'
AND payment_date <'2005-09-01 00:00:00'
GROUP BY first_name, last_name;

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT * FROM film_actor;
SELECT * FROM film;

SELECT COUNT(fa.actor_id), title
FROM film_actor fa
JOIN film f 
ON (fa.film_id = f.film_id)
GROUP BY title;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT * FROM inventory;
SELECT * FROM film;

SELECT title , COUNT(i.film_id)
FROM film f
JOIN inventory i
ON (f.film_id = i.film_id)
GROUP BY title;

#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
# ![Total amount paid](Images/total_payment.png)
SELECT * FROM payment;
SELECT * FROM customer;

SELECT p.customer_id, SUM(p.amount), c.last_name
FROM payment p
JOIN customer c
ON (p.customer_id = c.customer_id)
GROUP BY p.customer_id
ORDER BY last_name;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
#films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT * from film;
SELECT * from language;

SELECT title
FROM film
WHERE title like 'K%' or 'Q%' -- STILL NEED TO FIGURE THIS OUT :(
AND language_id in
(
 SELECT language_id
 FROM language
 WHERE name = 'English'
 );
 
#7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT * FROM actor;
SELECT * FROM film_actor;
SELECT * FROM film;

SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
 SELECT actor_id
 FROM film_actor
 WHERE film_id IN
  (
   SELECT film_id
   FROM film
   WHERE title = 'Alone Trip'
   )
);

#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
#Use joins to retrieve this information.
SELECT * FROM customer;
SELECT * FROM address;
SELECT * FROM city;
SELECT * FROM country;

SELECT first_name, last_name, email
FROM customer
WHERE address_id IN
(
 SELECT address_id
 FROM address
 WHERE city_id IN
 (
  SELECT city_id
  FROM city
  WHERE country_id IN
  (
   SELECT country_id
   FROM country
   WHERE country = 'Canada'
  )
 )
);

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
SELECT * FROM film;
SELECT * FROM film_category;
SELECT * FROM category;

SELECT title
FROM film
WHERE film_id IN
(
 SELECT film_id 
 FROM film_category
 WHERE category_id IN
 (
  SELECT category_id
  FROM category
  WHERE name = 'Family'
 )
);

#7e. Display the most frequently rented movies in descending order.
SELECT * FROM rental;
SELECT * FROM inventory;
SELECT * FROM film;

SELECT title, 
FROM film
WHERE film_id IN
(
 SELECT film_id
 FROM inventory
 WHERE inventory_id IN
);

#7f. Write a query to display how much business, in dollars, each store brought in.
SELECT * FROM store;
SELECT * FROM staff;
SELECT * FROM payment;

SELECT count(amount)
FROM payment
WHERE staff_id IN
(
 SELECT staff_id
 FROM staff
 WHERE store_id IN
 (
  SELECT store_id
  FROM store
 ) 
);

#7g. Write a query to display for each store its store ID, city, and country.
SELECT * FROM store;

#7h. List the top five genres in gross revenue in descending order. 
#(Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
#Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

#8b. How would you display the view that you created in 8a?

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.