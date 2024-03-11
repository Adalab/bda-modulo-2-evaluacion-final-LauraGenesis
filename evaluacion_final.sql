/*Para este ejercicio utilizaremos la BBDD Sakila que hemos estado utilizando durante el repaso de SQL. 
Es una base de datos de ejemplo que simula una tienda de alquiler de películas. 
Contiene tablas como `film` (películas), `actor` (actores), `customer` (clientes), `rental` (alquileres), `category` (categorías), entre otras.
Estas tablas contienen información sobre películas, actores, clientes, alquileres y más, y se utilizan para realizar consultas y análisis de 
datos en el contexto de una tienda de alquiler de películas.*/

/*1. Selecciona todos los nombres de las películas sin que aparezcan duplicados. */
-- Distinct elimina los duplicados, es como el UNIQUE de python 
SELECT *
	FROM film;

SELECT DISTINCT title
	FROM film;
    
/*2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".*/

SELECT *
	FROM film;
    
-- Nos piden especificar la columna de clasificacion, para ello usamo la cláusula de condición WHERE

SELECT DISTINCT title, rating AS clasificacion
	FROM film
    WHERE rating= 'PG-13';

/*3. Encuentra el título y la descripción de todas las películas que contengan 
la palabra "amazing" en su descripción. */

SELECT *
	FROM film;
    
-- Usamos la cláusula LIKE con el caracter especial % para filtrar por el valor
SELECT title, `description` 
	FROM film
    WHERE `description` LIKE '%amazing%';

/*4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.*/

SELECT *
	FROM film;
    
SELECT DISTINCT title , length
	FROM film
    WHERE length > 120;
    
/* 5. Recupera los nombres de todos los actores.*/

SELECT *
	FROM actor;
    
SELECT CONCAT(first_name, ' ', last_name) AS nombre_completo
	FROM actor;

/*6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.*/

SELECT *
	FROM actor;

SELECT CONCAT(first_name, ' ', last_name) AS nombre_completo
	FROM actor
    WHERE last_name = 'Gibson';

/* 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.*/

SELECT *
	FROM actor;

--  Permitirá seleccionar registros dentro de un rango específico de valores 
SELECT actor_id, CONCAT(first_name, ' ', last_name) AS nombre_completo
	FROM actor
    WHERE actor_id BETWEEN 10 AND 20;
    
/* 8. Encuentra el título de las películas en la tabla `film` 
que no sean ni "R" ni "PG-13" en cuanto a su clasificación.*/

SELECT *
	FROM film;
    
-- IN/NOT IN compara un valor con una lista de posibles valores
SELECT title, rating AS clasificacion
	FROM film
    WHERE rating NOT IN ('R', 'PG-13');
    
/* 9. Encuentra la cantidad total de películas en cada clasificación de la tabla `film` y 
muestra la clasificación junto con el recuento.*/ 

SELECT *
	FROM film;
    
-- COUNT cuenta cuántas películas tienen una clasificación en cada categoría  
-- Group by agrupa filas en función de valores comunes (5 categorias)  
SELECT rating AS clasificacion,  COUNT(rating) AS recuento_clasificacion
	FROM film
    GROUP BY clasificacion;
    
/* 10. Encuentra la cantidad total de películas alquiladas por cada cliente y 
muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.*/

SELECT *
	FROM customer; -- necesitamos el customer_id 
   
SELECT * 
	FROM rental;-- vincula el customer_id, información sobre las películas alquiladas

SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS nombre_cliente, COUNT(r.rental_id) AS cantidad_alquiladas
FROM customer AS c
INNER JOIN rental AS r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, nombre_cliente;


/*11. Encuentra la cantidad total de películas alquiladas por categoría y muestra
	  el nombre de la categoría junto con el recuento de alquileres.*/

SELECT *
	FROM category; -- Se encuentran todas las categorias 
SELECT *
	FROM film; 
SELECT *
	FROM film_category; -- Se encuentra la categoria con el film _id
