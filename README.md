# SQL-Project
Swiggy sales analysis using SQL
# Swiggy Data Analytics Project

## Overview

This project focuses on analyzing Swiggy food delivery data using **SQL** for data cleaning, transformation, schema design, and business insights generation. The project follows a **Data Warehouse approach** using **Fact and Dimension tables** to perform advanced analytics on orders, revenue, restaurants, cities, cuisines, ratings, and customer preferences.

The objective of this project is to extract meaningful business insights that help understand customer ordering behavior, restaurant performance, pricing trends, and revenue contribution across different locations.

---

## Features

* Data Cleaning & Validation
* Null, Blank, and Duplicate Handling
* Star Schema Data Warehouse Design
* Fact and Dimension Table Creation
* KPI Analysis
* Revenue & Order Trend Analysis
* Restaurant & Cuisine Performance Analysis
* City & State-wise Revenue Insights
* Price Range Distribution Analysis
* Ratings & Customer Preference Analysis

---

## Technologies Used

* **SQL Server**
* **T-SQL**
* Data Warehousing
* Star Schema Modeling
* Business Intelligence Concepts

---

## Database Schema

### Dimension Tables

* `dim_date`
* `dim_location`
* `dim_restaurant`
* `dim_category`
* `dim_dish`

### Fact Table

* `fact_swiggy_orders`

---

## Data Cleaning Process

The project includes:

* Null value checks
* Blank string validation
* Duplicate detection and removal using `ROW_NUMBER()`
* Data standardization

---

## Key KPIs

* Total Orders
* Total Revenue
* Average Dish Price
* Average Ratings

---

## Business Insights Generated

### Time-Based Analysis

* Monthly Order Trends
* Quarterly Trends
* Yearly Trends
* Orders by Day of Week

### Location Analysis

* Top Cities by Orders
* Top Cities by Revenue
* State-wise Revenue Contribution

### Restaurant & Cuisine Analysis

* Top Restaurants by Revenue
* Most Ordered Dishes
* Cuisine Performance
* Category-wise Orders

### Customer Behavior Analysis

* Price Range Distribution
* Rating Distribution

---

## Project Structure

```bash
Swiggy-Data-Analytics/
│
├── SQL Scripts/
│   ├── Data Cleaning.sql
│   ├── Schema Creation.sql
│   ├── KPI Analysis.sql
│   └── Business Insights.sql
│
├── Dataset/
│   └── swiggy_data.csv
│
└── README.md
```

---

## Sample SQL Concepts Used

```sql
ROW_NUMBER()
JOINS
GROUP BY
CASE WHEN
AGGREGATE FUNCTIONS
WINDOW FUNCTIONS
FOREIGN KEYS
IDENTITY
```

---

## Learning Outcomes

Through this project, I gained hands-on experience in:

* SQL Query Optimization
* Data Cleaning Techniques
* Data Warehousing Concepts
* Business Intelligence Reporting
* KPI Development
* Analytical Problem Solving

---

## Future Enhancements

* Build Power BI Dashboard Integration
* Add Customer Segmentation Analysis
* Perform Predictive Analytics
* Automate ETL Pipeline

---

---
