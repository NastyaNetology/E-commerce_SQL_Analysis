# Case Study 2: Customer Behavior

## Business Problem
The company wants to use data to answer simple questions about their clients, especially about their behavior: how much money they spend in the app, how often they use it, and which menu items are their favorites.

## Entity Relationship Diagram



## Questions Answered
1. What is the total amount of money each client spends in the App?
2. 
3. 

## Folder Structure
- `solutions/` – Contains `customer_behaviorn_analysis.sql` with all queries and answers


## Question and Solution

## Q1: What is the total amount of money each client spends in the App?


Relevant Table(s)
orders — contains order_status_id, client_id, cost, and delivery date and time (status9datetime)
order_status — contains order status definitioan (from this table I know that order_status_id = '9' means delivered stutus. 


Step 1: Identify delivered orders 

```sql
select *
from orders o 
where order_status_id='9'

```
Step 2: Coun the total delivered orders in 2024 and 2025 (seperated)

```sql


```

Step 3: Coun the total money from the the delivered orders in 2024 and 2025 (seperated)

```sql


```

Step 3: Group by the tatal amount money by custemers in 2024 and 2025 (seperated)


```sql


```
