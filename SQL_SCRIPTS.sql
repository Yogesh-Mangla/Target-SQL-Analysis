#Exploratory analysis steps like checking the structure & characteristics of the dataset:
#Data type of all columns in the "customers" table.


select 
  column_name,
      data_type
 from dsmljunior.Target_SQL.INFORMATION_SCHEMA.COLUMNS
 limit 5

# Get the time range between which the orders were placed using min and max function.
select 
CONCAT (min(order_purchase_timestamp),   " TO "    ,
max(order_purchase_timestamp)) 
from `Target_SQL.orders`

# Count the Cities & States of customers who ordered during the given period.

SELECT 
 count(DISTINCT c.customer_city) as Count_cities,
 count(DISTINCT c.customer_state) as count_state
FROM `Target_SQL.customers ` as c JOIN `Target_SQL.orders` AS o
on c.customer_id = o.customer_id 

## In-depth Exploration:
## Is there a growing trend in the no. of orders placed over the past years?

SELECT 
 Extract (Year from order_purchase_timestamp)
 AS PERIOD,
COUNT(ORDER_ID) AS NO_OF_ORDERS FROM `Target_SQL.orders`
group by PERIOD
order by period asc

##  Monthly seasonality in terms of the no. of orders being placed

SELECT
    EXTRACT(YEAR FROM order_purchase_timestamp) as order_year,
    EXTRACT(MONTH FROM order_purchase_timestamp) as order_month,
    COUNT(order_id) AS total_orders
FROM
    `Target_SQL.orders` 
GROUP BY order_year, order_month
ORDER BY order_year, order_month


## During what time of the day, do the Brazilian customers mostly place their orders? (Dawn, Morning, Afternoon or Night)
#0-6 hrs : Dawn
#7-12 hrs : Mornings
#13-18 hrs : Afternoon
#19-23 hrs : Night


SELECT
    CASE
        WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 0 AND 6 THEN 'Dawn'
        WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 7 AND 12 THEN 'Mornings'
        WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 13 AND 18 THEN 'Afternoon'
        ELSE 'Night'
    END AS Time_of_Day,
    COUNT(order_id) AS Orders_Placed
FROM
    `Target_SQL.orders`
GROUP BY
    Time_of_Day
ORDER BY
    Orders_Placed DESC;

## Evolution of E-commerce orders in the Brazil region: 
## Get the month on month no. of orders placed in each state.

with cte1 as 
(
  Select 
c.customer_state,
format_timestamp("%Y-%m",o.order_purchase_timestamp) as yr_month,
count(*) as number_of_orders
from `Target_SQL.customers ` c  
join `Target_SQL.orders` o
using (customer_id)
where o.order_status not in ("Completed","Cancelled")
group by c.customer_state,yr_month
order by c.customer_state,yr_month
)   select * from cte1

## customers distributions across all the states

Select  
customer_state as state,
count(customer_unique_id) as number_of_customers
from `Target_SQL.customers `
group by customer_state
order by number_of_customers desc

#3Impact on Economy: Analyze the money movement by e-commerce by looking at order prices, freight and others.

##Get the % increase in the cost of orders from year 2017 to 2018 (include months between Jan to Aug only). 

#use the “payment_value” column in the payments table to get the cost of orders.


with cte1 as 
( Select 
  extract (year from o.order_purchase_timestamp) as year,
  extract (month from o.order_purchase_timestamp) as month,
  Sum(payment_value) as amount
   from `Target_SQL.payments` as  p join `Target_SQL.orders`
 as o  using (order_id) 
 group by o.order_purchase_timestamp
 order by year
), cte2 as
(
select 
round(sum(case when year = 2017 then amount else 0 end),2) as cost_2017,
round(sum(case when year = 2018 then amount else 0 end),2) as cost_2018
 from cte1
 where month < 9 and year > 2016
)
select 
*,round((cost_2018-cost_2017)/cost_2017*100,2) as percentage_increase_yoy
from cte2

## Calculate the Total & Average value of order price for each state.

Select 
c.customer_state as state,
round(sum(oi.price),2) as total_order_price,
round(sum(oi.price)/count(distinct order_id),2) as avg_order_price
from `Target_SQL.customers ` c join `Target_SQL.orders` o using (customer_id)
join `Target_SQL.order_items` oi using(order_id)
group by state  

5. Analysis Based on sales, freight and delivery time

