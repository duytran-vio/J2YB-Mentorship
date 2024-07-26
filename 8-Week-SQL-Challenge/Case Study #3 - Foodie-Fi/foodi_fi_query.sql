SET search_path = foodie_fi;

--B. Data Analysis Questions
--1.How many customers has Foodie-Fi ever had?

SELECT 
	count(DISTINCT s.customer_id) AS customers_num
FROM foodie_fi.subscriptions s;

--2.What is the monthly distribution of trial plan start_date values 
--for our dataset - use the start of the month as the group by value

SELECT
	date_part('month', s.start_date) AS month_date,
	count(s.plan_id) AS trial_count
FROM foodie_fi.subscriptions s
WHERE s.plan_id = 0
GROUP BY date_part('month', s.start_date)
ORDER BY month_date;

--3.What plan start_date values occur after the year 2020 for our dataset?
--Show the breakdown by count of events for each plan_name

SELECT
	p.plan_id,
	p.plan_name,
	count(sub.customer_id) AS plan_count
FROM foodie_fi.subscriptions sub
JOIN foodie_fi."plans" p ON sub.plan_id=p.plan_id
WHERE sub.start_date > '2020-12-31'
GROUP BY p.plan_id, p.plan_name
ORDER BY p.plan_id;

--4. What is the customer count and percentage of customers 
--who have churned rounded to 1 decimal place?

SELECT
	count(DISTINCT sub.customer_id) AS churn_cnt,
	round(100.0 * count(DISTINCT sub.customer_id)
		/ (SELECT count(DISTINCT customer_id)
			FROM foodie_fi.subscriptions s)
	, 1) AS churn_per
FROM foodie_fi.subscriptions sub
WHERE sub.plan_id=4;

--5.How many customers have churned straight after their initial free trial 
--- what percentage is this rounded to the nearest whole number?

WITH previous_plan_cte AS (
	SELECT
		sub.*,
		LAG(plan_id, 1) OVER (PARTITION BY sub.customer_id ORDER BY sub.start_date) AS previous_plan
	FROM foodie_fi.subscriptions sub
)

SELECT
	count(DISTINCT sub.customer_id) AS churn_cnt,
	round(100.0 * count(DISTINCT sub.customer_id)
		/ (SELECT count(DISTINCT customer_id)
			FROM foodie_fi.subscriptions s)
	, 0) AS churn_per
FROM previous_plan_cte sub
WHERE sub.plan_id=4 AND sub.previous_plan=0;

--6.What is the number and percentage of customer plans after their initial free trial?

WITH previous_plan_cte AS (
	SELECT
		sub.*,
		LAG(plan_id, 1) OVER (PARTITION BY sub.customer_id ORDER BY sub.start_date) AS previous_plan
	FROM foodie_fi.subscriptions sub
)

SELECT
	sub.plan_id,
	count(DISTINCT sub.customer_id) AS converted_customers,
	round(100.0 * count(DISTINCT sub.customer_id)
		/ (SELECT count(DISTINCT customer_id)
			FROM foodie_fi.subscriptions s)
	, 1) AS conversion_percentage
FROM previous_plan_cte sub
WHERE sub.previous_plan=0
GROUP BY sub.plan_id
ORDER BY sub.plan_id;

--7.What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
WITH next_plan_cte AS (
	SELECT
		sub.*,
		LEAD(sub.start_date) OVER (PARTITION BY sub.customer_id
									ORDER BY sub.start_date) AS next_plan_date
	FROM foodie_fi.subscriptions sub
	WHERE sub.start_date <= '2020-12-31'
	ORDER BY sub.customer_id, sub.start_date
)

SELECT
	p.plan_id,
	p.plan_name,
	count(npc.customer_id) AS customer_cnt,
	round(100.0 * count(DISTINCT npc.customer_id)
		/ (SELECT count(DISTINCT customer_id)
			FROM foodie_fi.subscriptions s)
	, 1) AS plan_per
FROM next_plan_cte npc
JOIN foodie_fi."plans" p ON npc.plan_id=p.plan_id
WHERE npc.next_plan_date IS NULL
GROUP BY p.plan_id, p.plan_name
ORDER BY p.plan_id;

--8. How many customers have upgraded to an annual plan in 2020?
SELECT
	count(DISTINCT s.customer_id) AS annual_plan_cus
FROM foodie_fi.subscriptions s
WHERE s.plan_id = 3 AND s.start_date <= '2020-12-31';

--9.How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

WITH annual_plan_cte AS (
	SELECT
		s.*,
		s.start_date - FIRST_VALUE(s.start_date) OVER (
			PARTITION BY s.customer_id
			ORDER BY s.start_date
		) AS day_to_annual_plan
	FROM foodie_fi.subscriptions s
	WHERE s.plan_id IN (0, 3)
	ORDER BY s.customer_id, s.start_date
)

SELECT
	round(avg(apc.day_to_annual_plan), 0) AS avg_days_annual_plan
FROM annual_plan_cte apc
WHERE apc.plan_id = 3;

--10.Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)


--11.How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

WITH next_plan_cte AS (
	SELECT
		s.*,
		LEAD(s.plan_id) OVER (
			PARTITION BY s.customer_id
			ORDER BY s.start_date
		) AS next_plan
	FROM foodie_fi.subscriptions s
	WHERE DATE_PART('year', start_date) = 2020
	ORDER BY s.customer_id, s.start_date
)

SELECT
	count(npc.customer_id)
FROM next_plan_cte npc
WHERE npc.plan_id=2 AND npc.next_plan=1;