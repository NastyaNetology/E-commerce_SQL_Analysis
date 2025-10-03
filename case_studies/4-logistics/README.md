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


####  Step 1: Base orders (filter by delivery date)
Shows order id, delivery day, and time interval.

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
o.id as order_id,
o.delivery_from::date as delivery_day,
to_char(o.delivery_from, 'HH24:MI') || ' - ' || to_char(o.delivery_to, 'HH24:MI') as delivery_interval,
o.phonenumberint as client_phone,
CONCAT_WS(' ', c.surname, c.name) as client_name

FROM orders o
left join clients c on c.id = o.client_id
WHERE o.delivery_from >= DATE '2025-01-01'
  AND o.delivery_from <  DATE '2026-01-01'
ORDER BY o.delivery_from, o.id

```

####  Step 4: Delivery address (from clients_address, fallback to orders.address)
Builds a simple “City, Street, House”; if address record is missing, uses orders.address.

```sql


```

