--The customers table has 15 columns:
--	customer_id stores the ID of the customer.
--	email stores the customer’s email address.
--	full_name stores the customer’s full name.
--	address stores the customer’s street and house number.
--	city stores the city where the customer lives.
--	region stores the customer’s region (not always applicable).
--	postal_code stores the customer’s ZIP/post code.
--	country stores the customer’s country.
--	phone stores the customer’s phone number.
--	registration_date stores the date on which the customer registered.
--	channel_id stores the ID of the channel through which the customer found the shop.
--	first_order_id stores the ID of the first order made by the customer.
--	first_order_date stores the date of the customer’s first order.
--	last_order_id stores the ID of the customer’s last (i.e. most recent) order.
--	last_order_date stores the date of the customer’s last order.
--
--The orders table has the following columns:
--	order_id stores the ID of the order.
--	customer_id stores the ID of the customer who placed the order.
--	order_date stores the date when the order was placed.
--	total_amount stores the total amount paid for the order.
--	ship_name stores the name of the person to whom the order was sent.
--	ship_address stores the address (house number and street) where the order was sent.
--	ship_city stores the city where the order was sent.
--	ship_region stores the region in which the city is located.
--	ship_postalcode stores the destination post code.
--	ship_country stores the destination country.
--	shipped_date stores the date when the order was shipped.
--	
--The products table has the following columns:
--	product_id stores the ID of the product.
--	product_name stores the name of the product.
--	category_id stores the category to which the product belongs.
--	unit_price stores the price for one unit of the product (e.g. per bottle, pack, etc.).
--	discontinued indicates if the product is no longer sold.
--
--The categories table has the following columns:
--	category_id stores the ID of the category.
--	category_name stores the name of the category.
--	description stores a short description of the category.
--
--The order_items table has the following columns:
--	order_id stores the ID of the order in which the product was bought.
--	product_id stores the ID of the product purchased in the order.
--	unit_price stores the per-unit price of the product. (Note that this can be different from the price in the product’s category; the price can change over time and discounts can be applied.)
--	quantity stores the number of units bought in the order.
--	discount stores the discount applied to the given product.
--	
--The channels table has the following columns:
--	id stores the ID of the channel.
--	channel_name stores the name of the channel through which the customer found the shop.
--
--
--1. Create table
--
--2. List the Top 3 Most Expensive Orders
--
--3. Compute Deltas Between Consecutive Orders
--	In this exercise, we're going to compute the difference between two consecutive orders from the same customer.Show the ID of the order (order_id), the ID 
--	of the customer (customer_id), the total_amount of the order, the total_amount of the previous order based on the order_date (name the column previous_value), 
--	and the difference between the total_amount of the current order and the previous order (name the column delta).
--
--4. Compute the Running Total of Purchases per Customer
--	For each customer and their orders, show the following:
--	customer_id – the ID of the customer.
--	full_name – the full name of the customer.
--	order_id – the ID of the order.
--	order_date – the date of the order.
--	total_amount – the total spent on this order.
--	running_total – the running total spent by the given customer.

-- Create Schema
CREATE SCHEMA session3;
SET search_path = session3;

-- Drop existing tables if they exist
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS channels;

-- Create customers table
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    email VARCHAR(100),
    full_name VARCHAR(100),
    address VARCHAR(255),
    city VARCHAR(100),
    region VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100),
    phone VARCHAR(20),
    registration_date DATE,
    channel_id INTEGER,
    first_order_id INTEGER,
    first_order_date DATE,
    last_order_id INTEGER,
    last_order_date DATE
);

-- Create orders table
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    ship_name VARCHAR(100),
    ship_address VARCHAR(255),
    ship_city VARCHAR(100),
    ship_region VARCHAR(100),
    ship_postalcode VARCHAR(20),
    ship_country VARCHAR(100),
    shipped_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Create products table
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(100),
    category_id INTEGER,
    unit_price DECIMAL(10, 2),
    discontinued BOOLEAN
);

-- Create categories table
CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    category_name VARCHAR(100),
    description VARCHAR(255)
);

