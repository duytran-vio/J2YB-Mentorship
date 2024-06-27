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

--1.How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

SELECT 
  date_part('week', registration_date) AS registration_week,
  COUNT(runner_id) AS runner_signup
FROM runners
GROUP BY date_part('week', registration_date);

--2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

WITH time_taken_cte AS
(
  SELECT 
    c.order_id, 
    c.order_time, 
    r.pickup_time, 
    date_part('minute',	r.pickup_time - c.order_time) AS pickup_minutes
  FROM customer_orders_clean AS c
  JOIN runner_orders_clean AS r
    ON c.order_id = r.order_id
  WHERE r.pickup_time IS NOT NULL
  GROUP BY c.order_id, c.order_time, r.pickup_time
)

SELECT
	avg(ttc.pickup_minutes) AS avg_pickup_minutes
FROM time_taken_cte ttc
WHERE ttc.pickup_minutes > 1;

--3.Is there any relationship between the number of pizzas and how long the order takes to prepare?

WITH order_prepare AS (
	SELECT
		c.order_id,
		count(c.pizza_id) AS pizza_num,
		date_part('minute', r.pickup_time - c.order_time) AS prepare_time
	FROM customer_orders_clean AS c
	JOIN runner_orders_clean AS r ON c.order_id = r.order_id
	WHERE r.pickup_time IS NOT NULL 
	GROUP BY c.order_id, r.pickup_time, c.order_time
)

SELECT
	op.pizza_num,
	avg(op.prepare_time) AS avg_prepare_time
FROM order_prepare op
WHERE op.prepare_time > 1
GROUP BY op.pizza_num
ORDER BY op.pizza_num;

--4. What was the average distance travelled for each customer?

SELECT
	c.customer_id,
	avg(r.distance) AS avg_distance
FROM customer_orders_clean AS c
JOIN runner_orders_clean AS r ON c.order_id = r.order_id
WHERE r.pickup_time IS NOT NULL 
GROUP BY c.customer_id
ORDER BY c.customer_id;

--5. What was the difference between the longest and shortest delivery times for all orders?

SELECT max(r.duration) - min(r.duration) AS min_max_diff_duration
FROM runner_orders_clean AS r
WHERE r.distance IS NOT NULL 

--6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

SELECT 
  r.runner_id, 
  c.customer_id, 
  c.order_id, 
  COUNT(c.order_id) AS pizza_count, 
  r.distance, (r.duration / 60) AS duration_hr , 
  round((r.distance/r.duration * 60)::NUMERIC, 2) AS avg_speed
FROM runner_orders_clean AS r
JOIN customer_orders_clean AS c
  ON r.order_id = c.order_id
WHERE distance != 0
GROUP BY r.runner_id, c.customer_id, c.order_id, r.distance, r.duration
ORDER BY c.order_id;

--7. What is the successful delivery percentage for each runner?

SELECT
	r.runner_id,
	sum(CASE 
		WHEN r.distance IS NOT NULL THEN 1
		ELSE 0
	END
	)::NUMERIC / count(r.order_id) * 100  AS succ_perf
FROM runner_orders_clean AS r
GROUP BY r.runner_id
ORDER BY r.runner_id;
