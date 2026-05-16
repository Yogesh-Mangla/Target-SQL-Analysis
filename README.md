# Target-SQL-Analysis

## 📌 Project Overview
This project contains an end-to-end data analysis repository analyzing Target's e-commerce operations in Brazil using Google BigQuery SQL. The project evaluates customer distributions, order seasonality, macroeconomic operational costs, logistics/delivery efficiencies, and payment preferences between 2016 and 2018.

## 📁 Repository Directory Structure
* `/sql_scripts`: Contains structured standalone SQL files broken down by business analysis categories.
* `/visualizations`: Houses query output screenshots and trend graphs.

## 🛠 Tech Stack Used
* **Database Platform:** Google BigQuery
* **SQL Language Features:** Common Table Expressions (CTEs), Subqueries, Aggregate Windows, Datetime/Timestamp formatting (`FORMAT_TIMESTAMP`, `EXTRACT`), Conditional logic (`CASE WHEN`).

## 🔍 Key Insights & Executive Summary

### 1. Exploratory Analytics
* The dataset captures transactions spanning from **September 4, 2016**, through **October 17, 2018**.
* Target’s active footprint covers **27 unique Brazilian states** and **4,119 distinct cities**.

### 2. Purchase Trends & Seasonality
* **Temporal Patterns:** Consumer activity spikes heavily during the **Afternoon** and **Night** periods, while dropping to its lowest point during **Dawn**.
* **Growth Velocity:** There was an enormous surge in total orders placed from 2016 to 2017. However, growth flattened going into 2018, indicating a potential plateau in customer acquisition or retention.

### 3. Regional Evolution
* The state of **SP (São Paulo)** functions as the primary economic hub for operations, capturing the largest share of total customer order volumes.

### 4. Supply Chain Logistics & Delivery Performance
* **Fulfillment Challenges:** A massive **~70% of shipments experienced delivery delays** compared to their originally estimated windows, with average fulfillment cycles stretching up to 69 days in slower regions. 
* **Top Performers:** The top 5 states with the fastest average delivery times relative to estimates were successfully isolated using CTE window calculations.

### 5. Payment Dynamics
* **Payment Types:** Credit cards have consistently remained the dominant payment method since 2017.
* **Installment Preferences:** The vast majority of consumers prefer completing transactions using a single payment installment rather than multi-month financing options.

## 📈 Sample Dashboard Snippets
### Payment Method Distribution Over Time
![Payment Trends](visualizations/payment_type_trends.png)

---
*Developed as a portfolio project demonstrating advanced business data analytics capabilities using SQL.*
