insert into mart.f_customer_retention (
	period_name,period_id,item_id,new_customers_count,returning_customers_count,
	refunded_customer_count,new_customers_revenue,returning_customers_revenue,customers_refunded
)
with 
	customers as 
		(select *
		 from mart.f_sales join mart.d_calendar 
		 on f_sales.date_id = d_calendar.date_id 
		 where week_of_year = DATE_PART('week', '{{ds}}}'::DATE)), 
	new_customers as 
		(select customer_id, sum(quantity*payment_amount) as new_customers_revenue
		 from customers where status = 'shipped' 
		 group by customer_id having count(*) = 1), 
	returning_customers as 
		(select customer_id, sum(quantity*payment_amount) as returning_customers_revenue
		 from customers where status = 'shipped' 
		 group by customer_id having count(*) > 1), 
	refunded_customers as 
		(select customer_id, count(1) as customers_refunded
		 from customers where status = 'refunded' 
		 group by customer_id)		 
select 'weekly' as period_name,
		c.week_of_year as period_id,
		c.item_id as item_id,
		count(nc.customer_id) as new_customers_count,
		count(rc.customer_id) as returning_customers_count,
		count(rfc.customer_id) as refunded_customer_count,
		sum(new_customers_revenue) as new_customers_revenue,
		sum(returning_customers_revenue) as returning_customers_revenue,
		sum(customers_refunded) as customers_refunded
from customers c left join new_customers nc on c.customer_id = nc.customer_id
	 left join returning_customers rc on c.customer_id = rc.customer_id 
	 left join refunded_customers rfc on c.customer_id = rfc.customer_id
group by period_id, item_id;