-- Create order_items table
CREATE TABLE order_items (
    order_id INTEGER,
    product_id INTEGER,
    unit_price DECIMAL(10, 2),
    quantity INTEGER,
    discount DECIMAL(5, 2),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Create channels table
CREATE TABLE channels (
    id INTEGER PRIMARY KEY,
    channel_name VARCHAR(100)
);

-- Insert mock data into channels table
INSERT INTO channels (id, channel_name) VALUES
(1, 'Google'),
(2, 'Facebook'),
(3, 'Instagram'),
(4, 'Twitter'),
(5, 'Direct');

-- Insert mock data into categories table
INSERT INTO categories (category_id, category_name, description) VALUES
(1, 'Electronics', 'Devices and gadgets'),
(2, 'Clothing', 'Apparel and accessories'),
(3, 'Books', 'Fiction and non-fiction books'),
(4, 'Home', 'Furniture and decor'),
(5, 'Sports', 'Sporting goods and equipment');

-- Insert mock data into products table
INSERT INTO products (product_id, product_name, category_id, unit_price, discontinued) VALUES
(1, 'Laptop', 1, 999.99, FALSE),
(2, 'Smartphone', 1, 699.99, FALSE),
(3, 'T-shirt', 2, 19.99, FALSE),
(4, 'Jeans', 2, 49.99, FALSE),
(5, 'Novel', 3, 12.99, FALSE),
(6, 'Cookbook', 3, 24.99, FALSE),
(7, 'Sofa', 4, 399.99, FALSE),
(8, 'Table', 4, 199.99, FALSE),
(9, 'Basketball', 5, 29.99, FALSE),
(10, 'Tennis Racket', 5, 89.99, FALSE);

-- Insert mock data into customers table
INSERT INTO customers (customer_id, email, full_name, address, city, region, postal_code, country, phone, registration_date, channel_id, first_order_id, first_order_date, last_order_id, last_order_date) VALUES
(1, 'john.doe@example.com', 'John Doe', '123 Main St', 'New York', 'NY', '10001', 'USA', '555-1234', '2023-01-15', 1, 1, '2023-02-01', 2, '2023-06-01'),
(2, 'jane.smith@example.com', 'Jane Smith', '456 Elm St', 'Los Angeles', 'CA', '90001', 'USA', '555-5678', '2023-02-10', 2, 3, '2023-03-05', 4, '2023-07-15'),
(3, 'alice.johnson@example.com', 'Alice Johnson', '789 Oak St', 'Chicago', 'IL', '60601', 'USA', '555-8765', '2023-03-20', 3, 5, '2023-04-10', 6, '2023-08-20'),
(4, 'bob.brown@example.com', 'Bob Brown', '321 Pine St', 'Houston', 'TX', '77001', 'USA', '555-4321', '2023-04-25', 4, 7, '2023-05-15', 8, '2023-09-10'),
(5, 'charlie.davis@example.com', 'Charlie Davis', '654 Maple St', 'Phoenix', 'AZ', '85001', 'USA', '555-6789', '2023-05-30', 5, 9, '2023-06-20', 10, '2023-10-01');

-- Insert mock data into orders table
INSERT INTO orders (order_id, customer_id, order_date, total_amount, ship_name, ship_address, ship_city, ship_region, ship_postalcode, ship_country, shipped_date) VALUES
(1, 1, '2023-02-01', 1029.98, 'John Doe', '123 Main St', 'New York', 'NY', '10001', 'USA', '2023-02-03'),
(2, 1, '2023-06-01', 129.99, 'John Doe', '123 Main St', 'New York', 'NY', '10001', 'USA', '2023-06-02'),
(3, 2, '2023-03-05', 149.97, 'Jane Smith', '456 Elm St', 'Los Angeles', 'CA', '90001', 'USA', '2023-03-06'),
(4, 2, '2023-07-15', 89.99, 'Jane Smith', '456 Elm St', 'Los Angeles', 'CA', '90001', 'USA', '2023-07-16'),
(5, 3, '2023-04-10', 24.99, 'Alice Johnson', '789 Oak St', 'Chicago', 'IL', '60601', 'USA', '2023-04-11'),
(6, 3, '2023-08-20', 49.99, 'Alice Johnson', '789 Oak St', 'Chicago', 'IL', '60601', 'USA', '2023-08-21'),
(7, 4, '2023-05-15', 629.98, 'Bob Brown', '321 Pine St', 'Houston', 'TX', '77001', 'USA', '2023-05-16'),
(8, 4, '2023-09-10', 69.99, 'Bob Brown', '321 Pine St', 'Houston', 'TX', '77001', 'USA', '2023-09-11'),
(9, 5, '2023-06-20', 449.98, 'Charlie Davis', '654 Maple St', 'Phoenix', 'AZ', '85001', 'USA', '2023-06-21'),
(10, 5, '2023-10-01', 119.98, 'Charlie Davis', '654 Maple St', 'Phoenix', 'AZ', '85001', 'USA', '2023-10-02');

-- Insert mock data into order_items table
INSERT INTO order_items (order_id, product_id, unit_price, quantity, discount) VALUES
(1, 1, 999.99, 1, 0.00),
(1, 2, 29.99, 1, 0.00),
(2, 9, 29.99, 1, 0.00),
(3, 3, 19.99, 1, 0.00),
(3, 4, 49.99, 1, 0.00),
(3, 6, 79.99, 1, 0.00),
(4, 10, 89.99, 1, 0.00),
(5, 6, 24.99, 1, 0.00),
(6, 4, 49.99, 1, 0.00),
(7, 7, 399.99, 1, 0.00),
(7, 8, 199.99, 1, 0.00),
(8, 5, 69.99, 1, 0.00),
(9, 7, 399.99, 1, 0.00),
(9, 8, 49.99, 1, 0.00),
(10, 4, 49.99, 1, 0.00),
(10, 3, 19.99, 1, 0.00);

-- Insert additional orders and order items for each customer

-- Additional orders for customer 
INSERT INTO orders (order_id, customer_id, order_date, total_amount, ship_name, ship_address, ship_city, ship_region, ship_postalcode, ship_country, shipped_date) VALUES
(11, 1, '2023-07-01', 39.98, 'John Doe', '123 Main St', 'New York', 'NY', '10001', 'USA', '2023-07-02'),
(12, 1, '2023-08-15', 79.97, 'John Doe', '123 Main St', 'New York', 'NY', '10001', 'USA', '2023-08-16'),
(13, 2, '2023-09-20', 69.98, 'Jane Smith', '456 Elm St', 'Los Angeles', 'CA', '90001', 'USA', '2023-09-21'),
(14, 2, '2023-10-05', 49.98, 'Jane Smith', '456 Elm St', 'Los Angeles', 'CA', '90001', 'USA', '2023-10-06'),
(15, 3, '2023-11-01', 59.98, 'Alice Johnson', '789 Oak St', 'Chicago', 'IL', '60601', 'USA', '2023-11-02'),
(16, 3, '2023-11-15', 129.97, 'Alice Johnson', '789 Oak St', 'Chicago', 'IL', '60601', 'USA', '2023-11-16'),
(17, 4, '2023-12-01', 199.98, 'Bob Brown', '321 Pine St', 'Houston', 'TX', '77001', 'USA', '2023-12-02'),
(18, 4, '2023-12-15', 159.97, 'Bob Brown', '321 Pine St', 'Houston', 'TX', '77001', 'USA', '2023-12-16'),
(19, 5, '2023-11-01', 199.98, 'Charlie Davis', '654 Maple St', 'Phoenix', 'AZ', '85001', 'USA', '2023-11-02'),
(20, 5, '2023-11-15', 49.99, 'Charlie Davis', '654 Maple St', 'Phoenix', 'AZ', '85001', 'USA', '2023-11-16'),
(21, 5, '2023-12-01', 129.98, 'Charlie Davis', '654 Maple St', 'Phoenix', 'AZ', '85001', 'USA', '2023-12-02');

-- Insert additional order items for the new orders

-- Order items for new orders of customer
INSERT INTO order_items (order_id, product_id, unit_price, quantity, discount) VALUES
(11, 5, 12.99, 2, 0.00),
(12, 2, 29.99, 2, 0.00),
(13, 1, 999.99, 1, 0.00),
(14, 3, 19.99, 2, 0.00),
(15, 9, 29.99, 2, 0.00),
(16, 4, 49.99, 2, 0.00),
(17, 7, 399.99, 2, 0.00),
(18, 10, 89.99, 2, 0.00),
(19, 8, 199.99, 1, 0.00),
(20, 6, 24.99, 2, 0.00),
(21, 3, 19.99, 2, 0.00);



--2. List the Top 3 Most Expensive Orders

--SELECT 
--	o.order_id,
--	o.total_amount
--FROM session3.orders o
--ORDER BY o.total_amount DESC
--LIMIT 3;

WITH orders_price_rank AS (
	SELECT 
		o.order_id,
		o.total_amount,
		RANK() OVER (ORDER BY o.total_amount DESC) AS exp_rank
	FROM session3.orders o
)

SELECT 
	o.order_id,
	o.total_amount
FROM orders_price_rank o
WHERE o.exp_rank <= 3;

--3. Compute Deltas Between Consecutive Orders
--	In this exercise, we're going to compute the difference between two consecutive orders from the same customer.Show the ID of the order (order_id), the ID 
--	of the customer (customer_id), the total_amount of the order, the total_amount of the previous order based on the order_date (name the column previous_value), 
--	and the difference between the total_amount of the current order and the previous order (name the column delta).
	
SELECT
	o.order_id,
	o.customer_id,
	o.order_date,
	o.total_amount,
	LAG(o.total_amount,1) OVER (
		PARTITION BY o.customer_id 
		ORDER BY o.order_date
	) AS previous_total_amount,
	o.total_amount - LAG(o.total_amount,1) OVER (
		PARTITION BY o.customer_id 
		ORDER BY o.order_date
	) AS delta
FROM session3.orders o
ORDER BY o.customer_id, o.order_date;

--4. Compute the Running Total of Purchases per Customer
--	For each customer and their orders, show the following:
--	customer_id – the ID of the customer.
--	full_name – the full name of the customer.
--	order_id – the ID of the order.
--	order_date – the date of the order.
--	total_amount – the total spent on this order.
--	running_total – the running total spent by the given customer.

SELECT
	o.customer_id,
	c.full_name,
	o.order_id,
	o.order_date,
	o.total_amount,
	sum(o.total_amount) OVER (
		PARTITION BY o.customer_id
		ORDER BY o.order_date
	) AS running_total
FROM session3.orders o
JOIN session3.customers c ON o.customer_id=c.customer_id
ORDER BY o.customer_id, o.order_date;


