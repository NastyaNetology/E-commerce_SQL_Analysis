-- SQL for client satisfaction analysis 
-- Case Study 2: Client Satisfaction Analysis

-- Q1: Top 5 Highest Rated Dishes (2024)
SELECT
  m.name AS dish_name,
  r.dish_id,
  ROUND(AVG(r.rate)::numeric, 2) AS avg_rating,
  COUNT(*) AS rating_count
FROM order_dish_rates r
JOIN menu m ON r.dish_id = m.dish_id
WHERE r.rate > 0
  AND r.created_at BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY m.name, r.dish_id
HAVING COUNT(*) >= 5
ORDER BY avg_rating DESC
LIMIT 5;

-- Q1: Top 5 Highest Rated Dishes (2025)
SELECT
  m.name AS dish_name,
  r.dish_id,
  ROUND(AVG(r.rate)::numeric, 2) AS avg_rating,
  COUNT(*) AS rating_count
FROM order_dish_rates r
JOIN menu m ON r.dish_id = m.dish_id
WHERE r.rate > 0
  AND r.created_at BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY m.name, r.dish_id
HAVING COUNT(*) >= 5
ORDER BY avg_rating DESC
LIMIT 5;

-- Q1: Top 5 Lowest Rated Dishes (2024)
SELECT
  m.name AS dish_name,
  r.dish_id,
  ROUND(AVG(r.rate)::numeric, 2) AS avg_rating,
  COUNT(*) AS rating_count
FROM order_dish_rates r
JOIN menu m ON r.dish_id = m.dish_id
WHERE r.rate > 0
  AND r.created_at BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY m.name, r.dish_id
HAVING COUNT(*) >= 5
ORDER BY avg_rating ASC
LIMIT 5;

-- Q1: Top 5 Lowest Rated Dishes (2025)
SELECT
  m.name AS dish_name,
  r.dish_id,
  ROUND(AVG(r.rate)::numeric, 2) AS avg_rating,
  COUNT(*) AS rating_count
FROM order_dish_rates r
JOIN menu m ON r.dish_id = m.dish_id
WHERE r.rate > 0
  AND r.created_at BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY m.name, r.dish_id
HAVING COUNT(*) >= 5
ORDER BY avg_rating ASC
LIMIT 5;

-- Q2: Top Client Complaint Categories (2024–2025)
SELECT
  CASE
    WHEN comment ILIKE '%опоздал%' OR comment ILIKE '%задерж%' OR comment ILIKE '%позже%' THEN 'Late Delivery'
    WHEN comment ILIKE '%не положили%' OR comment ILIKE '%не было%' OR comment ILIKE '%отсутств%' THEN 'Missing Item'
    WHEN comment ILIKE '%не тот%' OR comment ILIKE '%перепутали%' THEN 'Wrong Item'
    WHEN comment ILIKE '%не доставили%' OR comment ILIKE '%не пришел%' OR comment ILIKE '%не приехал%' THEN 'Undelivered Order'
    WHEN comment ILIKE '%испорчен%' OR comment ILIKE '%протек%' OR comment ILIKE '%плохой%' THEN 'Spoiled/Broken Food'
    WHEN comment ILIKE '%холодн%' OR comment ILIKE '%остыл%' THEN 'Cold Food'
    ELSE 'Other'
  END AS complaint_category,
  COUNT(*) AS total_complaints
FROM claims
WHERE created_at BETWEEN '2024-01-01' AND '2025-12-31'
  AND comment IS NOT NULL
GROUP BY complaint_category
ORDER BY total_complaints DESC;

-- Q3: Order Cancellation Reasons (if tracked)
SELECT
  order_cancel_type_id,
  COUNT(*) AS total
FROM orders
WHERE order_status_id = 16
  AND created_at BETWEEN '2024-01-01' AND '2025-12-31'
GROUP BY order_cancel_type_id
ORDER BY total DESC;