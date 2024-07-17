--Data Cleaning & Transformation
DROP TABLE IF EXISTS customer_orders_clean;
CREATE TEMP TABLE customer_orders_clean AS
(SELECT co.order_id,
	co.customer_id,
	co.pizza_id,
	CASE
		WHEN co.exclusions IS NULL OR co.exclusions LIKE 'null' THEN ''
		ELSE co.exclusions
	END AS exclusions,
	CASE
		WHEN co.extras IS NULL OR co.extras LIKE 'null' THEN ''
		ELSE co.extras
	END AS extras,
	co.order_time
FROM pizza_runner.customer_orders co);

DROP TABLE IF EXISTS runner_orders_clean;
CREATE TEMP TABLE runner_orders_clean AS
(SELECT co.order_id,
	co.runner_id,
	CASE
		WHEN co.pickup_time IS NULL OR co.pickup_time LIKE 'null' THEN NULL
		ELSE co.pickup_time
	END AS pickup_time,
	CASE
		WHEN co.distance IS NULL OR co.distance LIKE 'null' THEN NULL
		WHEN co.distance LIKE '%km' THEN trim('km' FROM co.distance)
		ELSE co.distance
	END AS distance,
	CASE 
		WHEN co.duration IS NULL OR co.duration LIKE 'null' THEN NULL
		WHEN co.duration LIKE '%mins' THEN trim('mins' FROM co.duration)
		WHEN co.duration LIKE '%minute' THEN trim('minute' FROM co.duration)
		WHEN co.duration LIKE '%minutes' THEN trim('minutes' FROM co.duration)
		ELSE co.duration
	END AS duration,
	CASE 
		WHEN co.cancellation IS NULL OR co.cancellation LIKE 'null' OR co.cancellation LIKE '' THEN NULL
		ELSE co.cancellation
	END AS cancellation
FROM pizza_runner.runner_orders co);

ALTER TABLE runner_orders_clean 
ALTER COLUMN pickup_time TYPE timestamp  USING pickup_time::timestamp ,
ALTER COLUMN distance TYPE  FLOAT USING distance::FLOAT,
ALTER COLUMN duration TYPE  INT USING duration::INT;

SELECT *
FROM customer_orders_clean;

SELECT *
FROM runner_orders_clean;

--1.What are the standard ingredients for each pizza?

--DROP TABLE IF EXISTS pizza_recipes_clean;
--CREATE TEMP TABLE pizza_recipes_clean AS
--(SELECT
--	pr.pizza_id,
--	TRIM(STRING_TO_TABLE(pr.toppings,','))::NUMERIC AS topping_id
--FROM pizza_runner.pizza_recipes pr);

--SELECT 
--	pn.pizza_name,
--	pt.topping_name
--FROM pizza_recipes_clean pr
--JOIN pizza_runner.pizza_names pn ON pr.pizza_id = pn.pizza_id
--JOIN pizza_runner.pizza_toppings pt ON pr.topping_id = pt.topping_id

SELECT 
	pr.pizza_id,
	string_agg(pt.topping_name, ',') AS toppings
FROM pizza_runner.pizza_recipes pr
JOIN LATERAL unnest(string_to_array(pr.toppings, ',')) AS topping_list(topping_id) ON TRUE 
JOIN pizza_runner.pizza_toppings pt ON pt.topping_id=topping_list.topping_id::NUMERIC
GROUP BY pr.pizza_id;

-- 2.What was the most commonly added extra?

SELECT 
	el.topping_id::NUMERIC,
	pt.topping_name,
	count(el.topping_id) AS cnt
--		RANK() OVER (ORDER BY count(el.topping_id) DESC) AS cnt_rank
FROM customer_orders_clean co
JOIN LATERAL unnest(string_to_array(co.extras,',')) AS el(topping_id) ON TRUE 
JOIN pizza_runner.pizza_toppings pt ON el.topping_id::NUMERIC = pt.topping_id
GROUP BY el.topping_id, pt.topping_name
ORDER BY count(el.topping_id) DESC;

--3. What was the most common exclusion?

SELECT 
	ex.topping_id::NUMERIC,
	pt.topping_name,
	count(ex.topping_id) AS cnt
--		RANK() OVER (ORDER BY count(el.topping_id) DESC) AS cnt_rank
FROM customer_orders_clean co
JOIN LATERAL unnest(string_to_array(co.exclusions,',')) AS ex(topping_id) ON TRUE 
JOIN pizza_runner.pizza_toppings pt ON ex.topping_id::NUMERIC = pt.topping_id
GROUP BY ex.topping_id, pt.topping_name
ORDER BY count(ex.topping_id) DESC;

--4.Generate an order item for each record in the customers_orders table in the format of one of the following:
--Meat Lovers
--Meat Lovers - Exclude Beef
--Meat Lovers - Extra Bacon
--Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

