--Aex2.sql
--Using thunderbird_manufacturing db
--Self Joins and Self joins with Subquery.

SELECT c1.customer_order_id,
c1.customer_id,
c1.product_id,
c1.order_date,
c2.order_date,
c1.quantity,
c2.quantity AS prev_day_quantity

FROM CUSTOMER_ORDER c1 LEFT JOIN CUSTOMER_ORDER c2

ON c1.customer_id = c2.customer_id
AND c1.product_id = c2.product_id
--AND c2.order_date < c1.order_date
AND c2.order_date = date(c1.order_date, '-1 day')

WHERE c1.order_date BETWEEN '2017-03-05' AND '2017-03-11';
--ORDER BY c2.order_date;

--This query returns the previous day quantity by joining the same table.

--The above result can also be obtained using a Subquery that also inculcates a Self Join, where we find the previous quantity 
-- of a product where the order date is not limited only to the previous day. Doing so, will bring all the previous quantities past the latest date.

SELECT order_date,
product_id,
customer_id,
quantity,
(
    SELECT quantity
    FROM CUSTOMER_ORDER c2
    WHERE c1.order_date > c2.order_date --This condition should bring the past order's product quantity.
   -- AND c1.customer_id = c2.customer_id
  --  AND c1.product_id = c2.product_id
    ORDER BY order_date DESC
    LIMIT 1 --LIMIT clause restricts how many rows are returned from a query
    --Also Sub-select can return only 1 column.
) AS prev_qnty
FROM CUSTOMER_ORDER c1;

--WHERE order_date BETWEEN '2017-03-05' AND '2017-03-11'
--ORDER BY product_id, customer_id;

--Recursive Self Join

SELECT * FROM EMPLOYEE;

--To find the manager of an employee, using Self-Join

SELECT e1.first_name,
e1.last_name,
e1.title,
e2.first_name AS manager_first_name,
e2.last_name AS manager_last_name

FROM EMPLOYEE e1 INNER JOIN EMPLOYEE e2
ON e1.manager_id = e2.id

WHERE e1.first_name = 'Daniel';

--To find the Hierarchy of employees, all the way up to the CEO.

WITH RECURSIVE hierarchy_of_daniel(x) AS (
    SELECT 21 --start with Daniel's ID
    UNION ALL --append each manager ID recursively
    SELECT manager_id
    FROM hierarchy_of_daniel INNER JOIN EMPLOYEE
    ON EMPLOYEE.id = hierarchy_of_daniel.x --Employee ID must equal previous recursive
)

SELECT * FROM EMPLOYEE
WHERE id IN hierarchy_of_daniel;

--We can further use the Recursive Self Join as a Sub query to generate a column that returns the Hierarchy of all employees.

SELECT * ,
(
     WITH RECURSIVE hierarchy_of(x) AS (
         SELECT e1.ID
         UNION ALL  --Acts as a loop
         SELECT manager_id
         FROM hierarchy_of INNER JOIN EMPLOYEE
         ON EMPLOYEE.id = hierarchy_of.x
         )  
     SELECT GROUP_CONCAT(ID) FROM EMPLOYEE e2 --This SELECT statement is part of the RECURSIVE CTE.
     WHERE ID IN hierarchy_of
    
) AS Hierarchy_ids

FROM EMPLOYEE e1;

--A simple use case for Recursive, is it can be used to generate a column of consecutive values.

WITH RECURSIVE my_integers(x) AS (
    SELECT 1
        UNION ALL
    SELECT x + 1
    FROM my_integers
    WHERE x < 1000
)
SELECT * FROM my_integers;

WITH RECURSIVE my_dates(x) AS (
     SELECT date('now')
         UNION ALL
     SELECT date(x, '+1 day')
     FROM my_dates
     WHERE x < '2030-12-31'
)
SELECT * FROM my_dates;

--Cross joins with Derived tables and CTEs.

--Let's say we wanted to check the order quantity of all products with respect to each order date.

--Cross joins can be used to fill in gaps in data, where aggregation functions are used on those data.

SELECT order_date,
product_id,
SUM(quantity) AS total_qnty
FROM CUSTOMER_ORDER

GROUP BY 1,2;

--The query above generates a result, and we see that are not seeing all products, even if there are no orders on them.

--Thus, we use CROSS JOIN, to match every product with a date.

SELECT
calendar_date,
product_id
FROM PRODUCT CROSS JOIN CALENDAR
WHERE calendar_date BETWEEN '2017-01-01' AND '2017-03-31'

GROUP BY calendar_date, product_id;

--Above, we see that we need a calendar date with all dates from the CALENDAR table, unlike order_date from the CUSTOMER_ORDER table.

--This query provides a result where, all product ids can be seen.

--Thus, now we can either use a Derived table or a CTE to join the quantity from customer_order.

SELECT 
calendar_date,
crossed.product_id,
coalesce(total_qnty, 0) AS total_qnty

FROM
(
    SELECT
    calendar_date,
    product_id
    FROM PRODUCT CROSS JOIN CALENDAR
    WHERE calendar_date BETWEEN '2017-01-01' AND '2017-03-31'
) crossed

LEFT JOIN
(
    SELECT
    order_date,
    product_id,
    SUM(quantity) as Total_qnty
    FROM CUSTOMER_ORDER
    GROUP BY 1, 2
) total_qnty

ON crossed.calendar_date = total_qnty.order_date
AND crossed.product_id = total_qnty.product_id

GROUP BY calendar_date, crossed.product_id;

--We can do the same, also with CTEs.

