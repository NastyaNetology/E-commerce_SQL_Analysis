-- Q1: How many active clients placed orders (2024 and 2025 Separately)?
-- For Jan–June 2024 → active_client_2024
SELECT COUNT(DISTINCT client_id) AS active_client_2024 
FROM orders
WHERE status2datetime BETWEEN '2024-01-01' AND '2024-06-30';

-- For Jan–June 2025 → active_client_2025
SELECT COUNT(DISTINCT client_id) AS active_client_2025 
FROM orders
WHERE status2datetime BETWEEN '2025-01-01' AND '2025-06-30';

-- Answer:
-- 2024: 37,209 clients (estimated 60,851 per year)
-- 2025: 26,873 clients


-- Q2: How many total orders were placed (2024 and 2025 Separately)?
-- For Jan–June 2024 → total_orders_2024
SELECT COUNT(DISTINCT id) AS total_orders_2024
FROM orders
WHERE status2datetime BETWEEN '2024-01-01' AND '2024-06-30';

-- For Jan–June 2025 → total_orders_2025
SELECT COUNT(DISTINCT id) AS total_orders_2025
FROM orders
WHERE status2datetime BETWEEN '2025-01-01' AND '2025-06-30';

-- Answer:
-- 2024: 230,389 orders (estimated 462,947 per year)
-- 2025: 212,240 orders


-- Q3: Revenue by Month (2024 and 2025 Separately)
SELECT 
  EXTRACT(YEAR FROM status2datetime) AS year,
  EXTRACT(MONTH FROM status2datetime) AS month,
  SUM(costall) AS total_revenue
FROM orders
WHERE status2datetime BETWEEN '2024-01-01' AND '2025-12-31'
  AND order_status_id = 9
GROUP BY year, month
ORDER BY year, month;

-- Answer: See monthly revenue table in documentation


-- Q4: Sales Quantity (Order Count) by Month (2024 and 2025 Separately)
SELECT
  EXTRACT(YEAR FROM status2datetime) AS year,
  EXTRACT(MONTH FROM status2datetime) AS month,
  COUNT(*) AS total_orders
FROM orders
WHERE status2datetime BETWEEN '2024-01-01' AND '2025-12-31'
  AND order_status_id = 9
GROUP BY year, month
ORDER BY year, month;

-- Answer: See monthly orders table in documentation


-- Q5: Order Frequency by Month (2024 & 2025 Separately)
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

-- Answer:
-- Formula:
--   order_frequency = total_orders / unique_clients
--   NULLIF ensures no division by zero
-- Example:
--   2024: 452,823 orders / 60,251 clients ≈ 7.52
--   2025: 202,840 orders / 26,100 clients ≈ 7.77


-- Q6: Top 5 Dishes by Order Count per Year (2024 and 2025 Separately)
-- Replace this with your actual logic (this is a placeholder)
SELECT dish_name, COUNT(*) AS order_count
FROM menu
WHERE delivery_from BETWEEN '2024-01-01' AND '2025-12-31'
GROUP BY dish_name
ORDER BY order_count DESC
LIMIT 5;

-- Note: You may need to join with order details table if available