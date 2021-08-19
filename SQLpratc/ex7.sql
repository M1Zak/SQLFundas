--JOINS

--N.B. A parent table will have a primary key; like, customer_id in the CUSTOMER table, and the child table will have a foreign key; like, Customer_id :1 in the Customer_order table
--The primary key is unique and can map to multiple foreign keys.

/*SELECT *
FROM customer
INNER JOIN customer_order ON
customer.CUSTOMER_ID = customer_order.customer_ID*/

--INNER JOIN returns the intersection of the two tables only. To see all the customer without any orders, we use LEFT JOIN.

/*SELECT *
FROM customer
LEFT JOIN customer_order ON
customer.CUSTOMER_ID = customer_order.CUSTOMER_ID*/

/*SELECT *
FROM customer
INNER JOIN customer_order
ON customer.customer_ID = customer_order.CUSTOMER_ID
INNER JOIN product
ON product.PRODUCT_ID = customer_order.PRODUCT_ID*/

--To find customers with no orders, that is orphanned data we always use LEFT JOIN for the better.

/*SELECT *
FROM customer
LEFT JOIN customer_order
ON customer_order.CUSTOMER_ID = customer.CUSTOMER_ID
WHERE order_id IS NULL*/

--To find, products with no orders,  that is again orphanned data we always use LEFT JOIN for the better.

/*SELECT *
FROM product
LEFT JOIN customer_order
ON customer_order.product_id = product.PRODUCT_ID
WHERE order_id IS NULL*/

--Trying the same by joining all three tables

/*SELECT *
FROM product
LEFT JOIN customer_order
ON product.product_id = customer_order.PRODUCT_ID
LEFT JOIN customer
ON customer_order.CUSTOMER_ID = customer.CUSTOMER_ID
WHERE order_id IS NULL*/

--To find the total revenue and also handle any nulls on the way, can be done with lEFT or INNER JOIN/JOIN. LEFT is better any day, as it brings in all of the primary table.

/*SELECT  name, customer_ID, order_qty, price, description,
coalesce(round(sum(order_qty * price),1), 0) AS total_revenue
FROM customer
LEFT JOIN customer_order
ON customer_order.CUSTOMER_ID = customer.customer_id
LEFT JOIN product
ON product.PRODUCT_ID = customer_order.product_id 
GROUP by description
ORDER BY total_revenue DESC*/

--finding sum as there are multiple orders from the same customer.


