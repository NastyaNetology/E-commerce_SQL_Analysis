# Case Study 2: Client Satisfaction

## Business Problem


## Questions Answered
1. Which dishes receive the lowest and highest ratings?

## Folder Structure
- `data/` – CSV files or raw data (if needed)
- `solutions/` – Contains `client_satisfaction_analysis.sql` with all queries and answers


## Question and Solution

## Q1: Which dishes receive the lowest and highest ratings?

Relevant Table(s)
order_dish_rates

Step 1: Inspect the Columns

```sql
SELECT * 
FROM order_dish_rates
LIMIT 1;
```

Based on the structure of the table the relevant fields are:
- id
- rate
- comment
- dish_id
- order_id
- client_id
- platform_id
- created_at
- updated_at




