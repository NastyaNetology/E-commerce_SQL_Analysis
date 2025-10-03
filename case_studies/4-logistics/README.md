# Case Study 4: Logistics

## Business Problem


## Entity Relationship Diagram



## Questions Answered


### Folder Structure


## Question and Solution

###  Q1: 


#### Relevant Table(s)


# Delivery Tariff Schema

## Database Relations (ASCII Diagram)
# Database Relations (ASCII Diagram)

```text
+---------+          +-----------+-----------+          +---------------------+
|  users  |          | delivery_tariff       |          |  courier_delivery    |
| id      |<---------+ id, name, courier_    +----------+ order_id, courier_id,|
| name    |          | kind_id, cost         |          | delivery_tariff_id   |
+----^----+          +-----------^-----------+          +----------^-----------+
     |                          |                                   |
     |                          |                                   |
     |                          +-----------------------------------+
     |
     |       (selected tariff is applied to order)
     |
+----+-----------------------------------------------------------------------+
|                                 orders                                    |
| id, client_id, courier_id, payment_type_id, client_address_id,             |
| delivery_from, delivery_to, fullname, phonenumberint, ordertype, ...       |
+----+-----------------+---------------------+---------------+---------------+
     |                 |                     |               |
     |                 |                     |               |
     v                 v                     v               v
+----------+    +--------------+     +-------------+    +-------------+
| clients  |    | payment_type |     | clients_    |    | courier_    |
| id,name, |    | id, name,    |     | address     |    | tasks       |
| surname  |    | enabled      |     | id, city,   |    | order_id,   |
+----------+    +--------------+     | street,     |    | cost ...    |
                                     | house, lat, |    +------^------+
                                     | lng, dist.. |           |
                                     +------^------+           |
                                            |                  |
                                            | geo point        |
                                            |                  |
                                     +------+------------------+------+
                                     |       delivery_zone            |
                                     | id, title, region_id, city_id, |
                                     | borders (polygon), value(dist) |
                                     +--------------------------------+

```


####  Step 1: Base orders (date + interval)
- Shows order id, delivery day, and time interval. 
- Joins surname and name with a space in between: CONCAT_WS(' ', c.surname, c.name)


```sql
SELECT 
o.id AS order_id,
o.delivery_from:: date as delivery_day,
to_char(o.delivery_from, 'HH24:MI') || ' - ' || 
to_char(o.delivery_to, 'HH24:MI') as delivery_interval
FROM orders o
WHERE o.delivery_from >= DATE '2025-01-01'
  AND o.delivery_from <  DATE '2026-01-01'
ORDER BY o.delivery_from, o.id
LIMIT 100;
```


####  Step 2: Client name & phone
Adds readable client name and phone from clients

```sql
SELECT 
o.id AS order_id,
o.delivery_from::date AS delivery_day,
to_char(o.delivery_from,'HH24:MI') || ' - ' || to_char(o.delivery_to,'HH24:MI') AS delivery_interval,
CONCAT_WS(' ', c.surname, c.name) AS client_name,
NULLIF(o.phonenumberint::text,'0') AS client_phone
FROM orders o
LEFT JOIN clients c ON c.id = o.client_id
WHERE o.delivery_from >= DATE '2025-01-01'
  AND o.delivery_from <  DATE '2026-01-01'
ORDER BY o.delivery_from, o.id
LIMIT 100;

```

#### Step 3: Payment type & cash amount
- If the order’s payment type is 1 (say, “cash payment”), then the query shows the full order cost in the cash amount column.

```sql
SELECT 
o.id AS order_id,
o.delivery_from::date AS delivery_day,
to_char(o.delivery_from,'HH24:MI') || ' - ' || to_char(o.delivery_to,'HH24:MI') AS delivery_interval,
CONCAT_WS(' ', c.surname, c.name) AS client_name,
NULLIF(o.phonenumberint::text,'0') AS client_phone,
case when o.payment_type_id = 1 then o.costall else 0 end as cash_amount
FROM orders o
LEFT JOIN clients c ON c.id = o.client_id
LEFT JOIN payment_type pt on pt.id = o.payment_type_id
WHERE o.delivery_from >= DATE '2025-01-01'
  AND o.delivery_from <  DATE '2026-01-01'
ORDER BY o.delivery_from, o.id
LIMIT 100;

```


####  Step 4: Courier, contractor, courier kind
- Add courier’s name (users), contractor (courier_type), courier kind (courier_kind) from users, courier_kind, courier_type

```sql
SELECT 
o.id AS order_id,
o.delivery_from::date AS delivery_day,
to_char(o.delivery_from,'HH24:MI') || ' - ' || to_char(o.delivery_to,'HH24:MI') AS delivery_interval,
CONCAT_WS(' ', c.surname, c.name) AS client_name,
NULLIF(o.phonenumberint::text,'0') AS client_phone,
case when o.payment_type_id = 1 then o.costall else 0 end as cash_amount,
u.name AS courier_name,
ct.name AS contractor,
ck.name AS courier_kind
FROM orders o
LEFT JOIN clients c ON c.id = o.client_id
LEFT JOIN payment_type pt ON pt.id = o.payment_type_id
LEFT join users u ON u.id = o.courier_id
LEFT join courier_type ct on ct.id = u.courier_type_id
LEFT join courier_kind ck on ct.id = u.courier_kind_id
WHERE o.delivery_from >= DATE '2025-01-01'
  AND o.delivery_from <  DATE '2026-01-01'
ORDER BY o.delivery_from, o.id
LIMIT 100;
```

#### Step 5: Address & distance
Add delivery address string and distance from clients_address.

```sql
SELECT 
  o.id AS order_id,
  o.delivery_from::date AS delivery_day,
  to_char(o.delivery_from,'HH24:MI') || ' - ' || to_char(o.delivery_to,'HH24:MI') AS delivery_interval,
  CONCAT_WS(' ', c.surname, c.name) AS client_name,
  NULLIF(o.phonenumberint::text,'0') AS client_phone,
  CASE WHEN o.payment_type_id = 1 THEN o.costall ELSE 0 END AS cash_amount,
  u.name AS courier_name,
  ct.name AS contractor,
  ck.name AS courier_kind,
  CONCAT_WS(', ', dc.title, ca.street, ca.house, ca.flat) AS delivery_address,
  ca.distance AS distance
FROM orders o
LEFT JOIN clients c           ON c.id = o.client_id
LEFT JOIN payment_type pt     ON pt.id = o.payment_type_id
LEFT JOIN users u             ON u.id = o.courier_id
LEFT JOIN courier_type ct     ON ct.id = u.courier_type_id
LEFT JOIN courier_kind ck     ON ck.id = u.courier_kind_id
LEFT JOIN clients_address ca  ON ca.id = o.client_address_id
LEFT JOIN delivery_city dc ON dc.id = ca.city_id
WHERE o.delivery_from >= DATE '2025-01-01'
  AND o.delivery_from <  DATE '2026-01-01'
ORDER BY o.delivery_from, o.id
LIMIT 100;

```
