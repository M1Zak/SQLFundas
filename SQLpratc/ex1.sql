--SQL is case INSENSITIVE
select
price, 
round(price * 1.08, 2) as with_vat
from product
