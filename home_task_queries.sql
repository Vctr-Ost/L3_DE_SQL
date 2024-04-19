/*
 Завдання на SQL до лекції 03.
 */


/*
1.
Вивести кількість фільмів в кожній категорії.
Результат відсортувати за спаданням.
*/
-- SQL code goes here...

SELECT cat.name, count(*) as cnt
FROM film_category fc
LEFT JOIN category cat ON fc.category_id = cat.category_id
GROUP BY cat.name
ORDER BY cnt DESC
;



/*
2.
Вивести 10 акторів, чиї фільми брали на прокат найбільше.
Результат відсортувати за спаданням.
*/
-- SQL code goes here...

SELECT a.first_name, a.last_name, count(*) as cnt
FROM rental r
LEFT JOIN inventory i ON r.inventory_id = i.inventory_id
LEFT JOIN film_actor fa ON i.film_id = fa.film_id
LEFT JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY cnt DESC
LIMIT 10
;


/*
3.
Вивести категорія фільмів, на яку було витрачено найбільше грошей
в прокаті
*/
-- SQL code goes here...

SELECT cat.name, SUM(pm.amount) AS sum_amount
FROM public.payment pm
LEFT JOIN public.rental rn ON pm.rental_id = rn.rental_id
LEFT JOIN public.inventory inv ON rn.inventory_id = inv.inventory_id
LEFT JOIN public.film_category fc ON inv.film_id = fc.film_id
LEFT JOIN public.category cat ON fc.category_id = cat.category_id
GROUP BY cat.name
ORDER BY sum_amount DESC
LIMIT 1
;


/*
4.
Вивести назви фільмів, яких не має в inventory.
Запит має бути без оператора IN
*/
-- SQL code goes here...

WITH inventory_films_id AS ( SELECT DISTINCT film_id FROM public.inventory )

SELECT f.film_id, f.title
FROM public.film f
LEFT JOIN inventory_films_id inv ON f.film_id = inv.film_id
WHERE inv.film_id IS NULL
;


/*
5.
Вивести топ 3 актори, які найбільше зʼявлялись в категорії фільмів “Children”.
*/
-- SQL code goes here...

WITH children_cat_films AS (
	SELECT fa.actor_id, count(*) as cnt
	FROM public.category c
	LEFT JOIN public.film_category fc ON c.category_id = fc.category_id
	LEFT JOIN public.film_actor fa ON fc.film_id = fa.film_id
	WHERE c.name = 'Children'
	GROUP BY fa.actor_id
	ORDER BY cnt DESC
	LIMIT 3
)

SELECT a.first_name || ' ' || a.last_name AS name
FROM children_cat_films flms
LEFT JOIN public.actor a ON flms.actor_id = a.actor_id
;
