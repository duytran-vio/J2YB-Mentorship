**Schema (PostgreSQL v13)**

    CREATE SCHEMA dannys_diner;
    SET search_path = dannys_diner;
    
    CREATE TABLE sales (
      "customer_id" VARCHAR(1),
      "order_date" DATE,
      "product_id" INTEGER
    );
    
    INSERT INTO sales
      ("customer_id", "order_date", "product_id")
    VALUES
      ('A', '2021-01-01', '1'),
      ('A', '2021-01-01', '2'),
      ('A', '2021-01-07', '2'),
      ('A', '2021-01-10', '3'),
      ('A', '2021-01-11', '3'),
      ('A', '2021-01-11', '3'),
      ('B', '2021-01-01', '2'),
      ('B', '2021-01-02', '2'),
      ('B', '2021-01-04', '1'),
      ('B', '2021-01-11', '1'),
      ('B', '2021-01-16', '3'),
      ('B', '2021-02-01', '3'),
      ('C', '2021-01-01', '3'),
      ('C', '2021-01-01', '3'),
      ('C', '2021-01-07', '3');
     
    
    CREATE TABLE menu (
      "product_id" INTEGER,
      "product_name" VARCHAR(5),
      "price" INTEGER
    );
    
    INSERT INTO menu
      ("product_id", "product_name", "price")
    VALUES
      ('1', 'sushi', '10'),
      ('2', 'curry', '15'),
      ('3', 'ramen', '12');
      
    
    CREATE TABLE members (
      "customer_id" VARCHAR(1),
      "join_date" DATE
    );
    
    INSERT INTO members
      ("customer_id", "join_date")
    VALUES
      ('A', '2021-01-07'),
      ('B', '2021-01-09');

---

**Query #1:  What is the total amount each customer spent at the restaurant?**

    SELECT l.customer_id,
           sum(me.price) AS total_sales
    FROM dannys_diner.sales l
    JOIN dannys_diner.menu me ON me.product_id = l.product_id
    GROUP BY l.customer_id
    ORDER BY l.customer_id ASC;

| customer_id | total_sales |
| ----------- | ----------- |
| A           | 76          |
| B           | 74          |
| C           | 36          |

---
**Query #2:  How many days has each customer visited the restaurant?**

    SELECT sales.customer_id,
    		COUNT(DISTINCT sales.order_date) as visited_count
    FROM dannys_diner.sales sales
    GROUP BY sales.customer_id;

| customer_id | visited_count |
| ----------- | ------------- |
| A           | 4             |
| B           | 6             |
| C           | 2             |

---
**Query #3:  What was the first item from the menu purchased by each customer?**

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

| customer_id | product_name |
| ----------- | ------------ |
| A           | curry        |
| A           | sushi        |
| B           | curry        |
| C           | ramen        |

---
**Query #4: What is the most purchased item on the menu and how many times was it purchased by all customers?**

    SELECT menu.product_name,
           COUNT(menu.product_name) as buy_times
    FROM dannys_diner.sales sales
    JOIN dannys_diner.menu menu ON sales.product_id = menu.product_id
    GROUP BY menu.product_name
    ORDER BY buy_times DESC
    LIMIT 1;

| product_name | buy_times |
| ------------ | --------- |
| ramen        | 8         |

---
**Query #5: Which item was the most popular for each customer?**

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

| customer_id | product_name | buy_times |
| ----------- | ------------ | --------- |
| A           | ramen        | 3         |
| B           | ramen        | 2         |
| B           | curry        | 2         |
| B           | sushi        | 2         |
| C           | ramen        | 3         |

---
**Query #6: Which item was purchased first by the customer after they became a member?**

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

| customer_id | product_name |
| ----------- | ------------ |
| A           | ramen        |
| B           | sushi        |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/2rM8RAnq7h5LLDTzZiRWcd/7286)