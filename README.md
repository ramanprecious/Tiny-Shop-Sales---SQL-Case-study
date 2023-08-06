# Tiny-Shop-Sales---SQL-Case-study

![image](https://github.com/ramanprecious/Tiny-Shop-Sales---SQL-Case-study/assets/62135469/6b7a0f87-9f1e-4338-b768-e4a84aa74534)

This case study is aimed at creating and obtaining insights from the newly created Tiny Shop Sales database through querying.
The Tiny Shop Sales Database consists of four (4) tables:

1. Customers: This has all customer details’
2. Products: This has all product and price details.
3. Orders: It contains all orders, including the order dates.
4. Order items: It has all order quantity recorded.

This database was created and queried on the Pgadmin platform using PostgreSQL functions and tools like:
1. Basic Aggregation
2. CASE WHEN statements
3. Windows Functions
4. Joins
5. Date Time Functions
6. CTEs

The questions answered include:
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
  
7. Find the first order (by date) for each customer.
8. Find the top 3 customers who have ordered the most distinct products
9. Which product has been bought the least in terms of quantity?
10. What is the median order total?
11. For each order, determine if it was ‘Expensive’ (total over 300), ‘Affordable’ (total over 100), or ‘Cheap’.
12. Find customers who have ordered the product with the highest price.

  

   