SELECT *
	FROM rental; -- Escogemos rental Id porque una persona puede alquilar una peli varias veces  
SELECT *
	FROM inventory;-- Para unir las pelis alquiladas 
    
SELECT c.name AS nombre_categoria, COUNT(r.rental_id) AS cantidad_alquileres
	FROM category AS c
	INNER JOIN film_category AS fc ON c.category_id = fc.category_id -- utiliza la columna category_id como clave de unión.
	INNER JOIN film AS f ON fc.film_id = f.film_id
	INNER JOIN inventory AS i ON f.film_id = i.film_id
	INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
	GROUP BY nombre_categoria;
    
/*12.Encuentra el promedio de duración de las películas para cada 
	 clasificación de la tabla `film` y muestra la clasificación junto 
	 con el promedio de duración.*/

SELECT *
	FROM film;
    
-- AVG clausula para calcular la media    
SELECT f.rating AS clasificacion, AVG(f.length) AS promedio_duracion
	FROM film AS f
	GROUP BY clasificacion;

/*13. Encuentra el nombre y apellido de los
	  actores que aparecen en la película con title "Indian Love". */
SELECT *
	FROM actor;
SELECT *
	FROM film;
SELECT *
	FROM film_actor; -- Se encuentran ambas claves actor_id y film_id

SELECT CONCAT(a.first_name, ' ', a.last_name) AS nombre_actor, f.title AS Titulo
	FROM actor AS a
    INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
	INNER JOIN film AS f ON fa.film_id = f.film_id
		WHERE f.title = 'Indian Love';

/*14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" 
	  en su descripción.*/

SELECT *
	FROM film;
-- Se usa el operador LIKE con los comodines % para buscar patrones que contengan las palabras dog o cat
SELECT title AS titulo, `description` AS descripción 
	FROM film
    WHERE `description` LIKE "%dog%" OR "%cat%";
    
/*15. Hay algún actor o actriz que no apareca en ninguna película en la tabla `film_actor`.*/

SELECT *
	FROM actor;
    
SELECT *
	FROM film_actor;   

SELECT a.actor_id, a.first_name, a.last_name
	FROM actor AS a
	LEFT JOIN film_actor AS fa ON a.actor_id = fa.actor_id
	WHERE fa.actor_id IS NULL; -- filtra los resultados para que solo se incluyan aquellos actores que no aparecen en film actor 

-- Todos los actores y actrices han participado en al menos una película.

/*16.Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.*/

SELECT *
	FROM film;
    
SELECT title AS Título, release_year AS año_lanzamiento
	FROM film
	WHERE release_year BETWEEN 2005 AND 2010;

/*17.Encuentra el título de todas las películas que son de la misma categoría que "Family".*/

SELECT * 
	FROM category; -- Se encuentran las categorias
SELECT * 
	FROM film;    -- para el titulo 
SELECT * 
	FROM film_category; -- La union entre ambas tablas 
    
SELECT f.title AS Título, c.name AS categoría
	FROM film AS f
	INNER JOIN film_category AS fc ON f.film_id = fc.film_id
	INNER JOIN category AS c ON fc.category_id = c.category_id
	WHERE c.name = 'Family';


/*18.Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.*/

SELECT CONTAT (a.first_name,' ', a.last_name)
	FROM actor AS a
	INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
	GROUP BY a.actor_id
	HAVING COUNT(fa.film_id) > 10;

/*19. Encuentra el título de todas las películas que son "R" y tienen una duración 	
	  mayor a 2 horas en la tabla `film`.*/
SELECT *
	FROM film;
    
SELECT title AS Título, rating AS clasificacion, length AS duración 
	FROM film
	WHERE rating = 'R' AND length > 120;

/*20. Encuentra las categorías de películas que tienen un promedio de duración 
	  superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.*/
SELECT *
	FROM film;
    
SELECT *
	FROM category;
    
SELECT *
	FROM film_category;

