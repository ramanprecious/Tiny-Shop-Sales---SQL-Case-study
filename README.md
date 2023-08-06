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
   > SELECT product_name, price
> FROM products
> WHERE price = (
	> SELECT MAX(price) 
	> FROM products);

3. Which customer has made the most orders?
4. What’s the total revenue per product?
5. Find the day with the highest revenue.
6. Find the first order (by date) for each customer.
7. Find the top 3 customers who have ordered the most distinct products
8. Which product has been bought the least in terms of quantity?
9. What is the median order total?
10. For each order, determine if it was ‘Expensive’ (total over 300), ‘Affordable’ (total over 100), or ‘Cheap’.
11. Find customers who have ordered the product with the highest price.

  

   

