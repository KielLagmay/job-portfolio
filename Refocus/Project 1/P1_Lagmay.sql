-- Marketing Impressions Table Creation
CREATE TABLE IF NOT EXISTS marketing_impressions (
	session_id BIGINT,
	user_id BIGINT,
	campaign_id BIGINT,
	campaign_name VARCHAR,
	webpage_id BIGINT,
	product_category VARCHAR,
	gender VARCHAR,
	age_level VARCHAR,
	region VARCHAR,
	is_click INTEGER
);

-- Sales Data Creation
CREATE TABLE IF NOT EXISTS sales_data (
	session_id BIGINT,
	user_id BIGINT,
	product_category VARCHAR,
	region VARCHAR,
	is_campaign INTEGER,
	total_php NUMERIC
);

-- Exploring Marketing Impressions Table
SELECT * FROM marketing_impressions;

-- Exploring Sales Data
SELECT * FROM sales_data;

-- Combining Marketing Impressions with Sales Data
CREATE TABLE marketing_impressions_with_sales_data AS
SELECT 
marketing_impressions.session_id, marketing_impressions.user_id, campaign_id,
campaign_name, webpage_id, marketing_impressions.product_category, gender, age_level,
marketing_impressions.region, is_click, is_campaign, total_php
FROM marketing_impressions
LEFT JOIN sales_data
ON 
marketing_impressions.session_id = sales_data.session_id AND
marketing_impressions.user_id = sales_data.user_id AND
marketing_impressions.product_category = sales_data.product_category AND
marketing_impressions.region = sales_data.region;

SELECT * FROM marketing_impressions_with_sales_data;

-- Overall Click-Through Rate of Campaigns
-- What is the overall click-through rate (CTR) for the campaigns launched by the company?
ALTER TABLE marketing_impressions_with_sales_data
ALTER COLUMN is_click TYPE NUMERIC USING(is_click::NUMERIC);

SELECT
campaign_name,
ROUND((SUM(is_click) / COUNT(campaign_name)) * 100, 2) AS ctr_campaigns
FROM marketing_impressions_with_sales_data
GROUP BY campaign_name
ORDER BY ctr_campaigns DESC;

SELECT
ROUND((SUM(is_click) / COUNT(*)) * 100, 2) AS ctr_campaigns
FROM marketing_impressions_with_sales_data;

-- Click-Through Rate of Product Categories
-- What is the CTR for each product category?
SELECT
product_category,
ROUND((SUM(is_click) / COUNT(product_category)) * 100, 2) AS ctr_product_categories
FROM marketing_impressions_with_sales_data
GROUP BY product_category
ORDER BY ctr_product_categories DESC;

-- Percentage of Revenue from Campaigns per Gender
-- What percentage of the total revenue generated during campaign periods is contributed by 
-- female customers?
UPDATE marketing_impressions_with_sales_data
SET total_php = (
	CASE
		WHEN total_php IS NULL THEN 0
		ELSE total_php
	END
);

CREATE TABLE total_revenue_campaigns AS
SELECT
campaign_name,
SUM(total_php) AS total_revenue_overall
FROM marketing_impressions_with_sales_data
GROUP BY campaign_name;

SELECT * FROM total_revenue_campaigns;

CREATE TABLE total_revenue_campaigns_per_gender AS
SELECT
gender,
campaign_name,
SUM(total_php) AS total_revenue
FROM marketing_impressions_with_sales_data
GROUP BY gender, campaign_name;

SELECT * FROM total_revenue_campaigns_per_gender;

SELECT
gender,
total_revenue_campaigns.campaign_name,
ROUND((total_revenue / total_revenue_overall) * 100, 2) AS percentage_revenue
FROM total_revenue_campaigns_per_gender
INNER JOIN total_revenue_campaigns
ON total_revenue_campaigns_per_gender.campaign_name = total_revenue_campaigns.campaign_name

SELECT
gender,
ROUND(
(SUM(total_php) / 
(SELECT SUM(total_php) FROM marketing_impressions_with_sales_data)) 
* 100, 2) AS percentage_revenue
FROM marketing_impressions_with_sales_data
GROUP BY gender;

-- Get Campaign with the most Impressions
-- Which campaign has generated the most impressions?
CREATE TABLE impression_campaigns AS
SELECT
campaign_name,
COUNT(campaign_name) AS impressions
FROM marketing_impressions_with_sales_data
GROUP BY campaign_name
ORDER BY impressions DESC;

SELECT * FROM impression_campaigns;

SELECT campaign_name FROM impression_campaigns
ORDER BY impressions DESC
LIMIT 1;

-- Number of Unique User Views for the Campaign with the most Impressions
-- How many unique users per location viewed the campaign with the most impressions?
SELECT
region,
COUNT(DISTINCT user_id) AS unique_users
FROM marketing_impressions_with_sales_data
WHERE campaign_name = (
	SELECT campaign_name FROM impression_campaigns
	ORDER BY impression_campaigns DESC
	LIMIT 1
)
GROUP BY region
ORDER BY unique_users DESC;

-- Total Impressions and CTR per Product Category per Location
-- What are the total impressions and CTR for each product category per location?
SELECT
region,
product_category,
COUNT(product_category) AS impressions_product_categories,
ROUND((SUM(is_click) / COUNT(product_category)) * 100, 2) AS ctr_product_categories
FROM marketing_impressions_with_sales_data
GROUP BY region, product_category;

-- Total Impressions and CTR per Product Category per Age Group
-- What are the total impressions and CTR for each product category per age group?
SELECT
age_level,
product_category,
COUNT(product_category) AS impressions_product_categories,
ROUND((SUM(is_click) / COUNT(product_category)) * 100, 2) AS ctr_product_categories
FROM marketing_impressions_with_sales_data
GROUP BY age_level, product_category;

-- Total Impressions and CTR per Product Category per Gender
-- What are the total impressions and CTR for each product category per gender?
SELECT
gender,
product_category,
COUNT(product_category) AS impressions_product_categories,
ROUND((SUM(is_click) / COUNT(product_category)) * 100, 2) AS ctr_product_categories
FROM marketing_impressions_with_sales_data
GROUP BY gender, product_category;