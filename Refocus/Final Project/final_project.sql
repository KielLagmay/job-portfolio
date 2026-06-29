-- Explore the Dataset
SELECT * FROM competitors;
SELECT * FROM corruption_convictions_per_capita;
SELECT * FROM health_spending;
SELECT * FROM population;
SELECT * FROM property_prices;
SELECT * FROM state_income;

-- Find the top 5 states with the total highest health spending 
-- based on the average and population.
SELECT
h.state_usa,
h.avg_spending AS avg_health_spending,
pop.estimate AS population_estimate,
h.avg_spending * pop.estimate AS total_avg_health_spending
FROM health_spending h
INNER JOIN population pop
ON h.state_usa = pop.state_usa
ORDER BY h.avg_spending * pop.estimate DESC
LIMIT 5;

-- Find the top 5 states with the total lowest health spending
-- based on the average and population.
SELECT
h.state_usa,
h.avg_spending AS avg_health_spending,
pop.estimate AS population_estimate,
h.avg_spending * pop.estimate AS total_avg_health_spending
FROM health_spending h
INNER JOIN population pop
ON h.state_usa = pop.state_usa
ORDER BY h.avg_spending * pop.estimate ASC
LIMIT 5;

-- Join the competitor dataset with the health spending dataset 
-- to see if there is any correlation between health spending 
-- per state and profit.
SELECT
h.state_usa,
h.avg_spending AS avg_health_spending,
h.min_spending AS min_health_spending,
h.max_spending AS max_health_spending,
ROUND(comp.avg_profit, 2) AS avg_comp_profit
FROM health_spending h
INNER JOIN (
	SELECT
	state_usa,
	AVG(profit) AS avg_profit
	FROM competitors
	GROUP BY state_usa
) AS comp
ON h.state_usa = comp.state_usa
ORDER BY avg_comp_profit DESC;

-- Exports for Excel Analysis
-- Total Health Spending by Average and Population
SELECT
h.state_usa,
h.avg_spending AS avg_health_spending,
h.min_spending AS min_health_spending,
h.max_spending AS max_health_spending,
pop.estimate AS population_estimate
FROM health_spending h
INNER JOIN population pop
ON h.state_usa = pop.state_usa;

-- Property Price vs. Average Competitor Profit
SELECT
p.state_usa,
p.avg_price AS avg_property_price,
p.min_price AS min_property_price,
p.max_price AS max_property_price,
ROUND(comp.avg_profit, 2) AS avg_comp_profit
FROM property_prices p
INNER JOIN (
	SELECT
	state_usa,
	AVG(profit) AS avg_profit
	FROM competitors
	GROUP BY state_usa
) AS comp
ON p.state_usa = comp.state_usa;