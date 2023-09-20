
--- KPI’s Requirements
-- We need to analyse key indicators for our pizza sales data to gain insights
--- into our business performance. Specifically, we want to calculate the following:
-- 1. Total Revenue:  The sum of the total price of all pizza orders.	
--- 2 Average Orders Value: The Average amount spent per order, 
---   calculated by dividing the total revenue by the total number of orders.
 ---3. Total Pizzas Sold: The Sum of the quantities of all the pizzas sold
--- 4. Total Orders: The total number of orders placed
--- 5. Average Pizzas Per Order: The average number of pizzas sold per order, 
--- is calculated by dividing the total number of pizzas sold by the total number of orders.

-- We first select the table to identify the coulmn names.
SELECT*
FROM [Pizza DB].dbo.pizza_sales

-- We want investiagte the total number of orders palced our customers.
--  Total Orders: The total number of orders placed
SELECT COUNT(DISTINCT order_id) AS Total_orders from [Pizza DB].dbo.pizza_sales

-- Our first Query was to identify Total Revenue
SELECT SUM(total_price) AS Total_Revenue from [Pizza DB].dbo.pizza_sales

-- We use the SUM of total_price to two decimal places in my SQL query using the ROUND() function
SELECT ROUND(SUM(total_price), 2) AS Total_Revenue
FROM [Pizza DB].dbo.pizza_sales;

--- We need to find the Average Orders Value. 
--- To that we the Average amount spent per order, 
---  calculated by dividing the total revenue by the total number of orders
---- Becuase some of our orders have repeated numbers, so to find the avearge,
---- We need to us the DISTINCT funtion.

SELECT SUM(total_price) / COUNT(DISTINCT order_id) AS AVG_Order_Value FROM [Pizza DB].dbo.pizza_sales;


--- Total Pizzaz Sold:
--- The Sum of the quantities of all the pizzas sold
SELECT SUM(quantity) AS Total_Pizza_Sold FROM [Pizza DB].dbo.pizza_sales


--- Total Orders: The total number of orders placed
SELECT SUM(DISTINCT order_id) AS Total_Orders FROM [Pizza DB].dbo.pizza_sales

--- Average Pizzas Per Order: The average number of pizzas sold per order, 
--- is calculated by dividing the total number of pizzas sold by the total number of orders.
-- The CAST function is used here to ensure that both the numerator (total quantity of pizzas sold)
--- and the denominator (total number of distinct orders) are treated as decimal values with two decimal places. 
-- This ensures that the final result, representing the average pizzas per order, is also displayed with two decimal places
SELECT CAST(CAST(SUM(quantity)  AS decimal(10,2)) / CAST(COUNT(DISTINCT order_id) AS decimal (10,2))
AS decimal (10,2))  Average_Pizzas_Per_Order
FROM [Pizza DB].dbo.pizza_sales


-- Problem Statement by our Client
-- CHARTS Requirements
-- We would like to visualise various aspects of our pizza sales data to gain insights and understand key trends.
-- We have identified the following requirements for creating charts:
---  1.	Daily Trend for Total Orders:
--- Create a bar chart that displays the daily trend of the total orders over a specific period. 
--- This chart will help us identify patterns or fluctuations in daily order volumes

--- To do the above we will use the Aggreagte and Group By Function
--- DW in the code is nothing but to convert the days of the week
SELECT DATENAME(DW, order_date) as Order_Day, COUNT(DISTINCT order_id) AS Total_Orders
FROM [Pizza DB].dbo.pizza_sales
GROUP BY DATENAME(DW, order_date)

--- We arrange the days of the week starting from Sunday and ending on Saturday, we use a custom sorting order
SELECT
    CASE
        WHEN DATENAME(DW, order_date) = 'Sunday' THEN 1
        WHEN DATENAME(DW, order_date) = 'Monday' THEN 2
        WHEN DATENAME(DW, order_date) = 'Tuesday' THEN 3
        WHEN DATENAME(DW, order_date) = 'Wednesday' THEN 4
        WHEN DATENAME(DW, order_date) = 'Thursday' THEN 5
        WHEN DATENAME(DW, order_date) = 'Friday' THEN 6
        WHEN DATENAME(DW, order_date) = 'Saturday' THEN 7
    END AS Day_Order,
    DATENAME(DW, order_date) AS Order_Day,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM [Pizza DB].dbo.pizza_sales
GROUP BY DATENAME(DW, order_date)
ORDER BY Day_Order;

