# 📊 Cohort Analysis Project (SQL)

## 🚀 Overview

This project focuses on performing **Cohort Analysis** using SQL to understand customer behavior over time.

Cohort analysis groups customers based on their **first purchase date (cohort year)** and tracks metrics like:

* Customer acquisition
* Revenue generation
* Customer lifetime value (LTV)
* Retention & churn behavior

The dataset used (`cohort_analysis`) contains transaction-level data including:

* `customerkey`
* `customer_name`
* `orderdate`
* `first_purchase_date`
* `total_net_revenue`

---

## 🎯 Objectives

This project answers three key business questions:

1. **How many customers are acquired per cohort and how much revenue do they generate?**
2. **How can customers be segmented based on Lifetime Value (LTV)?**
3. **Which customers are active vs churned?**

---

## 🧠 Query 1: Cohort Performance Analysis

### 📌 Purpose

Analyze customer acquisition and revenue contribution per cohort year.

### 💻 SQL

```sql
SELECT 
    cohort_year,
    COUNT(DISTINCT customerkey) AS total_customers,
    ROUND(SUM(total_net_revenue)::NUMERIC,1) AS total_revenue,
    SUM(total_net_revenue)/COUNT(DISTINCT customerkey) AS customer_revenue
FROM 
    cohort_analysis
WHERE orderdate = first_purchase_date 
GROUP BY 
    cohort_year
ORDER BY 
    cohort_year,
    total_customers,
    total_revenue;
```
## conclusion:
**We identified new customers per cohort year and calculated how much revenue they generated at the time of acquisition, giving a clear view of cohort performance and quality over time**.

### 🔍 Insights

* Identifies **new customers per cohort**
* Measures **initial revenue contribution**
* Helps compare **cohort quality over time**

---

## 🧠 Query 2: Customer Segmentation (LTV-Based)

### 📌 Purpose

Segment customers into **Low**, **Mid**, and **High value** groups based on Lifetime Value.

### 💻 SQL

```sql
WITH customer_ltv AS (
    SELECT 
        ca.customerkey,
        ca.customer_name,
        SUM(ca.total_net_revenue) AS total_ltv
    FROM cohort_analysis AS ca
    GROUP BY 
        ca.customerkey,
        ca.customer_name
),
        
customer_segments AS(
    SELECT 
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_ltv) AS ltv_25th_percentile,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_ltv) AS ltv_75th_percentile
    FROM 
        customer_ltv
), 
    
segement_values AS (
    SELECT 
        c.*,
        CASE 
            WHEN c.total_ltv < cs.ltv_25th_percentile THEN '1-LOW VALUE'
            WHEN c.total_ltv <= cs.ltv_75th_percentile THEN '2-MID VALUE'
            ELSE '3-HIGH VALUE'
        END AS customer_segment
    FROM 
        customer_ltv AS c,
        customer_segments AS cs
)
    
SELECT 
    customerkey,
    customer_name,
    total_ltv,
    customer_segment
FROM 
    segement_values;
```
## conclusion:
**We calculated each customer’s total lifetime value (LTV) and grouped them into Low, Mid, and High value segments using percentiles, enabling better customer prioritization and targeting.**.

### 🔍 Insights

* Uses **percentile-based segmentation**
* Identifies:

  * 🔴 Low-value customers (bottom 25%)
  * 🟡 Mid-value customers (25–75%)
  * 🟢 High-value customers (top 25%)
* Useful for **targeted marketing & retention strategies**

---

## 🧠 Query 3: Retention & Churn Analysis

### 📌 Purpose

Classify customers as **Active** or **Churned** based on their last purchase.

### 💻 SQL

```sql
WITH retention AS(
    SELECT 
        customerkey,
        MAX(first_purchase_date) AS first_purchase_date,
        MAX(customer_name) AS customer_name,
        MAX(orderdate) AS last_purchase_date,
        AGE('2024-04-20', MAX(orderdate)) AS purchase_time
    FROM    
        cohort_analysis
    GROUP BY 
        customerkey
    ORDER BY 
        customerkey
)

SELECT 
    customerkey,
    customer_name,
    first_purchase_date,
    last_purchase_date,
    CASE 
        WHEN purchase_time > INTERVAL '6 months' THEN 'CHURNED'
        ELSE 'ACTIVE'
    END AS customer_status
FROM 
    retention
WHERE first_purchase_date < '2023-10-20';
```
## conclusion:
**We analyzed each customer’s last purchase activity to classify them as Active or Churned, helping detect inactive users and potential retention issues.

Since the dataset is nearly 2 years old, using the actual current date would incorrectly classify almost all customers as churned due to the data gap. To avoid this, we used a fixed reference date **| 2024-04-20 |** as the effective current date for all calculations, ensuring more accurate and meaningful churn classification.**.

## 🔍 Insights
* Tracks **last purchase activity**
* Defines churn as **no purchase in last 6 months**
* Helps:
  * Identify **at-risk customers**
  * Improve **retention strategies**


## 📈 Key Takeaways
* Cohort analysis reveals **customer quality over time**
* LTV segmentation helps prioritize **high-value customers**
* Retention analysis highlights **churn risks**

## 📚 What I Learned

* How to perform **Cohort Analysis** to track customer behavior over time
* Writing advanced SQL using **CTEs (Common Table Expressions)**
* Using **aggregate functions** to calculate revenue and customer metrics
* Applying **window functions like `PERCENTILE_CONT`** for segmentation
* Understanding **Customer Lifetime Value (LTV)** and its business impact
* Identifying **customer retention and churn patterns** using time-based logic

---

## 🛠️ Tools Used

* **PostgreSQL** – for writing and executing SQL queries
* **DBeaver** (or any SQL client) – for query management and analysis
* **Git & GitHub** – for version control and project sharing
* **ChatGPT** - used to speed up writing tasks, generate structured documentation, and create files like this README more efficiently

---

## 🧾 Conclusion

This project demonstrates how raw transactional data can be transformed into meaningful business insights using SQL.

By combining cohort analysis, LTV segmentation, and retention tracking, we can:

* Understand customer quality over time
* Identify high-value customers
* Detect churn early and take action

Overall, this analysis provides a strong foundation for **data-driven decision making** in areas like marketing, customer retention, and revenue optimization.


