--Week4,Day1
--String Handling

select customer_city 
,initcap(customer_city ) as init_cap
,UPPER(c.customer_city ) as Upper
,LOWER(c.customer_city ) as Lower
,length(c.customer_city ) as Len --count space
,left(c.customer_city ,3) as left
,right(c.customer_city ,3) as right
,split_part(c.customer_city ,' ',1)
,replace(c.customer_city ,' ','/')
from customers c limit 10

-- Pad, slice, locate
SELECT LPAD('1001', 6, 'tt')             AS zip,  -- 01001 --fill string
       SUBSTRING('health_beauty', 1, 6) AS part, -- health --string cut
       STRPOS('bed_bath', '_')          AS pos,  -- 4      --search position --can show only first place
       RIGHT('abc123', 3)               AS tail; -- 123
       
       
--REGEXP_REPLACE (source, pattern, replacement, flags)
select regexp_replace('(11) 9876-5432', '[^0-9]',' ','g')

SELECT customer_zip_code_prefix
FROM raw.customers
WHERE customer_zip_code_prefix !~ '^[0-9]{2}$';

--CONCAT_WS Join with a separator, skipping NULLs
--CONCAT_WS(separator, string1,string2)
--CONCAT(string1,separator,string2,separator,string3)

select c.customer_city, c.customer_state ,customer_zip_code_prefix
,concat_ws('_', c.customer_city ,NULL,c.customer_state,c.customer_zip_code_prefix )
,concat( c.customer_city ,'_',NULL,c.customer_state,c.customer_zip_code_prefix  )
,c.customer_state || '/' || c.customer_zip_code_prefix as ConcatWithSeparator
from customers c 

SELECT CONCAT_WS(', ', '123 Main St', NULL, 'Austin', 'TX', 78701) AS FullAddress;
SELECT CONCAT_WS( ', ', NULL, 'TX') AS FullAddress;
SELECT CONCAT( NULL,', ', 'TX') AS FullAddress;
SELECT CONCAT('John', NULL, 'Doe'); 

--String Add
-- Many rows -> one string
SELECT order_id,
       STRING_AGG(product_id, ', ' ORDER BY order_item_id)
FROM raw.order_items GROUP BY order_id;

--368c6c730842d78016ad823897a372db, 368c6c730842d78016ad823897a372db
select * from order_items oi where oi.order_id ='0008288aa423d2a3f00fcb17cd7d8719'

-- One string -> many rows text → array, array → many rows
SELECT UNNEST(STRING_TO_ARRAY('a,b,c', ','));
