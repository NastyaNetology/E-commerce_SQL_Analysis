-- SQL for customer behavior analysis 
-- Case Study 3: Customer Behavior Analysis



--  Q1: What is the total amount of money each client spends in the App?



--  Step 1: Identify delivered orders 

select *
from orders o 
where order_status_id='9'

-- Step 2: Count the total delivered orders in 2024 and 2025 (separated)

select count(id)
from orders 
where order_status_id='9'and status9datetime between '2024-01-01' AND '2024-06-30'

-- Step 3: Count the total money from the delivered orders in 2024 and 2025 (separated)

select sum(costall)
from orders 
where order_status_id='9'and status9datetime between '2024-01-01' AND '2024-06-30'


-- Step 4: Group total order_count by customer for both years

select client_id,
count(id) as order_count
from orders o 
where order_status_id='9'and status9datetime between '2025-01-01' AND '2025-06-30'
group by client_id
order by order_count desc 
limit 5


-- Step 5: Group total cost_sum by customer for both years

select client_id,
sum(costall) as cost_sum
from orders o 
where order_status_id='9'and status9datetime between '2025-01-01' AND '2025-06-30'
group by client_id
order by cost_sum desc 
limit 5