A)	Find the no. of days taken to deliver each order from the order’s purchase date as delivery time.
Also, calculate the difference (in days) between the estimated & actual delivery date of an order.
Do this in a single query.

You can calculate the delivery time and the difference between the estimated & actual delivery date using the given formula:
time_to_deliver = order_delivered_customer_date - order_purchase_timestamp
diff_estimated_delivery = order_estimated_delivery_date - order_delivered_customer_date
*/

Select 
order_id,
date_diff(order_delivered_customer_date,order_purchase_timestamp,day) as time_to_deliver,
date_diff(order_estimated_delivery_date,order_delivered_customer_date,day)diff_estimated_delivery
from 
`Target_SQL.orders`
5. Analysis Based on sales, freight and delivery time

## Find the no. of days taken to deliver each order from the order’s purchase date as delivery time.
Also, calculate the difference (in days) between the estimated & actual delivery date of an order.
Do this in a single query.

## You can calculate the delivery time and the difference between the estimated & actual delivery date using the given formula:
time_to_deliver = order_delivered_customer_date - order_purchase_timestamp
diff_estimated_delivery = order_estimated_delivery_date - order_delivered_customer_date
*/

Select 
order_id,
date_diff(order_delivered_customer_date,order_purchase_timestamp,day) as time_to_deliver,
date_diff(order_estimated_delivery_date,order_delivered_customer_date,day)diff_estimated_delivery
from 
`Target_SQL.orders`

## Find out the top 5 states with the highest & lowest average freight value.*/

Select 
c.customer_state as state,
'Highest' as val,
round(avg(oi.freight_value),2) as avg_order_freight
from `Target_SQL.customers ` c join `Target_SQL.orders` o using (customer_id)
join `Target_SQL.order_items` oi using(order_id)
group by state  
order by avg_order_freight desc
limit 5  
)
UNION ALL
(
  Select 
c.customer_state as state,
'Lowest' as value,
round(avg(oi.freight_value),2) as avg_order_freight
from `Target_SQL.customers ` c join `Target_SQL.orders` o using (customer_id)
join `Target_SQL.order_items` oi using(order_id)
group by state 
order by avg_order_freight asc 
limit 5 
)

## *Find out the top 5 states with the highest & lowest average delivery time.

(
Select 
c.customer_state as state,
'Highest' as val,
round(avg(date_diff(order_estimated_delivery_date,order_delivered_customer_date,day)),0) as avg_delivery,
from `Target_SQL.customers ` c join `Target_SQL.orders` o using (customer_id)
join `Target_SQL.order_items` oi using(order_id)
group by state  
order by avg_delivery desc
limit 5  
)
UNION ALL
(
  Select 
c.customer_state as state,
'Lowest' as value,
round(avg(date_diff(order_estimated_delivery_date,order_delivered_customer_date,day)),0) as avg_delivery,
from `Target_SQL.customers ` c join `Target_SQL.orders` o using (customer_id)
join `Target_SQL.order_items` oi using(order_id)
group by state 
order by avg_delivery asc 
limit 5 
)

## *Find out the top 5 states where the order delivery is really fast as compared to the estimated date of delivery.
You can use the difference between the averages of actual & estimated delivery date to figure out how fast the delivery was for each state.
*/
with cte as
(
Select 
c.customer_state,
round(avg(date_diff(o.order_estimated_delivery_date,o.order_delivered_customer_date,day)),0) as fast_metric
from `Target_SQL.customers ` c join `Target_SQL.orders` o using(customer_id)
join `Target_SQL.order_items` oi using (order_id)
group by customer_state
)
select cte.customer_state,
cte.fast_metric as avg_delivery_time
from
cte
order by cte.fast_metric asc
limit 5


## Analysis based on payments
## Find the month on month no. of orders placed using different payment type

select 
format_timestamp('%Y-%m', o.order_purchase_timestamp)as month,
p.payment_type,
count(o.order_id) as number_of_orders
from `Target_SQL.payments` as p join `Target_SQL.orders` as o using  (order_id) 
where payment_type is not null and order_status not in ('canceled','unavailable')
group by month,payment_type
order by month,payment_type

 

## Find the no. of orders placed on the basis of the payment installments that have been paid.

Select
payment_installments,
Count(order_id) as no_of_orders
from `Target_SQL.payments`
where payment_installments >=1 
group by payment_installments
 



 
