# customer-purchase-analysis-sql
A SQL portfolio project analyzing customer segments and purchasing patterns by region, age, loyalty score, and purchase frequency.

## Project Overview
This project analyzes customer purchasing behavior using SQL. The analysis focuses on customer profiles, purchase amount, loyalty score, purchase frequency, age groups, and regional performance.

## Dataset
The dataset contains customer-level purchasing information, including:
- User ID
- Age
- Annual income
- Region
- Loyalty score
- Purchase amount
- Purchase frequency

## Business Questions
1. What is the overall customer profile and purchasing behavior?
2. How do customer behavior and purchase value differ by region?
3. Which age groups contribute the most to total purchase amount?
4. How do income and purchase amount vary by loyalty score group?
5. How does purchase frequency relate to customer value?

## SQL Skills Used
- Data Aggregation: Using COUNT, AVG, SUM to summarize customer metrics like total clients, average income, and purchase behavior.
- Case Statements: Creating conditional logic to group customers by region, age, purchase frequency, and loyalty scores.
- CTEs (Common Table Expressions): Structuring complex queries with WITH statements for clarity and reusability.
- Grouping and Filtering: GROUP BY to analyze customer data by age groups, regions, and loyalty segments.
- UNION ALL: Added a “Total” row to show overall results together with each segment.
- Data Cleaning: Ensuring no duplicates exist throughout the project.
- Order By and Formatting: Presenting clean and structured output using ORDER BY and rounding off metrics for readability.

## Key Findings
- The West region has the highest purchase contribution and the strongest customer value.
- The 41–50 age group contributes the highest share of total purchase amount.
- Customers with higher loyalty scores tend to have higher average income and purchase amount.
- The 17–23 purchase frequency group has the largest customer base, while the >23 group has the highest average purchase amount.

## Files
- `sql/customer_purchasing_analysis.sql`: SQL queries used for analysis
- `data/sample_customer_purchasing_behaviors.csv`: Sample dataset
- `outputs/`: Query result screenshots