--- 2. Monthly Trends for Total Orders:
-- Create a line chart that illustrates the hourly trend of a total order throughout the day. 
--- This chart will allow us to identify peak hours or periods of high-order activity
SELECT
    pizza_category,
    SUM(total_price) * 100 / (SELECT SUM(total_price) FROM [Pizza DB].dbo.pizza_sales) AS PCT
FROM
    [Pizza DB].dbo.pizza_sales
GROUP BY
    pizza_category;

--- We added one more step to see the Total Sales
SELECT
    pizza_category,
    SUM(total_price) as Total_Sales, SUM(total_price) * 100 / (SELECT SUM(total_price) FROM [Pizza DB].dbo.pizza_sales) AS PCT
FROM
    [Pizza DB].dbo.pizza_sales
GROUP BY
    pizza_category;

--- We use ROUND() to round the Total_Sales and PCT columns to two decimal places
-- By passing 2 as the second argument to the ROUND() function.
-- This query will provide you with the Total_Sales and PCT columns rounded to two decimal places for each pizza_category
SELECT
    pizza_category,
    ROUND(SUM(total_price), 2) as Total_Sales,
    ROUND(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM [Pizza DB].dbo.pizza_sales), 2) AS PCT
FROM
    [Pizza DB].dbo.pizza_sales
GROUP BY
    pizza_category;

--- We use MONTH(order_date) to extract the month from the order_date column.

-- The WHERE clause filters the data for months between 1 (January) and 12 (December).

--- We also include MONTH(order_date) as Order_Month in the SELECT clause to display the month for each row.

--- The results are grouped by pizza_category and Order_Month, and we use ORDER BY Order_Month to sort the results
--- in chronological order
SELECT
    pizza_category,
    SUM(total_price) as Total_Sales,
    ROUND(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM [Pizza DB].dbo.pizza_sales), 2) AS PCT,
    MONTH(order_date) AS Order_Month
FROM
    [Pizza DB].dbo.pizza_sales
WHERE
    MONTH(order_date) >= 1 AND MONTH(order_date) <= 12
GROUP BY
    pizza_category, MONTH(order_date)
ORDER BY
    Order_Month;

---- We use ROUND(SUM(total_price), 2) to round the Total_Sales column to two decimal places.
SELECT
    pizza_category,
    ROUND(SUM(total_price), 2) as Total_Sales,
    ROUND(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM [Pizza DB].dbo.pizza_sales), 2) AS PCT,
    MONTH(order_date) AS Order_Month
FROM
    [Pizza DB].dbo.pizza_sales
WHERE
    MONTH(order_date) >= 1 AND MONTH(order_date) <= 12
GROUP BY
    pizza_category, MONTH(order_date)
ORDER BY
    Order_Month;

--- Below we only find the order of Peak only the Month of January
	 
SELECT pizza_category, SUM(total_price) as Total_Sales, SUM(total_price) * 100 /
(SELECT SUM(total_price) FROM [Pizza DB].dbo.pizza_sales WHERE MONTH(order_date) = 1) AS PCT 
FROM [Pizza DB].dbo.pizza_sales
WHERE MONTH(order_date) = 1
GROUP BY pizza_category

---- We use a subquery to first calculate the week number, and then in the outer query, 
--- We group and filter the results as needed
SELECT
    pizza_category,
    ROUND(SUM(total_price), 2) as Total_Sales,
    ROUND(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM [Pizza DB].dbo.pizza_sales), 2) AS PCT,
    Order_Week
FROM
    (SELECT
        pizza_category,
        DATEPART(ISO_WEEK, order_date) AS Order_Week,
        total_price
    FROM
        [Pizza DB].dbo.pizza_sales
    WHERE
        DATEPART(ISO_WEEK, order_date) >= 1 AND DATEPART(ISO_WEEK, order_date) <= 52) AS Subquery
GROUP BY
    pizza_category, Order_Week
ORDER BY
    Order_Week;

----- We use DATEPART(DAYOFYEAR, order_date) to calculate the day of the year based on the order_date.

----- The WHERE clause filters the data for day numbers between 1 and 366, covering all days of the year.

----- We include DATEPART(DAYOFYEAR, order_date) as Order_Day in the SELECT clause to display the day of the year for each row.

---- The results are grouped by pizza_category and Order_Day.

----- The ORDER BY Order_Day sorts the results by the day of the year in chronological order
SELECT
    pizza_category,
    ROUND(SUM(total_price), 2) as Total_Sales,
    ROUND(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM [Pizza DB].dbo.pizza_sales), 2) AS PCT,
    Order_Day
