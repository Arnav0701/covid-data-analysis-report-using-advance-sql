# covid-data-analysis-report-using-advance-sql
📊 COVID-19 Data Analysis (SQL Project)
📌 Overview

This project performs an in-depth analysis of global COVID-19 data using SQL. It focuses on understanding the impact, spread, and trends of the pandemic across countries by combining case data with population statistics.

The project is divided into two main parts:

🧹 Data Preprocessing & Cleaning
📈 Analytical Queries & Insights
🧹 Data Preprocessing

Before performing analysis, the dataset was cleaned and standardized to ensure data consistency and accurate joins.

🔧 Key Cleaning Steps
1. Standardizing Country Names
Fixed inconsistencies between datasets (e.g., population vs COVID data)
Examples:
Bahamas, The → Bahamas
US → USA
Burma → Myanmar
Holy See → Vatican City
2. Resolving Naming Conflicts
Unified country names across both datasets to enable proper joins
Handled special cases:
Congo split into:
Congo (Kinshasa)
Congo (Brazzaville)
3. Province-Level Adjustments
Ensured consistency where countries had province/state-level entries
Updated mismatched country_region and province values
4. Data Alignment for Joins
Matched country_region (COVID data) with country_name (population data)
Ensured compatibility for analytical queries like infection rates
🎯 Outcome of Preprocessing
Eliminated data mismatches
Enabled accurate joins between datasets
Improved reliability of all downstream analysis
📈 Data Analysis

The analysis focuses on two major aspects:

🔹 Part 1: Impact & Scale
1. Case Fatality Rate (CFR)
Calculated percentage of deaths relative to confirmed cases
Ranked countries by severity
2. Infection Rate vs Population
Identified countries with highest infection penetration
Used 2020 population data for normalization
3. Regional Contribution to Deaths
Analyzed province/state-level impact
Identified regions contributing most to national death tolls
4. Growth Benchmarks
Measured how quickly countries reached key milestones (e.g., first 100 deaths)
5. Global Hotspot Analysis
Identified high-intensity regions contributing most to global spread
6. Recovery Lag Analysis
Studied delay between case spikes and recovery spikes
7. Data Integrity Checks
Detected inconsistencies such as:
Recovered + Deaths > Confirmed
Quantified discrepancies
⚡ Part 2: Momentum & Trends
8. Rolling Averages
Calculated 7-day moving averages
Smoothed reporting fluctuations
9. Peak Case Identification
Found peak infection days for each country
Analyzed global peak periods
10. Doubling Rate Analysis
Measured how quickly cases doubled
Focused on early pandemic phase
11. Month-over-Month Growth
Tracked infection growth trends across 2020
Identified periods of rapid expansion
12. Sustained Decline Detection
Identified countries with consistent decline periods
Used sequential comparison logic
🧠 Key Concepts Used
Window Functions (LAG, ROW_NUMBER, SUM OVER)
Common Table Expressions (CTEs)
Aggregations (SUM, AVG)
Joins (multi-table analysis)
Data Cleaning & Standardization
Time-Series Analysis
📂 Dataset
COVID Data
Daily confirmed, deaths, recoveries
Country + province-level granularity
Population Data
Country-wise population (2020)
🚀 Key Insights
Significant variation in fatality rates across countries
Population-normalized metrics reveal true impact
Regional disparities within countries are substantial
Pandemic growth followed distinct global waves
🛠️ Tech Stack
SQL (MySQL)
Relational Data Modeling
Analytical Query Design
📌 Conclusion

This project demonstrates how raw, inconsistent real-world data can be transformed into meaningful insights using SQL. It highlights:

Importance of data cleaning before analysis
Power of window functions for time-series analysis
Value of contextual metrics (like population-adjusted rates)
