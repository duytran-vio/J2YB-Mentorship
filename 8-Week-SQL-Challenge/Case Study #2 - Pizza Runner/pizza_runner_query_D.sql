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


--1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes 
--- how much money has Pizza Runner made so far if there are no delivery fees?

SELECT
	sum(
		CASE
			WHEN co.pizza_id = 1 THEN 12
			ELSE 10
		END
	) AS revenue
FROM customer_orders_clean co
JOIN runner_orders_clean ro ON co.order_id = ro.order_id
WHERE ro.distance IS NOT NULL;

--2. What if there was an additional $1 charge for any pizza extras?
--Add cheese is $1 extra

SELECT
	sum(
		COALESCE(array_length(string_to_array(co.extras,','), 1), 0) +
		CASE
			WHEN co.pizza_id = 1 THEN 12
			ELSE 10
		END
	) AS revenue
FROM customer_orders_clean co
JOIN runner_orders_clean ro ON co.order_id = ro.order_id
WHERE ro.distance IS NOT NULL;

--3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate 
--their runner, how would you design an additional table for this new dataset - generate a 
--schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.

SET search_path = pizza_runner;
DROP TABLE IF EXISTS runner_rate;
CREATE TABLE runner_rate (
	"order_id" INTEGER,
	"customer_id" INTEGER,
	"runner_id" INTEGER,
	"rating" INTEGER
);

INSERT INTO runner_rate ("order_id", "customer_id", "runner_id", "rating")
SELECT
    co.order_id,
    co.customer_id,
    ro.runner_id,
    -- Generate a random rating between 1 and 5
    FLOOR(RANDOM() * 5 + 1) AS rating
FROM
    customer_orders_clean co
JOIN
    runner_orders_clean ro ON co.order_id = ro.order_id
WHERE
    ro.distance IS NOT NULL;
   
SELECT * FROM pizza_runner.runner_rate rr

--4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
--customer_id
--order_id
--runner_id
--rating
--order_time
--pickup_time
--Time between order and pickup
--Delivery duration
--Average speed
--Total number of pizzas

SELECT
	co.customer_id,
	co.order_id,
	ro.runner_id,
	rr.rating,
	co.order_time,
	ro.pickup_time,
	ro.pickup_time - co.order_time AS btw_order_pickup,
	ro.duration,
	(ro.distance / ro.duration::float * 60)::DECIMAL(10,2) AS avg_speed,
	COUNT(co.order_id) AS total_number_of_pizzas 
FROM customer_orders_clean co
JOIN runner_orders_clean ro ON co.order_id = ro.order_id
JOIN pizza_runner.runner_rate rr ON ro.order_id = rr.order_id
GROUP BY co.customer_id, co.order_id, rr.rating, co.order_time, ro.pickup_time, ro.duration, ro.distance, ro.runner_id
ORDER BY co.order_id

--5.If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - 
--how much money does Pizza Runner have left over after these deliveries?

SELECT
	sum(
		CASE
			WHEN co.pizza_id = 1 THEN 12
			ELSE 10
		END
		- ro.distance * 0.3
	) AS revenue
FROM customer_orders_clean co
JOIN runner_orders_clean ro ON co.order_id = ro.order_id
WHERE ro.distance IS NOT NULL;

