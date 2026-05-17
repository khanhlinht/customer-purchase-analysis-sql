SELECT * FROM [Customer Purchasing Behaviors];

-- 1. Summarize the overall customer profile and purchasing behavior
	SELECT
		count(distinct user_id) as No_of_customers,
		avg(age) as Average_age,
		avg(annual_income) as Average_income,
		avg(loyalty_score) as Average_loyalty_score,
		avg(purchase_amount) as Average_purchase_amount,
		avg(purchase_frequency) as Average_purchase_frequency
	FROM [Customer Purchasing Behaviors];

-- Summary/Findings:
-- a. This dataset has no duplicates.
-- b. There is a total of 238 customers purchased from the store, with the average age of 38, suggesting the customer base is mainly working-age adults.
-- c. The average annual income is USD 57,407, indicating a mid-income customer profile.
-- d. The average loyalty score is around 6.8, showing a moderate level of customer loyalty.
-- e. The average purchase amount is 425, with an average purchase frequency of 19 times

-- 2. Summarize the overall customer profile and purchasing behavior by region
	-- Create a temporary summary table by region using CTE
	WITH regionsum As(
		SELECT
			region as Region,
			count(distinct user_id) as No_of_customers,
			avg(age) as Average_age,
			avg(annual_income) as Average_income,
			ROUND(avg(loyalty_score),2) as Average_loyalty_score,
			sum(purchase_amount) as Total_purchase_amount,
			avg(purchase_frequency) as Average_purchase_frequency
		FROM [Customer Purchasing Behaviors]
		GROUP BY (region)
		)
	
	-- Select the summarized results by region, Calculate each region's percentage of total customers & total purchase amount
	SELECT
		Region,
		No_of_customers,
		cast(round(100.0*(No_of_customers)/ sum(No_of_customers) over(),0) as int) as Percentage_customer,
		Average_age,
		Average_income,
		Average_loyalty_score,
		Total_purchase_amount,
		cast(round(100.0*(Total_purchase_amount)/ sum(Total_purchase_amount) over(),0) as int) as Percentage_purchase,
		Average_purchase_frequency
	FROM regionsum

	-- Add an overall total row to the regional summary
	UNION ALL

	SELECT
		'Total' as Region,
		count(user_id),
		100,
		avg(age),
		avg(annual_income),
		round(avg(loyalty_score),1),
		sum(purchase_amount),
		100,
		avg(purchase_frequency)
	FROM [Customer Purchasing Behaviors]
	
	ORDER BY 
		No_of_customers;

-- Summary/Findings:
-- a. East is the weakest region, with the lowest number of customers, lowest average income, lowest loyalty score, and the smallest contribution to total purchase amount.
-- b. West is the strongest region, contributing the highest share of total purchase amount despite having a similar customer size to South and North.
-- c. West customers appear more valuable, as they have the highest average income, highest loyalty score, and highest purchase frequency.
-- d. North has the largest customer base, but its purchase contribution is lower than West, suggesting lower spending efficiency per customer.
-- e. Higher income seems to be associated with higher purchase contribution, as West has both the highest average income and the highest purchase share.

-- 3. Summarize the overall customer profile and purchasing behavior by age

	-- Create a temporary table to classify customers into age groups
	WITH Agegrouped AS (
		SELECT
			user_id,
			annual_income,
			purchase_amount,
			loyalty_score,
			region,
			purchase_frequency,
			CASE
				WHEN age BETWEEN 21 AND 30 THEN '21-30'
				WHEN age BETWEEN 31 AND 40 THEN '31-40'
				WHEN age BETWEEN 41 AND 50 THEN '41-50'
				WHEN age BETWEEN 51 AND 60 THEN '51-60'
				ELSE 'Other'
			END AS Age_group
		FROM [Customer Purchasing Behaviors]
	),
	-- Create a temporary summary table by age group
	Agesum AS (
		SELECT
			Age_group,
			count(user_id) as No_of_customers,
			avg(annual_income) as Average_income,
			ROUND(avg(loyalty_score),2) as Average_loyalty_score,
			sum(purchase_amount) as Total_purchase_amount,
			avg(purchase_frequency) as Average_purchase_frequency
		FROM Agegrouped
		GROUP BY age_group
	)
	
	-- Select the summarized results by age group, Calculate each age group's percentage of total customers & total purchase amount
	SELECT
		Age_group,
		No_of_customers,
		cast(round(100.0 * No_of_customers/ sum(No_of_customers) over(),0) as int) as Percentage_customer,
		Average_income,
		Average_loyalty_score,
		Total_purchase_amount,
		cast(round(100.0 * Total_purchase_amount/ sum(Total_purchase_amount) over(),0) as int) as Percentage_purchase,
		Average_purchase_frequency
	FROM Agesum

	-- Add an overall total row to the age group summary
	UNION ALL

	SELECT
		'Total' as Age_group,
		count(user_id),
		100,
		avg(annual_income),
		ROUND(avg(loyalty_score),1),
		sum(purchase_amount),
		100,
		avg(purchase_frequency)
	FROM [Customer Purchasing Behaviors];

