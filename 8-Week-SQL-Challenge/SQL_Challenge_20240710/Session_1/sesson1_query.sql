--The color table contains the following columns:
--	idstores the unique ID for each color.
--	name stores the name of the color.
--	extra_fee stores the extra charge (if any) added for clothing ordered in this color.
--	
--In the customer table, you'll find the following columns:
--
--	id stores customer IDs.
--	first_name stores the customer's first name.
--	last_name stores the customer's last name.
--	favorite_color_idstores the ID of the customer's favorite color (references the color table).
--
--The category table contains these columns:
--	id stores the unique ID for each category.
--	name stores the name of the category.
--	parent_id stores the ID of the main category for this category (if it's a subcategory). If this value is NULL, it denotes that this category is a main category. Note: Values are related to those in the id column in this table.
--
--The clothing table stores data in the following columns:
--	id stores the unique ID for each item.
--	name stores the name of that item.
--	size stores the size of that clothing: S, M, L, XL, 2XL, or 3XL.
--	price stores the item's price.
--	color_id stores the item's color (references the color table).
--	category_id stores the item's category (references the category table).
--
--The clothing_order table contains the following columns:
--	id stores the unique order ID.
--	customer_id stores the ID of the customer ordering the clothes (references the customer table).
--	clothing_id stores the ID of the item ordered (references the clothing table).
--	items stores how many of that clothing item the customer ordered.
--	order_date stores the date of the order.
--
--
--1. Create Tables

SET search_path = session1;

DROP TABLE IF EXISTS colors;
CREATE TABLE colors (
	"color_id" INTEGER,
	"color_name" VARCHAR,
	"extra_fee" INTEGER
);

DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
	"customer_id" INTEGER,
	"first_name" VARCHAR,
	"last_name" VARCHAR,
	"fav_color_id" INTEGER
);

DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
	"category_id" INTEGER,
	"category_name" VARCHAR,
	"parent_id" INTEGER
);

DROP TABLE IF EXISTS clothings;
CREATE TABLE clothings (
	"clothing_id" INTEGER,
	"clothing_name" VARCHAR,
	"size" VARCHAR,
	"price" INTEGER,
	"color_id" INTEGER,
	"category_id" INTEGER
);

DROP TABLE IF EXISTS clothing_order;
CREATE TABLE clothing_order (
	"order_id" INTEGER,
	"customer_id" INTEGER,
	"clothing_id" INTEGER,
	"items" INTEGER,
	"order_date" DATE
);

-- Insert data into colors table
INSERT INTO colors (color_id, color_name, extra_fee) VALUES
(1, 'Red', 2),
(2, 'Blue', 0),
(3, 'Green', 1),
(4, 'Yellow', 0),
(5, 'Black', 3);

-- Insert data into customers table
INSERT INTO customers (customer_id, first_name, last_name, fav_color_id) VALUES
(1, 'John', 'Doe', 1),
(2, 'Jane', 'Smith', 2),
(3, 'Alice', 'Johnson', 3),
(4, 'Bob', 'Brown', 4),
(5, 'Charlie', 'Davis', 5),
(6, 'Jessica', 'Davis', 5),
(7, 'Robert', 'Davis', 5);

-- Insert data into categories table
INSERT INTO categories (category_id, category_name, parent_id) VALUES
(1, 'Men', NULL),
(2, 'Women', NULL),
(3, 'Kids', NULL),
(4, 'Shirts', 1),
(5, 'Pants', 1);

-- Insert data into clothings table
INSERT INTO clothings (clothing_id, clothing_name, size, price, color_id, category_id) VALUES
(1, 'Red Shirt', 'S', 20, 1, 4),
(2, 'Blue Shirt', 'M', 22, 2, 4),
(3, 'Green Shirt', 'L', 23, 3, 4),
(4, 'Yellow Shirt', 'XL', 21, 4, 4),
(5, 'Black Shirt', '2XL', 25, 5, 4),
(6, 'Red Pants', 'S', 30, 1, 5),
(7, 'Blue Pants', 'M', 32, 2, 5),
(8, 'Green Pants', 'L', 33, 3, 5),
(9, 'Yellow Pants', 'XL', 31, 4, 5),
(10, 'Black Pants', '2XL', 35, 5, 5);

-- Insert data into clothing_order table
INSERT INTO clothing_order (order_id, customer_id, clothing_id, items, order_date) VALUES
(1, 1, 1, 2, '2023-01-15'),
(2, 2, 2, 1, '2023-01-20'),
(3, 3, 3, 3, '2023-02-10'),
(4, 4, 4, 1, '2023-02-15'),
(5, 5, 5, 2, '2023-02-20'),
(6, 1, 6, 1, '2023-03-05'),
(7, 2, 7, 2, '2023-03-10'),
(8, 3, 8, 1, '2023-03-15'),
(9, 4, 9, 3, '2023-04-01'),
(10, 5, 10, 1, '2023-04-05'),
(11, NULL, 10, 1, '2023-04-05');


--2. List All Clothing Items
--Display the name of clothing items (name the column clothes), their color (name the column color), and the last name and first name of the customer(s) who bought this apparel in 
--their favorite color. Sort rows according to color, in ascending order.

SELECT
	c.clothing_name AS clothes,
	c3.color_name AS color,
	c2.last_name,
	c2.first_name
FROM session1.clothing_order co
JOIN session1.clothings c ON co.clothing_id = c.clothing_id
JOIN session1.customers c2 ON co.customer_id = c2.customer_id
JOIN session1.colors c3 ON c.color_id = c3.color_id
WHERE c.color_id = c2.fav_color_id
ORDER BY c3.color_name ASC;

--3. Get All Non-Buying Customers
--Select the last name and first name of customers and the name of their favorite color for customers with no purchases.
SELECT
	c.last_name,
	c.first_name,
	c2.color_name
FROM session1.customers c
JOIN session1.colors c2 ON c.fav_color_id = c2.color_id
WHERE NOT EXISTS (SELECT co.customer_id FROM session1.clothing_order co WHERE c.customer_id = co.customer_id);

--4. Select All Main Categories and Their Subcategories
--Select the name of the main categories (which have a NULL in the parent_id column) and the name of their direct subcategory (if one exists). Name the first column category 
--and the second column subcategory.

SELECT 
	c.category_name AS category,
	c2.category_name AS subcategory
FROM session1.categories c
LEFT JOIN session1.categories c2 ON c.category_id = c2.parent_id
--RIGHT JOIN session1.categories c2 ON c.parent_id = c2.category_id
WHERE c.parent_id IS NULL;