--SELECT 
--	co.order_id,
--	pn.pizza_name
--	|| 
--		CASE
--			WHEN co.exclusions = '' THEN ''
--			ELSE ' - Exclude ' || string_agg(pt.topping_name,', ')
--		END 
--	||
--		CASE
--			WHEN co.extras = '' THEN ''
--			ELSE ' - Extra ' || string_agg(pt2.topping_name,', ')
--		END
--	AS order_item
--FROM customer_orders_clean co
--LEFT JOIN LATERAL unnest(string_to_array(co.exclusions,',')) AS ex(topping_id) ON TRUE 
--LEFT JOIN pizza_runner.pizza_toppings pt ON ex.topping_id::NUMERIC = pt.topping_id
--LEFT JOIN LATERAL unnest(string_to_array(co.extras,',')) AS el(topping_id) ON TRUE 
--LEFT JOIN pizza_runner.pizza_toppings pt2 ON el.topping_id::NUMERIC = pt2.topping_id
--JOIN pizza_runner.pizza_names pn ON co.pizza_id = pn.pizza_id
--GROUP BY co.order_id, pn.pizza_name, co.exclusions, co.extras
--ORDER BY order_id;

SELECT 
    co.order_id,
    pn.pizza_name
    ||
    COALESCE(' - Exclude ' || ex.exclusions, '')
    ||
    COALESCE(' - Extra ' || ex2.extras, '') AS order_item
FROM customer_orders_clean co
JOIN pizza_runner.pizza_names pn ON co.pizza_id = pn.pizza_id
LEFT JOIN LATERAL (
    SELECT 
        STRING_AGG(pt.topping_name, ', ') AS exclusions
    FROM unnest(string_to_array(co.exclusions, ',')) AS ex(topping_id)
    LEFT JOIN pizza_runner.pizza_toppings pt ON ex.topping_id::NUMERIC = pt.topping_id
) ex ON true
LEFT JOIN LATERAL (
    SELECT 
        STRING_AGG(pt2.topping_name, ', ') AS extras
    FROM unnest(string_to_array(co.extras, ',')) AS el(topping_id)
    LEFT JOIN pizza_runner.pizza_toppings pt2 ON el.topping_id::NUMERIC = pt2.topping_id
) ex2 ON true
GROUP BY co.order_id, pn.pizza_name, ex.exclusions, ex2.extras
ORDER BY co.order_id;

--5.Generate an alphabetically ordered comma separated ingredient list for each
-- pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
--For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

SELECT 
	co.order_id,
	co.customer_id,
	pn.pizza_name || ': ' || recipe.topping_str AS pizza_str
FROM customer_orders_clean co
LEFT JOIN pizza_runner.pizza_recipes pr ON co.pizza_id=pr.pizza_id
LEFT JOIN LATERAL(
	SELECT 
		string_agg(
			CASE 
				WHEN cnt_topping > 1 THEN recipe.cnt_topping || 'x' 
				ELSE ''
			END
			|| recipe.topping_name, ', '
			) AS topping_str
	FROM (
		SELECT pt.topping_name,
				count(trim(toppings.topping_id)) AS cnt_topping
		FROM unnest(string_to_array(pr.toppings, ',') 
					|| 
					string_to_array(co.extras, ',')
					) AS toppings(topping_id)
		JOIN pizza_toppings pt ON pt.topping_id=toppings.topping_id::NUMERIC
		WHERE trim(toppings.topping_id) NOT IN (SELECT trim(ex.topping_id)
												FROM UNNEST(string_to_array(co.exclusions,',')) AS ex(topping_id)
												WHERE ex.topping_id IS NOT NULL)
		GROUP BY pt.topping_name
		ORDER BY pt.topping_name
	) AS recipe
) recipe ON TRUE 
JOIN pizza_runner.pizza_names pn ON pn.pizza_id = co.pizza_id
ORDER BY co.order_id;

--6.What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

SELECT 
	pt.topping_name,
	sum(recipe.cnt_topping) AS quantity
FROM customer_orders_clean co
LEFT JOIN pizza_runner.pizza_recipes pr ON co.pizza_id=pr.pizza_id
LEFT JOIN LATERAL(
	SELECT toppings.topping_id::NUMERIC,
			count(trim(toppings.topping_id)) AS cnt_topping
	FROM unnest(string_to_array(pr.toppings, ',') 
				|| 
				string_to_array(co.extras, ',')
				) AS toppings(topping_id)
	WHERE toppings.topping_id::NUMERIC NOT IN (SELECT ex.topping_id::NUMERIC
											FROM UNNEST(string_to_array(co.exclusions,',')) AS ex(topping_id)
											WHERE ex.topping_id IS NOT NULL)
	GROUP BY toppings.topping_id::NUMERIC
	ORDER BY toppings.topping_id::NUMERIC
) recipe ON TRUE 
JOIN pizza_runner.pizza_toppings pt ON recipe.topping_id=pt.topping_id
GROUP BY pt.topping_name
ORDER BY quantity DESC;