-- Summary/Findings:
-- a. The 31–40 and 41–50 groups make up the core customer base, together accounting for 63% of customers and 68% of total purchase amount.
-- b. The 41–50 age group is the most valuable segment, contributing the highest share of total purchase amount at 39% and strong purchase frequency.
-- c. The 51–60 group has the highest loyalty score and purchase frequency, but its smaller customer size limits its total purchase contribution.
-- d. The 21–30 group is the weakest segment, with the lowest average income, lowest loyalty score, lowest purchase frequency, and the smallest purchase contribution.
-- e. Purchase behavior appears to strengthen with age, as older groups generally show higher income, higher loyalty scores, and higher purchase frequency.

-- 4. What is the average income and purchase amount by loyalty score?
	-- Classify customers into loyalty score groups
	WITH Loyaltygrouped AS (
		SELECT
			user_id,
			annual_income,
			purchase_amount,
			loyalty_score,
			CASE
				WHEN loyalty_score >=0 AND loyalty_score <= 6 THEN '0-6'
				WHEN loyalty_score >0 AND loyalty_score <= 8 THEN '6-8'
				WHEN loyalty_score >8 AND loyalty_score <= 10 THEN '8-10'
				ELSE 'Other'
			END AS Loyalty_score_group
		FROM [Customer Purchasing Behaviors]
	)
	-- Calculate average income and purchase amount for each group
	SELECT
		Loyalty_score_group,
		avg(annual_income) as Average_income,
		avg(purchase_amount) as Average_purchase_amount
	FROM Loyaltygrouped
	GROUP BY Loyalty_score_group
	ORDER BY Loyalty_score_group;
	
	-- Summary/Findings:
	-- Customers with higher loyalty scores tend to have higher average income and higher purchase amount, suggests a positive relationship between loyalty score and purchasing amount

	-- 5. What is the average income and purchase amount by purchase frequency?
	-- Classify customers into purchase frequency groups
	WITH Purchasefrequencygrouped AS (
		SELECT
			user_id,
			region,
			annual_income,
			purchase_amount,
			purchase_frequency,
			CASE
				WHEN purchase_frequency <= 16 THEN '<=16'
				WHEN purchase_frequency <= 23 THEN '<=23'
				ELSE '>23'
			END AS Purchase_frequency_group
		FROM [Customer Purchasing Behaviors]
	)
	-- Calculate average income and purchase amount for each group
	SELECT
		Purchase_frequency_group,
		region,
		count(user_id) as No_of_customers,
		avg(annual_income) as Average_income,
		avg(purchase_amount) as Average_purchase_amount
	FROM Purchasefrequencygrouped
	GROUP BY Purchase_frequency_group, region
	ORDER BY Purchase_frequency_group;

	-- Summary/Findings:
	-- a. Customers with higher purchase frequency tend to have higher average income and higher purchase amount
	-- b. The 17–23 purchase frequency group has the largest number of customers, but its average purchase amount is still lower than the >23 group
	-- c. The >23 group is the most valuable segment, with the highest average income and highest average purchase amount, although it has fewer customers than the 17–23 group
	-- e. should target both the 17–23 group and the >23 group:
		-- the 17–23 group has strong potential due to its large customer base
		-- the >23 group should be retained and further developed because of its high spending value