SELECT a.actor_id,CONCAT( a.first_name,' ', a.last_name) AS nombre_completo , COUNT(fa.actor_id) AS peliculas_actuadas
	FROM actor AS a
	INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
	GROUP BY a.actor_id, a.first_name, a.last_name
	HAVING COUNT(fa.actor_id) >= 5;
    
/*21. Encuentra los actores que han actuado en al menos 5 películas y muestra el 
	  nombre del actor junto con la cantidad de películas en las que han actuado.*/

-- Se puede hacer una subconsulta 
SELECT *
	FROM actor;
    
SELECT *
	FROM film_actor;

SELECT actor_id, CONCAT(first_name,' ',last_name) AS nombre_actor,
    (SELECT COUNT(actor_id)
        FROM film_actor
        WHERE actor_id = actor.actor_id) AS peliculas_actuadas
	FROM actor
	HAVING peliculas_actuadas >= 5;

/*22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días.
	  Utiliza una subconsulta para encontrar los rental_ids con una duración 
      superior a 5 días y luego selecciona las películas correspondientes.*/
      
 SELECT *
	FROM actor; 
    
SELECT *
	FROM film;
    
SELECT *
	FROM inventory;

SELECT f.title
	FROM film AS f
	WHERE f.film_id IN (SELECT rental.inventory_id
						FROM rental
						WHERE rental.return_date - rental.rental_date > 5);

/*23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película 
	  de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que 
	   han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de 
       actores.*/

 SELECT *
	FROM actor; 
SELECT *
	FROM film_actor;
SELECT *
	FROM film_category; 
SELECT *
	FROM category;
    
SELECT CONCAT (a.first_name,' ', a.last_name) AS Actores_NO_Horror
	FROM actor AS a
	WHERE a.actor_id NOT IN (SELECT fa.actor_id
								FROM film_actor AS fa
								INNER JOIN film_category AS fc ON fa.film_id = fc.film_id
								INNER JOIN category AS c ON fc.category_id = c.category_id
								WHERE c.name = 'Horror'); -- Actores que han actuado en películas de la categoría "Horror"
 ## BONUS
/* 24. BONUS: Encuentra el título de las películas que son comedias 
		y tienen una duración mayor a 180 minutos en la tabla `film`.*/

SELECT *
	FROM film;
SELECT *
	FROM category;

SELECT title, length
	FROM film;

-- Primero mostramos todas las peliculas en la categoria Comedia
WITH Comedias AS (
    SELECT film_id
    FROM film_category
    WHERE category_id = (
        SELECT category_id
        FROM category
        WHERE name = 'Comedy'
    )
-- Aquí la duracion 
),
Duracion AS (
    SELECT film_id
    FROM film
    WHERE length > 180
)
-- Una vez obtenida ambas las unimos en una consulta principal 
SELECT f.title AS titulo, f.length AS duracion
FROM film f
INNER JOIN Comedias c ON f.film_id = c.film_id
INNER JOIN Duracion d ON f.film_id = d.film_id;

/*25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. 
	  La consulta debe mostrar el nombre y apellido de los actores 
      y el número de películas en las que han actuado juntos.*/

SELECT *
	FROM actor;
SELECT *
	FROM film;
SELECT *
	FROM film_actor;

-- 
SELECT CONCAT(a1.first_name, ' ', a1.last_name) AS actor1,
       CONCAT(a2.first_name, ' ', a2.last_name) AS actor2,
       COUNT(DISTINCT fa1.film_id) AS peliculas_juntos -- Contar el numero de peliculas distintas de la tabla film_actor
FROM film_actor fa1
JOIN film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id -- SELFJOIN juntanto el id de peliculas y que el actor 1 tenga menor id que el actor para que solo aparezca una vez 
JOIN actor a1 ON fa1.actor_id = a1.actor_id
JOIN actor a2 ON fa2.actor_id = a2.actor_id
GROUP BY actor1, actor2 
HAVING peliculas_juntos > 0;

