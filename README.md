# ShopEasy E-commerce SQL Analysis

An end-to-end SQL case study analyzing customer behavior, sales trends, and delivery performance using the Olist Brazilian E-commerce dataset.

---

## Table of Contents

- [Business Objective](#business-objective)  
- [Entity Relationship Diagram](#entity-relationship-diagram)  
- [Dataset](#dataset)  
- [Case Study Questions](#case-study-questions)  
- [Solutions](#solutions)  
- [Summary & Insights](#summary--insights)  

---

## Business Objective

**ShopEasy**, an online retail platform, aims to enhance decision-making by analyzing key aspects of its e-commerce performance:

- Customer behavior patterns  
- Product popularity and delivery performance  
- Customer retention and churn analysis  
- Actionable insights for segmentation and loyalty strategies

---

## Entity Relationship Diagram

This project uses several interconnected tables. You can generate the ERD using [dbdiagram.io](https://dbdiagram.io) with the following tables:

- `orders`  
- `order_items`  
- `customers`  
- `products`  
- `sellers`  
- `order_payments`  
- `order_reviews`  

> The final ERD is available in the `/diagrams` folder as a `.png` file.

---

## Dataset

This is a Brazilian ecommerce public dataset of orders, the dataset has information of 100k orders made at multiple marketplaces in Brazil. 
https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce.

Download the dataset and load the following CSVs into your SQL environment:

- `olist_orders_dataset.csv`  
- `olist_order_items_dataset.csv`  
- `olist_customers_dataset.csv`  
- `olist_products_dataset.csv`  
- `olist_order_payments_dataset.csv`  
- `olist_order_reviews_dataset.csv`  

---

## Case Study Questions

Each question is addressed in an individual `.sql` file under the `/sql` directory.

- [Q0] What defines a "valid" purchase?
- [Q1] How many users made exactly one purchase?
- [Q2] What is the average number of undelivered orders per month, and why?
- [Q3] On which day of the week is each product most frequently purchased?
- [Q4] What is the average number of purchases per user per week (by month)?
- [Q5] Which customer cohort has the highest 3rd-month retention?

---

## Solutions

Detailed SQL scripts for each question are provided in the `/sql` folder with comments explaining each step and logic used.

---

## Summary & Insights

The analysis provides actionable insights into:

- **Customer purchasing patterns**
- **Delivery performance trends**
- **Retention and churn metrics**
- **Product and seller dynamics**

These findings can help ShopEasy optimize operations, improve customer experience, and drive long-term growth.
