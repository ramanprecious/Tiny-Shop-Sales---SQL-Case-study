# Tiny-Shop-Sales---SQL-Case-study

![image](https://github.com/ramanprecious/Tiny-Shop-Sales---SQL-Case-study/assets/62135469/6b7a0f87-9f1e-4338-b768-e4a84aa74534)

This case study is aimed at creating and obtaining insights from the newly created Tiny Shop Sales database through querying.
The Tiny Shop Sales Database consists of four (4) tables:

1. Customers: This has all customer details.
2. Products: This has all product and price details.
3. Orders: It contains all orders, including the order dates.
4. Order items: It has all quantities ordered and recorded.

This database was created and queried on the Pgadmin platform using PostgreSQL functions and tools like:
1. Basic Aggregation
2. CASE-WHEN statements
3. Windows Functions
4. Joins
5. Date Time Functions
6. CTEs

The insights generated include:
1. Which product has the highest price? Only return a single row.
```
   SELECT product_name, price
   FROM products
   WHERE price = (
	SELECT MAX(price) 
	FROM products);

Output: Product M with a price of 70.00
```
2. Which customer has made the most orders?
```
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
Output:
 Fullname     count
"Bob Johnson"	2
"John Doe"	2
"Jane Smith"	2
```
3. What’s the total revenue per product?
```
SELECT p.product_name, 
	SUM(p.price*oi.quantity) AS Total_revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY p.product_name ASC;

Output:
Product_name   Total_revenue
"Product A"	50.00
"Product B"	135.00
"Product C"	160.00
"Product D"	75.00
"Product E"	90.00
"Product F"	210.00
"Product G"	120.00
"Product H"	135.00
"Product I"	150.00
"Product J"	330.00
"Product K"	180.00
"Product L"	195.00
"Product M"	420.00
```
4. Find the day with the highest revenue.
 ```
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

Output:
Order_date     Revenue
"2023-05-16"	340.00
``` 
5. Find the first order (by date) for each customer.
```
SELECT Fullname, order_date
FROM 
(SELECT CONCAT(c.first_name, ' ', c.last_name) AS Fullname, o.order_date,
 DENSE_RANK() OVER (PARTITION BY CONCAT(c.first_name, ' ', c.last_name) 
					ORDER BY order_date) AS Ranking
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id) AS ranked_table
WHERE ranking = 1;

Output:
Fullname        Order_date
"Alice Brown"	"2023-05-07"
"Bob Johnson"	"2023-05-03"
"Charlie Davis"	"2023-05-08"
"Eva Fisher"	"2023-05-09"
"George Harris"	"2023-05-10"
"Ivy Jones"	"2023-05-11"
"Jane Smith"	"2023-05-02"
"John Doe"	"2023-05-01"
"Kevin Miller"	"2023-05-12"
"Lily Nelson"	"2023-05-13"
"Oliver Patterson"	"2023-05-14"
"Quinn Roberts"	"2023-05-15"
"Sophia Thomas"	"2023-05-16"
```
6. Find the top 3 customers who have ordered the most distinct products
```
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

Output:
Fullname       count_of_product
"Bob Johnson"	3
"Jane Smith"	3
"John Doe"	3
```
7. Which product has been bought the least in terms of quantity?
```
WITH Tab AS
(SELECT p.product_name, SUM(quantity) as total_quantity
FROM order_items oi
LEFT JOIN products p
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_quantity ASC)

SELECT * FROM Tab 
WHERE total_quantity = (SELECT MIN(total_quantity) FROM Tab);

Output:
product_name  total_quantity
"Product L"	3
"Product I"	3
"Product H"	3
"Product E"	3
"Product D"	3
"Product G"	3
"Product K"	3
```
8. What is the median order total?
```
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

Output:
The median order total is 112.5
```
9. For each order, determine if it was ‘Expensive’ (total over 300), ‘Affordable’ (total over 100), or ‘Cheap’.
```
SELECT order_id, 
 	p.price*oi.quantity AS Total_Revenue, 
 	CASE WHEN p.price*oi.quantity > 300 THEN 'Expensive'
 		WHEN p.price*oi.quantity > 100 THEN 'Affordable'
 		ELSE 'Cheap' END AS Price_Category
FROM products p
RIGHT JOIN order_items oi
ON p.product_id = oi.product_id

Output:
order_id Revenue Price_category
1	20.00	"Cheap"
1	15.00	"Cheap"
2	15.00	"Cheap"
2	60.00	"Cheap"
3	10.00	"Cheap"
3	40.00	"Cheap"
4	60.00	"Cheap"
4	20.00	"Cheap"
5	10.00	"Cheap"
5	40.00	"Cheap"
6	45.00	"Cheap"
6	10.00	"Cheap"
7	25.00	"Cheap"
7	60.00	"Cheap"
8	105.00	"Affordable"
8	40.00	"Cheap"
9	90.00	"Cheap"
9	50.00	"Cheap"
10	165.00	"Affordable"
10	120.00	"Affordable"
11	65.00	"Cheap"
11	210.00	"Affordable"
12	50.00	"Cheap"
12	30.00	"Cheap"
13	105.00	"Affordable"
13	80.00	"Cheap"
14	45.00	"Cheap"
14	100.00	"Cheap"
15	165.00	"Affordable"
15	60.00	"Cheap"
16	130.00	"Affordable"
16	210.00	"Affordable"
```
10. Find customers who have ordered the product with the highest price.
```
SELECT CONCAT(c.first_name, ' ', c.last_name) AS Fullname
 FROM customers c
 JOIN orders o
 ON c.customer_id = o.customer_id
 JOIN order_items oi
 ON oi.order_id = o.order_id
 WHERE oi.product_id = (SELECT product_id
					 FROM products
 					 WHERE price = (SELECT MAX(price) FROM products));

Output:
fullname
"Ivy Jones"
"Sophia Thomas"
  

   