FROM
    (SELECT
        pizza_category,
        DATEPART(DAYOFYEAR, order_date) AS Order_Day,
        total_price
    FROM
        [Pizza DB].dbo.pizza_sales
    WHERE
        DATEPART(DAYOFYEAR, order_date) >= 1 AND DATEPART(DAYOFYEAR, order_date) <= 366) AS Subquery
GROUP BY
    pizza_category, Order_Day
ORDER BY
    Order_Day;

--- This SQL code retrieves data on pizza sales, calculates the total sales 
---The percentage of total sales for each pizza size, and presents the results in descending order
--The percentage of total sales. 
SELECT pizza_size, SUM(total_price) as Total_Sales, SUM(total_price) * 100 /
(SELECT SUM(total_price) FROM [Pizza DB].dbo.pizza_sales) AS PCT
FROM [Pizza DB].dbo.pizza_sales
GROUP BY pizza_size
ORDER BY PCT DESC

-- We We use ROUND(SUM(total_price), 2) to round the Total_Sales column to two decimal places.
-- ROUND(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM [Pizza DB].dbo.pizza_sales), 2
-- round the PCT column to two decimal places
SELECT
    pizza_size,
    ROUND(SUM(total_price), 2) as Total_Sales,
    ROUND(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM [Pizza DB].dbo.pizza_sales), 2) AS PCT
FROM
    [Pizza DB].dbo.pizza_sales
GROUP BY
    pizza_size
ORDER BY
    PCT DESC;

--pizza sales data for the first quarter of 2015, grouped by pizza size and ordered by
--- percentage of total sales (PCT) in descending order. This query will provide you with the Total_Sales and PCT
------- rounded to two decimal places 
SELECT
    pizza_size,
    ROUND(SUM(total_price), 2) as Total_Sales,
    ROUND(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM [Pizza DB].dbo.pizza_sales), 2) AS PCT
FROM
    [Pizza DB].dbo.pizza_sales
WHERE
    order_date >= '2015-01-01' AND order_date <= '2015-03-31'
GROUP BY
    pizza_size
ORDER BY
    PCT DESC;


SELECT pizza_name,SUM(total_price) AS Total_Revenue FROM [Pizza DB].dbo.pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC


------ TOP 5 limits the result set to the top 5 rows based on total revenue.
---Select the pizza_name and calculate the total revenue using SUM(total_price) for each pizza.

--- GROUP BY clause groups the results by pizza_name, aggregating the total revenue for each pizza.

--- ORDER BY clause sorts the results in descending order based on the Total_Revenue column, 
------ pizzas with the highest total revenue will appear at the top.
SELECT TOP 5
    pizza_name,
    SUM(total_price) AS Total_Revenue
FROM
    [Pizza DB].dbo.pizza_sales
GROUP BY
    pizza_name
ORDER BY
    Total_Revenue DESC;


---- Let get the bottom 5 (Least Five of Total_Revenue)

SELECT TOP 5
    pizza_name,
    SUM(total_price) AS Total_Revenue
FROM
    [Pizza DB].dbo.pizza_sales
GROUP BY
    pizza_name
ORDER BY
    Total_Revenue ASC

--- We find the best quantity of ordered
SELECT TOP 5
    pizza_name,
    SUM(quantity) AS Total_Quantity
FROM
    [Pizza DB].dbo.pizza_sales
GROUP BY
    pizza_name
ORDER BY
    Total_Quantity DESC


---We investigate the least quantity ordered
SELECT TOP 5
    pizza_name,
    SUM(quantity) AS Total_Quantity
FROM
    [Pizza DB].dbo.pizza_sales
GROUP BY
    pizza_name
ORDER BY
    Total_Quantity ASC

SELECT TOP 5
    pizza_name,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM
    [Pizza DB].dbo.pizza_sales
GROUP BY
    pizza_name
ORDER BY
    Total_Orders DESC

SELECT TOP 5
    pizza_name,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM
    [Pizza DB].dbo.pizza_sales
GROUP BY
    pizza_name
ORDER BY
    Total_Orders ASC


SELECT TOP 5 pizza_name, SUM(quantity) as Total_Pizzas_Sold
FROM [Pizza DB].dbo.pizza_sales
WHERE MONTH(order_date) = 8
GROUP BY pizza_name
ORDER BY SUM(quantity) DESC

SELECT TOP 5 pizza_name, SUM(quantity) as Total_Pizzas_Sold
FROM [Pizza DB].dbo.pizza_sales
WHERE MONTH(order_date) = 8
GROUP BY pizza_name
ORDER BY SUM(quantity) ASC