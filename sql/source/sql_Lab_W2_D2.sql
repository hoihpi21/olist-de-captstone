

select * from order_items oi 

select * from customers

select * from orders

select * from order_reviews t 

select * from products p 

select * from category_translation ct 

select * from sellers

select * from order_payments op 


-- 1. Revenue (SUM of price) by customer_state for delivered orders. Top 10 states.
select o.order_status, c.customer_state, SUM(oi.price) as revenue from orders o
inner join order_items oi on oi.order_id = o.order_id
inner join customers c on c.customer_id = o.customer_id 
where o.order_status = 'delivered'
group by c.customer_state, o.order_status
order by revenue 
limit 10


-- 2. How many orders have no review at all? (anti-join)
select count(*) from orders o 
left join order_reviews orv on orv.order_id = o.order_id 
where orv.review_comment_message is null


-- 3. Top 10 product categories in English by items sold. Why LEFT JOIN to the translation?
select ct.product_category_name_english, count(ct.product_category_name) as ItemSolds from category_translation ct
inner join products p on p.product_category_name = ct.product_category_name
group by ct.product_category_name_english 
order by itemsolds, ct.product_category_name_english  
limit 10


-- 4. What share of order items were sold by a seller in the same state as the customer?
select s.seller_state, count(oi.order_id) as SoldCount from order_items oi 
inner join sellers s on s.seller_id = oi.seller_id 
inner join orders o on o.order_id = oi.order_id 
inner join customers c on c.customer_id = o.customer_id 
where s.seller_state = c.customer_state 
group by s.seller_state 
order by SoldCount, s.seller_state desc


 -- 5. For 5 orders, show item revenue and payment total side by side — without fan-out.
select i.order_id, i.item_revenue, p.payment_total from (
	select order_id, SUM(price) as item_revenue from order_items 
	group by order_id) i
inner join (
	select order_id, SUM(payment_value) as payment_total from order_payments
	group by order_id) p
on i.order_id = p.order_id 
order by i.item_revenue 
limit 5
	
	
-- 6. Find orders where payments differ from price + freight by more than 1.00.
select i.order_id, i.total_price, j.total_payment, (j.total_payment -i.total_price) as diff from (
	select order_id, SUM(price + freight_value) as total_price from order_items
	group by order_id) i
inner join (
	select order_id, SUM(payment_value) as total_payment from order_payments  
	group by order_id) j
on i.order_id = j.order_id 
where (j.total_payment - i.total_price) > 1.0
order by diff desc; 
