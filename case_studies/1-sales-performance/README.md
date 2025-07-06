# Case Study 1: Sales Performance

## Business Problem
Evaluate the sales performance across 2024 and 2025, focusing on order volume, revenue trends, client activity, and top-performing products.

## Questions Answered
1. How many active clients placed orders (2024 and 2025 separately)?
2. How many total orders were placed (2024 and 2025 separately)?
3. Revenue by month (2024 and 2025)
4. Order count by month (2024 and 2025)
5. Order frequency (orders per client) by month
6. Top 5 dishes by order count per year

## Folder Structure
- `data/` – CSV files or raw data (if needed)
- `solutions/` – Contains `sales_performance_analysis.sql` with all queries and answers


## Question and Solution

## Q1: How many active clients placed orders (2024 and 2025 Separately)?
For Jan–June 2024 → active_client_2024 For Jan–June 2025 → active_client_2025

```sql
SELECT COUNT(DISTINCT client_id) AS active_client_2024 
FROM orders
WHERE status2datetime BETWEEN '2024-01-01' AND '2024-06-30'
```

Answer: 2024: 37 209 clients (60,851 clients/year) 2025: 26 873 clients

## Q2: How many total orders were placed (2024 and 2025 Separately)?
For Jan–June 2024 → total_orders_2024 
For Jan–June 2025 → total_orders_2025

```sql
SELECT COUNT(DISTINCT id) AS total_orders_2024
FROM orders
WHERE status2datetime BETWEEN '2024-01-01' AND '2024-06-30'

```
Answer: 2024: 230 389 orders (462,947 orders/year) 2025: 212 240 orders

## Q3: Revenue by Month (2024 and 2025 Separately)

```sql
SELECT 
extract (year from status2datetime) as year,
extract (month from status2datetime)as month,
sum(costall) as total_revenue
from orders
where status2datetime BETWEEN '2024-01-01' AND '2025-12-31'
and order_status_id = 9
group by year, month
order by year, month
```

Answer: Monthly Revenue (2024)

Monthly Revenue (2024)

| Year | Month | Total Revenue (₽) |
|------|-------|--------------------|
| 2024 |   1   | 143,827,987        |
| 2024 |   2   | 147,875,926        |
| 2024 |   3   | 149,532,384        |
| 2024 |   4   | 129,048,648        |
| 2024 |   5   | 140,265,836        |
| 2024 |   6   | 115,049,379        |
| 2024 |   7   | 107,891,025        |
| 2024 |   8   | 123,053,670        |
| 2024 |   9   | 136,978,429        |
| 2024 |  10   | 158,335,005        |
| 2024 |  11   | 183,259,954        |
| 2024 |  12   | 183,865,374        |

Monthly Revenue (2025)

| Year | Month | Total Revenue (₽) |
|------|-------|--------------------|
| 2025 |   1   | 167,161,399        |
| 2025 |   2   | 151,711,144        |
| 2025 |   3   | 158,722,386        |
| 2025 |   4   | 144,861,520        |
| 2025 |   5   | 145,281,077        |
| 2025 |   6   | 106,202,854        |

## Q4: Sales Quantity (Order Count) by Month (2024 and 2025 Separately)

```sql
SELECT
  EXTRACT(YEAR FROM status2datetime) AS year,
  EXTRACT(MONTH FROM status2datetime) AS month,
  COUNT(*) AS total_orders
FROM orders
WHERE status2datetime BETWEEN '2024-01-01' AND '2025-12-31'
  AND order_status_id = 9
GROUP BY year, month
ORDER BY year, month;
```

Answer:

Monthly Orders (2024)
Year	Month	Total Orders
2024	1	39,307
2024	2	40,177
2024	3	40,593
2024	4	35,847
2024	5	38,656
2024	6	31,508
2024	7	29,492
2024	8	32,523
2024	9	35,995
2024	10	40,606
2024	11	47,755
2024	12	40,364
Monthly Orders (2025)
Year	Month	Total Orders
2025	1	39,365
2025	2	35,419
2025	3	36,844
2025	4	33,382
2025	5	33,406
2025	6	24,424

## Q5: Order Frequency by Month (2024 & 2025 Separately)

```sql
SELECT
  EXTRACT(YEAR FROM status2datetime) AS year,
  EXTRACT(MONTH FROM status2datetime) AS month,
  COUNT(*) AS total_orders,
  COUNT(DISTINCT client_id) AS unique_clients,
  ROUND(COUNT(*)::numeric / NULLIF(COUNT(DISTINCT client_id), 0), 2) AS order_frequency
FROM orders
WHERE status2datetime BETWEEN '2024-01-01' AND '2025-12-31'
  AND order_status_id = 9
GROUP BY year, month
ORDER BY year, month;
```

Steps:
COUNT(*) = total orders
COUNT(DISTINCT client_id) = number of unique clients
order_frequency = average number of orders per client in that month
NULLIF(..., 0) protects against division by zero
Answer:

Year	Total Orders	Unique Clients	Order Frequency
2024	452,823	60,251	7.52
2025	202,840	26,100	7.77

## 🍽️ MENU Analysis
Q6: Top 5 Dishes by Order Count per Year (2024 and 2025 Separately)
SELECT *
FROM menu
WHERE delivery_from BETWEEN '2024-01-01' AND '2025-12-31'
   
