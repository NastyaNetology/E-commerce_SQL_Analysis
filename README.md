# Case Study: Food Delivery Platform – SQL Analysis

This case study analyzes real data from a food delivery platform (2022–2025).


---

## Table of Contents

- [Business Objective](#business-objective)  
- [Question and Solution](#question-and-solution)  

---

## Business Objective

This project analyzes real transactional data from an online retail platform to enhance decision-making across key business areas:

- **Customer behavior patterns**  
- **Product popularity and delivery performance**  
- **Customer retention and churn analysis**  


## Question and Solution

### Q1: How many active clients placed orders in 2024?
Timeframe: 2024-01-01 to 2024-12-31

```sql
SELECT COUNT(DISTINCT client_id) AS active_client_2024
FROM orders
WHERE status2datetime BETWEEN '2024-01-01' AND '2024-12-31';

```

Answer: 60,851 clients

### Q2: How many total orders were placed in 2024?  
Timeframe: 2024-01-01 to 2024-12-31

```sql
SELECT COUNT(DISTINCT id) AS total_orders_2024
FROM orders
WHERE status2datetime BETWEEN '2024-01-01' AND '2024-12-31';

```

Answer: 462,947 orders
