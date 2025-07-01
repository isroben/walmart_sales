USE walmart_db;

-- Business Problems.
-- 1. Find the different payment method and number of transactions, number of Qty sold

SELECT * FROM walmart;

SELECT payment_method, SUM(quantity) as Qty_sold, COUNT(*) total_tranasction FROM walmart
GROUP BY 1;


-- 2. Identify the highest-rated category in each branch, displaying the branch, category and avg rating
SELECT * FROM (
SELECT w.branch, w.category, AVG(w.rating),
RANK() OVER(PARTITION BY w.branch ORDER BY AVG(w.rating) DESC) AS ranks FROM walmart w
GROUP BY 1, 2) AS s
WHERE s.ranks = 1;


-- 3. Identify the busiest day for each branch based on the number of transactions
SELECT branch, CONVERT(date, DATE), COUNT(*) as no_of_trans FROM walmart
GROUP BY 1, 2
ORDER BY 3 DESC;




-- 4. Calculate the total quantity of items sold per payment method. List payment_method and total_quantity.
SELECT payment_method, SUM(quantity) FROM walmart
GROUP BY 1;



-- 5. Determine the average, minimum and maximum rating of products for each city.
-- List the city, average_rating, min_rating and max_rating

SELECT city, category, AVG(rating) as avg_rating,
 MIN(rating) as min_rating, MAX(rating) as max_rating FROM walmart
GROUP BY 1, 2
ORDER BY 3 DESC, 4 DESC, 5 DESC;



-- 6. Calculate the total profit for each category by considering total_profit
-- List category and total_profit, ordered from highest to lowest profit.
SELECT category, SUM(quantity*profit_margin) as profit FROM walmart
GROUP BY 1
ORDER BY 2 DESC;



-- 7. Determine the most common payment method for each Branch
WITH cte AS(
	SELECT branch, payment_method, COUNT(payment_method),
	RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) as ranks FROM walmart
	GROUP BY 1, 2
)
SELECT * FROM cte WHERE ranks=1;



-- 8. Categorize sales into 3 group Morning, Afternoon, Evening
-- Find out which of the shift and number of invoices
SELECT branch,
CASE 
	WHEN HOUR(CONVERT(time, TIME)) < 12 THEN 'Morning'
	WHEN HOUR(CONVERT(time, TIME)) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
    END day_time, COUNT(*) as no_of_sales
FROM walmart
GROUP BY 1, 2
ORDER BY 1, 3;



-- 9. Identify 5 Branch with highest decrease ration in revenue compare to last year(current year 2023 and last year 2023)

SELECT *, YEAR(CONVERT(date, DATE)) AS f_date
FROM walmart;


WITH revenue_2022 AS (
	SELECT branch, SUM(total) as revenue FROM walmart
	WHERE YEAR(CONVERT(date, DATE)) = 2022
	GROUP BY 1
),
revenue_2023 AS (
	SELECT branch, SUM(total) as revenue FROM walmart
	WHERE YEAR(CONVERT(date, DATE)) = 2023
	GROUP BY 1
)

SELECT ls.branch, ls.revenue as last_year_revenue,
cs.revenue as cr_year_revenue,
ROUND((ls.revenue - cs.revenue)/ls.revenue*100, 2) as revenue_decr_ration FROM revenue_2022 as ls
JOIN revenue_2023 as cs
ON ls.branch = cs.branch
WHERE ls.revenue > cs.revenue
ORDER BY 4 DESC
LIMIT 5;





