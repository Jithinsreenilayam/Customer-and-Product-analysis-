
													/*CUSTOMERS AND PRODUCTS ANALYSIS */


/* SCREEN 3 -TASK 1*/

SELECT 'customers' AS table_name, 
       COUNT(*) AS num_attributes, 
       (SELECT COUNT(*) FROM customers) AS num_rows
FROM pragma_table_info('customers')
UNION ALL
SELECT 'employees' AS table_name, 
       COUNT(*) AS num_attributes, 
       (SELECT COUNT(*) FROM employees) AS num_rows
FROM pragma_table_info('employees')
UNION ALL
SELECT 'offices' AS table_name, 
       COUNT(*) AS num_attributes, 
       (SELECT COUNT(*) FROM offices) AS num_rows
FROM pragma_table_info('offices')
UNION ALL
SELECT 'orderdetails' AS table_name, 
       COUNT(*) AS num_attributes, 
       (SELECT COUNT(*) FROM orderdetails) AS num_rows
FROM pragma_table_info('orderdetails')
UNION ALL
SELECT 'orders' AS table_name, 
       COUNT(*) AS num_attributes, 
       (SELECT COUNT(*) FROM orders) AS num_rows
FROM pragma_table_info('orders')
UNION ALL
SELECT 'payments' AS table_name, 
       COUNT(*) AS num_attributes, 
       (SELECT COUNT(*) FROM payments) AS num_rows
FROM pragma_table_info('payments')
UNION ALL
SELECT 'productlines' AS table_name, 
       COUNT(*) AS num_attributes, 
       (SELECT COUNT(*) FROM productlines) AS num_rows
FROM pragma_table_info('productlines')
UNION ALL
SELECT 'products' AS table_name, 
       COUNT(*) AS num_attributes, 
       (SELECT COUNT(*) FROM products) AS num_rows
FROM pragma_table_info('products');

/*SCREEN 4 - TASK 2*/

SELECT productCode, 
       ROUND(SUM(quantityOrdered)*1.0 / (SELECT quantityInStock
                                           FROM products ps
                                          WHERE ods.productCode = ps.productCode), 2) AS low_stock
  FROM orderdetails ods
 GROUP BY productCode
 ORDER BY low_stock DESC
 LIMIT 10;
 
SELECT productCode, ROUND(SUM(quantityOrdered*priceEach),2) AS product_performance
  FROM orderdetails
 GROUP BY productCode
 ORDER BY product_performance DESC
 LIMIT 10; 
 
/* SCREEN 4- TASK 3*/
 
WITH 
low_stock_table AS (
SELECT productCode, 
       ROUND(SUM(quantityOrdered)*1.0 / (SELECT quantityInStock
                                           FROM products ps
                                          WHERE ods.productCode = ps.productCode), 2) AS low_stock
  FROM orderdetails ods
 GROUP BY productCode
 ORDER BY low_stock DESC
 LIMIT 10
)
 
SELECT ods.productCode, ps.productName, ps.productLine, ROUND(SUM(quantityOrdered*priceEach),2) AS product_performance
  FROM orderdetails AS ods
  JOIN products AS ps
    ON ods.productCode=ps.productCode
 WHERE ods.productCode IN (SELECT productCode 
                             FROM low_stock_table)
 GROUP BY ods.productCode
 ORDER BY product_performance DESC
 LIMIT 10;
 
/*SCREEN 5- TASK 4*/

SELECT customerNumber, ROUND(SUM(ods.quantityOrdered*(ods.priceEach-ps.buyPrice)),2) AS Pofit
  FROM orders AS os
  JOIN orderdetails AS ods
    ON os.orderNumber=ods.orderNumber
  JOIN products AS ps
    ON ods.productCode=ps.productCode
 GROUP BY customerNumber
 ORDER BY ROUND(SUM(ods.quantityOrdered*(ods.priceEach-ps.buyPrice)),2) DESC;
 
 /*SCREEN 6 - TASK 5*/
 
 WITH 
 profit_table AS(
SELECT customerNumber, ROUND(SUM(ods.quantityOrdered*(ods.priceEach-                  ps.buyPrice)),2) AS Profit
  FROM orders AS os
  JOIN orderdetails AS ods
    ON os.orderNumber=ods.orderNumber
  JOIN products AS ps
    ON ods.productCode=ps.productCode
 GROUP BY customerNumber
 )
 
SELECT contactLastName, contactFirstName, city, country, pt.Profit
  FROM customers AS c
  JOIN profit_table AS pt
    ON c.customerNumber=pt.customerNumber
 ORDER BY profit DESC
  LIMIT 5;
 
/* SCREEN 6- TASK 6*/


WITH 
profit_table AS(
SELECT customerNumber, ROUND(SUM(ods.quantityOrdered*(ods.priceEach-                  ps.buyPrice)),2) AS Profit
  FROM orders AS os
  JOIN orderdetails AS ods
    ON os.orderNumber=ods.orderNumber
  JOIN products AS ps
    ON ods.productCode=ps.productCode
 GROUP BY customerNumber
 )
 
SELECT contactLastName, contactFirstName, city, country, pt.Profit
  FROM customers AS c
  JOIN profit_table AS pt
    ON c.customerNumber=pt.customerNumber
 ORDER BY profit ASC
  LIMIT 5;
 

 /*SCREEN 7 - TASK 7*/
 
WITH 
profit_table AS(
SELECT customerNumber, ROUND(SUM(ods.quantityOrdered*(ods.priceEach- ps.buyPrice)),2) AS Profit
  FROM orders AS os
  JOIN orderdetails AS ods
    ON os.orderNumber=ods.orderNumber
  JOIN products AS ps
    ON ods.productCode=ps.productCode
 GROUP BY customerNumber
 )
 
SELECT ROUND(AVG(Profit),2) AS avg_profit
  FROM profit_table;


/* 
Conclusion:
In our data exploration journey, we learned a lot about our business. We found out which products are selling
 well and which ones need more attention. For example, classic cars are super popular and bring in a lot of 
 money, so we should make sure we always have them in stock. We also looked at our customers and figured out 
 who's making us the most money. It turns out, our VIP customers are really important, so we should make sure
 they're happy. Also, we learned about  the least engaged ones who we need to reach out to more.

By understanding all this information, we can make smarter decisions about how to run our business. We know
 where to focus our efforts – like keeping classic cars in stock and making sure our VIP customers are taken 
 care of. And we also have an idea of how much we can spend on getting new customers. This helps us plan for 
 the future and keep our business growing.
  
 Project:
 Our journey into the world of business data was like setting off on a big adventure. Armed with our trusty 
 SQL queries, we set out to uncover hidden treasures in our database. Along the way, we discovered some 
 fascinating things about what we sell and who buys from us.

We found out that people really love classic cars, so we know we need to keep them in stock. Understanding 
what our customers like helps us make sure we're giving them what they want. We also learned who our best 
customers are and how to keep them happy. By knowing who's most valuable to us, we can focus on keeping them 
coming back.

As we sailed through the sea of data, we also learned how to plan for the future. By figuring out how much 
our customers are worth over time, we can make sure we're spending our money wisely. This helps us make sure
 we're ready for whatever challenges come our way. In the end, our journey through our data helped us learn 
 a lot about our business. We're using what we found to make better decisions and keep our customers happy.
 */