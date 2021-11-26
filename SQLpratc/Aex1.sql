--ADV. SQL, covering REGEX, Volatile/temp tables, CTEs in Volatile table.

SELECT 'LA' REGEXP 'LA';
SELECT '$420.25' REGEXP '\$420\.25'; --Where backslashes are used as escapers.
SELECT '$420.25' REGEXP '\$[0-4]*\.[2-5]+';

--N.B An Anchoring nuance.
SELECT 'NYC' REGEXP '[A-Z]{2}'; --This will return true. Has regular expression do partial matches, we can use Anchor tags.
SELECT 'NYC' REGEXP '^[A-Z]{2}$'; -- Using anchor tags, we can create a expression that creates a full match query.
--Note. A full match query must have a start anchor tag and a end anchor tag.
--Using Anchor tags is a best practice when using regular expressions.
 
SELECT * FROM CUSTOMER
WHERE ADDRESS REGEXP '^[0-9]{3,4} .*$'; --From the Thunderbird_manufacturing database.

--Creating a Volatile or a Temporary table

CREATE TEMP TABLE DISCOUNT (
    CUSTOMER_ID_REGEX VARCHAR (20) NOT NULL DEFAULT ('.*'),
    PRODUCT_ID_REGEX VARCHAR (20) NOT NULL DEFAULT ('.*'),
    PRODUCT_GROUP_REGEX VARCHAR (30) NOT NULL DEFAULT ('.*'),
    STATE_REGEX VARCHAR (30) NOT NULL DEFAULT ('.*'),
    DISCOUNT_RATE DOUBLE NOT NULL
);

--Selecting all fields in the temp table Discount.

SELECT * FROM DISCOUNT;

--Inserting values into the Discount table.

INSERT INTO DISCOUNT (STATE_REGEX, DISCOUNT_RATE) VALUES ('LA|OK', 0.20);
INSERT INTO DISCOUNT (PRODUCT_GROUP_REGEX, STATE_REGEX, DISCOUNT_RATE) VALUES ('BETA|GAMMA', 'TX', 0.10);
INSERT INTO DISCOUNT (PRODUCT_ID_REGEX, CUSTOMER_ID_REGEX, DISCOUNT_RATE) VALUES ('^[379]$', '^(1|6|12)$', 0.30);

--Querying and using the temp table.

--Here we use the temp table and apply discounts to orders, based on particular multiple conditions from the Discount table.

SELECT CUSTOMER_ORDER.*,
product_group,
state,
price,
discount_rate,
--SUM(discount_rate) AS Total_discounted_rate,
price * (1 - discount_rate) AS discounted_price

FROM CUSTOMER_ORDER

INNER JOIN CUSTOMER
ON CUSTOMER_ORDER.customer_id = CUSTOMER.customer_id

INNER JOIN PRODUCT
ON CUSTOMER_ORDER.product_id = PRODUCT.product_id

LEFT JOIN DISCOUNT
ON CUSTOMER_ORDER.customer_id REGEXP DISCOUNT.customer_id_regex --'^(1|6|12)$'
AND CUSTOMER_ORDER.product_id REGEXP DISCOUNT.product_id_regex --'^[379]$'
AND PRODUCT.product_group REGEXP DISCOUNT.product_group_regex --'BETA|GAMMA'
AND CUSTOMER.state REGEXP DISCOUNT.state_regex --'LA|OK|TX' 

WHERE order_date BETWEEN '2017-03-26' AND '2017-03-31'

ORDER BY discount_rate;

--Using a SELECT query to save data in a temp/Volatile table.

CREATE TEMP TABLE TOTAL_ORDERS_BY_DATE AS
WITH TOTAL_ORDERS AS (
    SELECT order_date,
    SUM(quantity) AS total_quantity
    FROM CUSTOMER_ORDER
    GROUP BY 1
)
SELECT * FROM TOTAL_ORDERS_BY_DATE

--Above we use CTEs and SELECT query to create a data store for a temp table.

