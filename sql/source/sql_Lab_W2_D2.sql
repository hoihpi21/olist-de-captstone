--Q1:Revenue (SUM of price) by customer_state for delivered orders. Top 10 states.
select c.customer_state, SUM(oi.price)as revenue from orders o
inner join customers c on c.customer_id=o.customer_id
inner join order_items oi on oi.order_id = o.order_id
where order_status = 'delivered'
group by c.customer_state
order by revenue desc 
limit 10

--Q2:How many orders have no review at all? (anti-join)
select count(*) as No_Review from orders o
left join order_reviews ov on ov.order_id = o.order_id
where ov.order_id is null

--Q3:Top 10 product categories in English by items sold. Why LEFT JOIN to the translation?
select ct.product_category_name_english ,count(ct.product_category_name)as SoldProuctCategoryCount from order_items oi
inner join products p on p.product_id = oi.product_id
inner join category_translation ct on ct.product_category_name = p.product_category_name 
group by ct.product_category_name
order by SoldProuctCategoryCount desc
limit 10

--Q4: What share of order items were sold by a seller in the same state as the customer?
select s.seller_state,count(oi.order_id)as OrderCount from order_items oi
inner join sellers s on s.seller_id = oi.seller_id 
inner join orders o on o.order_id = oi.order_id
inner join customers c on c.customer_id = o.customer_id
where s.seller_state = c.customer_state
group by s.seller_state 
order by ordercount desc

--Q5: For 5 orders, show item revenue and payment total side by side — without fan-out.
select 
    i.order_id,
    i.item_revenue,
    p.payment_total
from (
    select 
        order_id, 
        SUM(price) AS item_revenue
    from raw.order_items
    group by order_id
) i
inner join (
    select 
        order_id, 
        SUM(payment_value) AS payment_total
    from raw.order_payments
    group by order_id
) p on i.order_id = p.order_id
order by i.item_revenue desc
limit 5;

--Q6: Find orders where payments differ from price + freight by more than 1.00.
select 
    i.order_id,
    i.total_Price,
    p.total_payment,
    (p.total_payment - i.total_Price) AS diff
from (
    select 
        order_id, 
        SUM(price + freight_value) AS total_Price
    from raw.order_items
    group by order_id
) i
inner join (
    select 
        order_id, 
        SUM(payment_value) AS total_payment
    from raw.order_payments
    group by order_id
) p on i.order_id = p.order_id
where (p.total_payment - i.total_Price) > 1.00
order by diff desc;