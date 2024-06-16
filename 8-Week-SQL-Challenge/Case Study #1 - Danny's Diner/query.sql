/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
-- 2. How many days has each customer visited the restaurant?
-- 3. What was the first item from the menu purchased by each customer?
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- 5. Which item was the most popular for each customer?
-- 6. Which item was purchased first by the customer after they became a member?
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

SELECT l.customer_id,
       sum(me.price) AS total_sales
FROM dannys_diner.sales l
JOIN dannys_diner.menu me ON me.product_id = l.product_id
GROUP BY l.customer_id
ORDER BY l.customer_id ASC;

SELECT sales.customer_id,
		COUNT(DISTINCT sales.order_date) as visited_count
FROM dannys_diner.sales sales
GROUP BY sales.customer_id;

WITH sales_ordered AS (
	SELECT sales.customer_id, 
          menu.product_name,
  			DENSE_RANK() OVER (
              PARTITION BY sales.customer_id
              ORDER BY sales.order_date
            ) as rank
  FROM dannys_diner.sales sales
  JOIN dannys_diner.menu menu ON sales.product_id = menu.product_id
)


SELECT customer_id, product_name
FROM sales_ordered
WHERE rank = 1
GROUP BY customer_id, product_name;

SELECT menu.product_name,
       COUNT(menu.product_name) as buy_times
FROM dannys_diner.sales sales
JOIN dannys_diner.menu menu ON sales.product_id = menu.product_id
GROUP BY menu.product_name
ORDER BY buy_times DESC
LIMIT 1;
  
WITH most_buy AS (
	SELECT sales.customer_id, 
          menu.product_name,
  			COUNT (menu.product_name) as buy_times,
  			DENSE_RANK() OVER (
  			PARTITION BY sales.customer_id
              ORDER BY COUNT(menu.product_name) DESC
  			) as rank
  FROM dannys_diner.sales sales
  JOIN dannys_diner.menu menu ON sales.product_id = menu.product_id
  GROUP BY sales.customer_id, menu.product_name
)

SELECT customer_id, 
      product_name, 
      buy_times
FROM most_buy
WHERE rank = 1;

WITH sales_after_join AS (
  SELECT sales.customer_id,
          menu.product_name,
          sales.order_date,
          ROW_NUMBER() OVER (
            PARTITION BY sales.customer_id
            ORDER BY sales.order_date ASC
          ) as rank
  FROM dannys_diner.sales sales
  JOIN dannys_diner.members members on sales.customer_id = members.customer_id
  JOIN dannys_diner.menu menu ON sales.product_id = menu.product_id
  								AND sales.order_date > members.join_date
)

SELECT sales.customer_id,
		sales.product_name
FROM sales_after_join sales
WHERE rank = 1;



