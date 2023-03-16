ALTER TABLE staging.user_order_log ADD COLUMN status varchar(15) NOT NULL Default 'shipped';
alter table mart.f_sales add column status varchar(15);

CREATE TABLE mart.f_customer_retention (
	period_name text,
	period_id int4,
	item_id int4,
	new_customers_count int8,
	returning_customers_count int8,
	refunded_customer_count int8,
	new_customers_revenue numeric,
	returning_customers_revenue numeric,
	customers_refunded numeric
);