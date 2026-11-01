




select * from customers 

select * from order_payments 

select * from order_reviews t 

select * from sellers

select * from order_items oi 

-- 1. Find the top 5 states by customer count. --
select customer_state, count(*) from customers 
group by customer_state 
order by customer_state 
limit 5;


-- 2. Count unique customers using customer_unique_id --
select count(distinct customer_unique_id) from customers 


-- 3. Find the most-used payment type and its total payment value. --
select payment_type, count(*) as most_used_payment, sum(payment_value) from order_payments op
group by op.payment_type 


-- 4. Count reviews for each score (1-5) and find the average score. --
select review_score, count(*) as review_count,
avg(review_score) from order_reviews t 
group by review_score 


-- 5. Find seller states with more than 50 sellers. --
select seller_state, count(*) from sellers s
group by seller_state 
having count(seller_state) > 50
order by s.seller_state 


-- 6. Calculate the average price and freight per item, rounded to 2 decimals. --
select round(avg(price), 2), round(avg(freight_value), 2) from order_items
group by price, freight_value
