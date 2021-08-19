--Transactions and Index

BEGIN TRANSACTION;

INSERT INTO PRODUCT(PRODUCT_ID, DESCRIPTION, PRICE) VALUES(11, Krypton, 3.141);
INSERT INTO PRODUCT(PRODUCT_ID, PRICE) VALUES(12, 5.42);

SELECT * FROM PRODUCT

ROLLBACK; --If to undo the transaction.

END TRANSACTION; --To complete the transaction.

--creating an index

CREATE INDEX prod_ind ON product(price); --Used only when there are ten of thousands records or more. This is used to optimize SELECT queries,
-- but indexes/indices, are known to slow down write operations.
--INDEX acts similar to a text book index.

DROP INDEX prod_ind; --To remove an index

CREATE UNIQUE INDEX prod_id ON product(product_id); --This creates a unique index, when we need the index to be pointing to a column, only with unique values.