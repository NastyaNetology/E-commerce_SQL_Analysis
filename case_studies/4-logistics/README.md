# Case Study 4: Logistics
The company delivers to multiple regions and cities. 

## Business Problem
In distant zones, the cost of delivery is higher, but previously the system treated all zones the same. This led to negative unit economics in remote areas.

## Goal
- Introduce paid delivery zones with extra charges for couriers and/or customers.
- Ensure delivery remains profitable across all geographies.

## Entity Relationship Diagram
At a high level, the logistics system consists of:
- Orders → contain delivery info, client info, payment type.
- Clients & Addresses → provide the delivery coordinates.
- Delivery Zones → polygons defining service regions.
- Delivery Tariffs → pricing matrix by courier type / distance.
- Couriers (Users) → assigned to orders, linked to contractor & courier kind.
- Courier Tasks → factual costs of delivery (sum used as tariff payout).


## Questions Answered
- How are tariffs connected to addresses and distances?
- How does the system determine which delivery zone applies to an order?
- How is courier payout calculated and stored?
- How can we report deliveries (who delivered, when, to where, how much it cost)?


# Delivery Tariff Schema

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

## Solution

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


#### Step 6: Factual courier tariff (sum of courier_tasks.cost)
The courier’s tariff (the amount paid per delivery) is calculated from the table courier_tasks as sum of courier's tasks costs.
Steps of subquereis:
1) Finds all tasks for that order in courier_tasks;
2) Sums up their cost;
3) Returns a single aggregated result;
4) Keeps your main result set to one row per ord

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
  ca.distance AS distance,
  -- Subquery: total tariff per order
  (select sum(ctask.cost)
  from courier_tasks ctask
  where ctask.order_id = o.id) as tariff
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

#### Step 7: Product & Region
Add product (ordertype), human-readable region from table regions

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
  ca.distance AS distance,
  (select sum(ctask.cost)
  from courier_tasks ctask
  where ctask.order_id = o.id) as tariff,
  o.ordertype as Order_type,
  r.regname as region
  FROM orders o
LEFT JOIN clients c           ON c.id = o.client_id
LEFT JOIN payment_type pt     ON pt.id = o.payment_type_id
LEFT JOIN users u             ON u.id = o.courier_id
LEFT JOIN courier_type ct     ON ct.id = u.courier_type_id
LEFT JOIN courier_kind ck     ON ck.id = u.courier_kind_id
LEFT JOIN clients_address ca  ON ca.id = o.client_address_id
LEFT JOIN delivery_city dc ON dc.id = ca.city_id
LEFT join regions r on r.id = o.region_id
WHERE o.delivery_from >= DATE '2025-01-01'
  AND o.delivery_from <  DATE '2026-01-01'
ORDER BY o.delivery_from, o.id
LIMIT 100;
```


#### Step 8: Zone by geometry (pick 1 zone per address)
Add delivery zone title found by ST_Intersects (address point vs zone polygon).
How the subquery works:
1) Read polygons from delivery_zone: dz.borders stores the actual polygon geometry of each zone.
2) Build a point for the customer address using ST_MakePoint(ca.lng, ca.lat).
3) Set SRID with ST_SetSRID(..., 4326) so the point is in WGS84 (GPS).
- Ensure dz.borders has the same SRID (usually 4326).
4) Containment test: ST_Intersects(dz.borders, point) returns zones that contain the address point.
5) Pick one zone: ORDER BY dz.value LIMIT 1 selects the preferred zone (assuming smaller value = closer/primary).
6) Return title: output the human-readable zone name dz.title.




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
  ca.distance AS distance,
  (select sum(ctask.cost)
  from courier_tasks ctask
  where ctask.order_id = o.id) as tariff,
  o.ordertype as Order_type,
  r.regname as region,
  -- Subquery: delivery zone by geometry 
  (select dz.title  
  from delivery_zone dz
  where dz.enable = 1
  and ST_Intersects(dz.borders,ST_SetSRID(ST_MakePoint(ca.lng, ca.lat), 4326))
  ORDER BY dz.value 
  LIMIT 1) as delivery_zone
FROM orders o
LEFT JOIN clients c           ON c.id = o.client_id
LEFT JOIN payment_type pt     ON pt.id = o.payment_type_id
LEFT JOIN users u             ON u.id = o.courier_id
LEFT JOIN courier_type ct     ON ct.id = u.courier_type_id
LEFT JOIN courier_kind ck     ON ck.id = u.courier_kind_id
LEFT JOIN clients_address ca  ON ca.id = o.client_address_id
LEFT JOIN delivery_city dc ON dc.id = ca.city_id
LEFT join regions r on r.id = o.region_id
WHERE o.delivery_from >= DATE '2025-01-01'
  AND o.delivery_from <  DATE '2026-01-01'
ORDER BY o.delivery_from, o.id
LIMIT 100;
```


#### Questions
1. How is the courier’s tariff calculated?  How is the courier_tasks.cost calculated?
     a) What parameters influence the final tariff amount: delivery zone, courier type, distance?
     b) Which field or formula determines the tariff per order (e.g., courier_tasks.cost, delivery_tariff.cost)?
     c) How do different courier types (walking, car, refrigerator) impact tariff selection.
3. How does the courier’s tariff depend on distance? How does clients_address relate to the delivery_tariff.cost?
4. How is the courier’s final income measured? Is the courier’s payout based on the sum of all courier_tasks.cost per order?
5. How does customer delivery payment relate to courier payout?

