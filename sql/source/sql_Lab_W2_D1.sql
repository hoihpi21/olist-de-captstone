--Q1: Find the top 5 states by customer count.
select customer_state ,count(*) as customers from customers
group by customer_state
order by customers desc
limit 5

--Q2: Count unique customers using customer_unique_id.
select count(distinct customer_unique_id) from customers

--Q3: Find the most-used payment type and its total payment value.
select payment_type,count(*) as payment,sum(payment_value ) from order_payments
group by payment_type

--Q4: Count reviews for each score (1-5) and find the average score.
select review_score,count(*) as review_count,
(select avg(review_score) from order_reviews)
from order_reviews
group by review_score

--Q5: Find seller states with more than 50 sellers
select seller_state,count(*) as seller_count from sellers
group by seller_state
having count(seller_state) > 50
order by seller_count desc

--Q6: Calculate the average price and freight per item, rounded to 2 decimals.
select ROUND(AVG(price),2) as avg_price,ROUND(AVG(freight_value),2) avg_freignt,order_item_id 
from order_items
group by order_item_id 

