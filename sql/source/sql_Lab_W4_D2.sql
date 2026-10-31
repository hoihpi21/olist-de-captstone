--Q1:For each seller state, find the 3 sellers who earned the most revenue.
with seller_revenue as (
	 select s.seller_state,
			s.seller_id ,
			SUM(oi.price +oi.freight_value ) as revenue
	from raw.order_items oi 
	join raw.sellers s on s.seller_id = oi.seller_id 
	group by 1,2
),
ranked as (
	select *,rank() over (partition by seller_state 
						  order by revenue desc) as rnk
	from seller_revenue
)
select seller_state ,seller_id ,round(revenue,2) as revenue,rnk
from ranked 
where rnk <= 3
order by seller_state,rnk 

--Q2:For every customer, show the date of their first order and how many orders they placed in total.
select * from (
	select c.customer_unique_id ,min(o.order_purchase_timestamp) as first_orderdate
		   ,count(order_id) over (partition by c.customer_unique_id) as order_count
		   ,rank() over (partition by c.customer_unique_id order by o.order_purchase_timestamp asc) as orderdate_rnk
	from raw.orders o 
	join raw.customers c on c.customer_id  = o.customer_id 
	group by c.customer_unique_id ,o.order_id
)A where A.orderdate_rnk = 1

--Q3:For each seller, show how their revenue adds up over time, order by order.
with sellerRevenue_Running as (
	 select s.seller_id ,o.order_id ,
	 o.order_purchase_timestamp,
	 		SUM(oi.price + oi.freight_value) as revenue
	 from raw.orders o
	 join raw.order_items oi on oi.order_id = o.order_id 
	 join raw.sellers s on s.seller_id = oi.seller_id 
	 --where s.seller_id ='0015a82c2db000af6aaaf3ae2ecb0532'
	 group by 1,2,3
),
rev_rnk as (
	select * ,SUM(revenue) over (partition by seller_id order by order_purchase_timestamp 
								 rows between unbounded preceding and current row) as revenue_running 
	from sellerRevenue_Running
	order by order_purchase_timestamp 
)
select * 
from rev_rnk
order by seller_id ,order_purchase_timestamp 

--Q4:What percentage of all money paid came from each payment type?
with paid_percentage as (
	select op.payment_type,
		   sum(op.payment_value) as total_paid
	from raw.order_payments op
	group by op.payment_type
),
total as (
	select payment_type,
		   total_paid ,
		   SUM(total_paid) over () as grand_total
	from paid_percentage
)
select
payment_type,
total_paid,
Round(((total_paid/grand_total )*100),1) as ptg
from total 
order by total_paid desc

--Q5:Find the order items whose price is higher than the average price in their product category.
with orderprice as (
	select oi.order_id ,
		   oi.product_id,
		   p.product_category_name,
		   oi.price
	from raw.order_items oi 
	join raw.products p on p.product_id = oi.product_id 
),
avg_price as (
	select order_id, product_id,product_category_name,price,
		   round (avg (price) over (partition by product_category_name),2) as avg_price
	from orderprice
)
select * 
from avg_price
where price > avg_price 
order by product_category_name ,price
