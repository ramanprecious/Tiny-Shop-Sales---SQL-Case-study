SELECT * FROM customers;
SELECT * FROM order_items;
SELECT * FROM orders;
SELECT * FROM products;

-- Question one: Which product has the highest price?
SELECT product_name, price
FROM products
WHERE price = (
	SELECT MAX(price) 
	FROM products
	);

-- Question two: Which customer has made the most orders?
WITH Customer_order AS (
	SELECT o.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS Fullname
	FROM customers c
	JOIN orders o
	ON c.customer_id = o.customer_id
	)
SELECT fullname, COUNT(customer_id) as no_of_order
FROM Customer_order
GROUP BY fullname
HAVING COUNT(customer_id) = (SELECT COUNT(customer_id) AS count
							FROM Customer_order
							GROUP BY customer_id
							ORDER BY count DESC
							LIMIT 1
							);

-- Question three: What’s the total revenue per product?
SELECT p.product_name, 
	SUM(p.price*oi.quantity) AS Total_revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY p.product_name ASC;

-- Question four: Find the day with the highest revenue?
WITH date_price_quant AS (SELECT o.order_date, 
						  p.price, oi.quantity
						  FROM products p
						  JOIN order_items oi
						  ON p.product_id = oi.product_id
						  JOIN orders o
						  ON oi.order_id = o.order_id)

SELECT order_date, SUM(price*quantity) AS Revenue
FROM date_price_quant
GROUP BY order_date
ORDER BY order_date DESC
LIMIT 1;

-- Question five: Find the first order (by date) for each customer?
SELECT Fullname, order_date
FROM 
(SELECT CONCAT(c.first_name, ' ', c.last_name) AS Fullname, o.order_date,
 DENSE_RANK() OVER (PARTITION BY CONCAT(c.first_name, ' ', c.last_name) 
					ORDER BY order_date) AS Ranking
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id) AS ranked_table
WHERE ranking = 1;

-- Question six: Find the top 3 customers who have ordered the most distinct products?
SELECT CONCAT(c.first_name, ' ', c.last_name) AS Fullname,
		COUNT(DISTINCT oi.product_id) AS count_of_product
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY CONCAT(c.first_name, ' ', c.last_name)
ORDER BY count_of_product DESC
LIMIT 3;

-- Question seven: Which product has been bought the least in terms of quantity?
WITH Tab AS
(SELECT p.product_name, SUM(quantity) as total_quantity
FROM order_items oi
LEFT JOIN products p
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_quantity ASC)

SELECT * FROM Tab 
WHERE total_quantity = (SELECT MIN(total_quantity) FROM Tab);

-- Question eight: What is the median order total?
WITH TAB AS 
(SELECT oi.order_id, SUM(p.price*oi.quantity) AS Order_total, 
		ROW_NUMBER() OVER (ORDER BY SUM(p.price*oi.quantity)) AS Rows_No
FROM products p
RIGHT JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY oi.order_id)

SELECT PERCENTILE_CONT(0.50)
WITHIN GROUP (ORDER BY order_total)
FROM TAB

-- Question nine: For each order, determine if it was ‘Expensive’ (total over 300), ‘Affordable’ (total over 100), or ‘Cheap’?
SELECT order_id, 
 	p.price*oi.quantity AS Total_Revenue, 
 	CASE WHEN p.price*oi.quantity > 300 THEN 'Expensive'
 		WHEN p.price*oi.quantity > 100 THEN 'Affordable'
 		ELSE 'Cheap' END AS Price_Category
FROM products p
RIGHT JOIN order_items oi
ON p.product_id = oi.product_id
 
-- Question ten: Find customers who have ordered the product with the highest price?
SELECT CONCAT(c.first_name, ' ', c.last_name) AS Fullname
 FROM customers c
 JOIN orders o
 ON c.customer_id = o.customer_id
 JOIN order_items oi
 ON oi.order_id = o.order_id
 WHERE oi.product_id = (SELECT product_id
					 FROM products
 					 WHERE price = (SELECT MAX(price) FROM products));
 
