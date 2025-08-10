# Case Study 2: Customer Behavior

## Business Problem
The company wants to use data to answer simple questions about their clients, especially about their behavior: how much money they spend in the app, how often they use it, and which menu items are their favorites.

## Entity Relationship Diagram



## Questions Answered
1. What is the total amount of money each client spends in the App?
2. How many days has each customer visited the App?


### Folder Structure
- `solutions/` – Contains `customer_behaviorn_analysis.sql` with all queries and answers


## Question and Solution

###  Q1: What is the total amount of money each client spends in the App?


#### Relevant Table(s)
- orders — columns used: id, client_id, order_status_id, status9datetime (delivery datetime), costall (order total).
- order_status — reference table for status definitions; order_status_id = 9 = delivered.




####  Step 1: Identify delivered orders 
**Step:** Use **WHERE** to filter for a special condition.

```sql
select *
from orders o 
where order_status_id='9'
```
####  Step 2: Count the total delivered orders in 2024 and 2025 (separated)
**Step:** Use **COUNT** to calculate the total orders contributed.

```sql
select count(id)
from orders 
where order_status_id='9'and status9datetime between '2024-01-01' AND '2024-06-30'
```
**Output:**
- 2024: 221 655
- 2025: 204 208

#### Step 3: Count the total money from the delivered orders in 2024 and 2025 (separated)

```sql
select sum(costall)
from orders 
where order_status_id='9'and status9datetime between '2024-01-01' AND '2024-06-30'

```
**Output:**
- 2024: $809 686 142 
- 2025: $879 951 946 


#### Step 4: Group total order_count by customer for both years
**Steps:** 
- Use **count** to calculate the total orders contributed by each customer.  
- Use **group by** to aggregate results by `client_id`. 
- Use **order by** to sort the results. 
- Use **desc** to sort from highest to lowest values.  
- Use **limit** to restrict the number of rows returned.  


```sql
select client_id,
count(id) as order_count
from orders o 
where order_status_id='9'and status9datetime between '2025-01-01' AND '2025-06-30'
group by client_id
order by order_count desc 
limit 5
```

**Output:**
Top 5 2024
| Client ID | order\_count |
| --------: | -----------: |
|    321000 |           69 |
|     73303 |           60 |
|    168090 |           53 |
|     33369 |           52 |
|    266261 |           52 |

Top 5 2025
| Client ID | order\_count |
| --------: | -----------: |
|    170011 |           74 |
|    393105 |           60 |
|    321000 |           60 |
|     17016 |           55 |
|    492383 |           54 |


####  Step 5: Group total cost_sum by customer for both years
Steps:
Use SUM to calculate the total sales contributed by each customer.

```sql
select client_id,
sum(costall) as cost_sum
from orders o 
where order_status_id='9'and status9datetime between '2025-01-01' AND '2025-06-30'
group by client_id
order by cost_sum desc 
limit 5
```

**Output:**
 Top 5 2024
| Client ID | cost\_sum |
| --------: | --------: |
|     25561 | 270,052.0 |
|    427216 | 268,808.0 |
|    436467 | 250,922.0 |
|     85292 | 249,822.0 |
|     19971 | 241,675.0 |

 Top 5 2025
 | Client ID | cost\_sum |
| --------: | --------: |
|    352498 | 464,748.0 |
|    393105 | 335,718.0 |
|    420604 | 303,608.0 |
|    170011 | 295,982.0 |
|     85292 | 291,449.0 |