WITH crossed AS (
    SELECT
    calendar_date,
    product_id
    FROM PRODUCT CROSS JOIN CALENDAR
    WHERE calendar_date BETWEEN '2017-01-01' AND '2017-03-31'
)

,total_qnty AS (
    SELECT
    order_date,
    product_id,
    SUM(quantity) AS tot_Q
    FROM CUSTOMER_ORDER
    GROUP BY 1, 2
)

SELECT calendar_date,
crossed.product_id,
coalesce(tot_Q, 0) AS TOT_Q

FROM CROSSED LEFT JOIN TOTAL_QNTY
ON crossed.calendar_date = total_qnty.order_date
AND crossed.product_id = total_qnty.product_id

GROUP BY 1, 2;

-- Below are some Windowing functions, using Partition BY.
--Windowing functions provide an improvement over Derived tables, subqueries, and CTEs, as they are concise, and also faster and organise columns as a result.


SELECT customer_order_id,
customer_id,
order_date,
product_id,
quantity,
AVG(quantity) OVER(PARTITION BY product_id, customer_id) AS avg_product_qty_ordered,
MAX(quantity) OVER(PARTITION BY product_id, customer_id) AS max_product_qty_ordered,
MIN(quantity) OVER(PARTITION BY product_id, customer_id) AS min_product_customer_qty_ordered,
MIN(quantity) OVER(PARTITION BY product_id) AS min_product_qty_ordered,
MIN(quantity) OVER(PARTITION BY customer_id) AS min_customer_qty_ordered

FROM customer_order

WHERE order_date BETWEEN '2017-03-01' AND '2017-03-31'

WINDOW x AS (PARTITION BY product_id, customer_id) --Could be used if there is only one product_id and customer_id used. Using it 
-- for all product_ids gives only one value for all other ids.

ORDER BY customer_order_id;

--We can use ORDER BY windowing func to generate rolling aggregation.

SELECT customer_order_id,
customer_id,
order_date,
product_id,
quantity,
SUM(quantity) OVER(ORDER BY order_date) AS rolling_quantity

FROM customer_order

WHERE order_date BETWEEN '2017-03-01' AND '2017-03-31'

ORDER BY customer_order_id;

--Running the above query generates a moving aggregation or moving totals of the quantity that is according to the date range, i.e., from 03-01 to 03-02
--But we see that this is not really rolling up row wise.

SELECT customer_order_id,
customer_id,
order_date,
product_id,
quantity,
SUM(quantity) OVER(ORDER BY order_date rows BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS rolling_quantity

FROM customer_order

WHERE order_date BETWEEN '2017-03-01' AND '2017-03-31'

ORDER BY customer_order_id;

--The above query uses the complete default format of ORDER BY windowing function viz., ORDER BY column_name RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
--where to we need to roll up by rows.

SELECT customer_order_id,
customer_id,
order_date,
product_id,
quantity,
MAX(quantity) OVER(PARTITION BY product_id, customer_id ORDER BY order_date) AS MAX_PRODUCT_QTY_TO_DATE

FROM customer_order

WHERE order_date BETWEEN '2017-03-01' AND '2017-03-31'

ORDER BY customer_order_id;

--As a final segment, we can use windowing functions i.e., started with the OVER() clause, for moving total or moving accumulation.
--One such example is creating moving averages.

SELECT customer_order_id,
customer_id,
order_date,
product_id,
quantity,
AVG(quantity) OVER(ORDER BY order_date ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING) AS ROLLING_AVG

FROM CUSTOMER_ORDER

WHERE order_date BETWEEN '2017-03-01' AND '2017-03-31'

ORDER BY customer_order_id;

--Above example, creates a rolling/moving avg, by taking the quantity by ordering acc. to order_date, and taking the 3 previous rows and 3 following rows from order_date,
--to compute the rolling average. This window by OVER() clause uses the framing clause only for the ORDER BY CLause. Where we can also use RANGE in place of ROWS to query
--within a value/range.

--Above we use the ORDER BY ordering func. and instead of 'RANGE', we use 'ROWS', and after preceding we use 'AND 3 FOLLOWING', from the default 'AND CURRENT ROWS'.

SELECT customer_order_id,
customer_id,
order_date,
product_id,
LAG(product_id, 3, 999) OVER(PARTITION BY customer_id ORDER BY order_date DESC) AS lagged_product_id,
LEAD(product_id, 1) OVER(PARTITION BY customer_id ORDER BY order_date DESC) AS led_prod_id,
LAST_VALUE(product_id) OVER(PARTITION BY customer_id ORDER BY order_date DESC) AS the_last,
FIRST_VALUE(product_id) OVER(PARTITION BY order_date ORDER BY customer_id DESC) AS the_first_acc_to_date
FROM CUSTOMER_ORDER;

--LAG func. works by creating a column derived basically from the customer_id partitioned window, and then lags the product_id columns by 3 rows, w.r.t the product_id.
--Acc. to SQL Pocket guide, 3E
-- LAG(value, lag-value, default value to return when there is no row at that specified offset or for null values)

SELECT
customer_order_id,
customer_id,
product_id,
order_date,
quantity,
MAX(quantity) OVER(PARTITION BY customer_id ORDER BY order_date DESC) max_cust_ord_quantity,
MIN(quantity) OVER(PARTITION BY customer_id ORDER BY order_date DESC) min_cust_ord_quantiy
FROM CUSTOMER_ORDER
WHERE order_date BETWEEN '2017-01-02' AND '2017-03-31'
HAVING max_cust_ord_quantity > 190;

--Practice session above.