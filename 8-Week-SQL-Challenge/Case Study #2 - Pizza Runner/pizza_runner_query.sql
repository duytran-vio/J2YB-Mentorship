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
ALTER COLUMN pickup_time TYPE DATE USING pickup_time::date,
ALTER COLUMN distance TYPE  FLOAT USING distance::FLOAT,
ALTER COLUMN duration TYPE  INT USING duration::INT;

SELECT *
FROM runner_orders_clean;

--1. How many pizzas were ordered?

SELECT count(co.pizza_id)
FROM customer_orders_clean co

--2. How many unique customer orders were made?

SELECT count(DISTINCT co.order_id)
FROM customer_orders_clean co;

--3. How many successful orders were delivered by each runner?

SELECT ru.runner_id,
	count(DISTINCT ru.order_id) AS sucess_order_num
FROM runner_orders_clean ru
WHERE ru.cancellation IS NULL
GROUP BY ru.runner_id;

--4. How many of each type of pizza was delivered?

SELECT pn.pizza_name,
		count(co.pizza_id) AS delivered_num
FROM customer_orders_clean co
JOIN pizza_runner.pizza_names pn ON co.pizza_id = pn.pizza_id
JOIN runner_orders_clean ru ON co.order_id = ru.order_id
WHERE ru.cancellation IS NULL
GROUP BY pn.pizza_name;

