-- Check if the table was imported completely
SELECT COUNT(*) FROM sales_data;
-- Inspecting data
SELECT * FROM sales_data;

-- Checking unique values
SELECT DISTINCT STATUS FROM sales_data; 
SELECT DISTINCT YEAR_ID FROM sales_data;
SELECT DISTINCT PRODUCTLINE FROM sales_data; -- Plot
SELECT DISTINCT COUNTRY FROM sales_data; -- Plot
SELECT DISTINCT DEALSIZE FROM sales_data; -- Plot
SELECT DISTINCT TERRITORY FROM sales_data;

-- Exploration Analysis
-- Grouping sales by PRODUCTLINE
SELECT PRODUCTLINE, SUM(SALES) REVENUE
FROM sales_data
GROUP BY PRODUCTLINE
ORDER BY 2 DESC;

-- Revenue by COUNTRY
SELECT COUNTRY, SUM(sales) REVENUE
FROM sales_data
GROUP BY COUNTRY
ORDER BY 2 DESC;

-- Revenue by CITY
SELECT CITY, SUM(sales) REVENUE
FROM sales_data
GROUP BY CITY
ORDER BY 2 DESC;

-- Revenue by PRODUCTCODE
SELECT PRODUCTCODE, SUM(sales) REVENUE
FROM sales_data
GROUP BY PRODUCTCODE
ORDER BY 2 DESC;

-- Grouping sales by DEALSIZE
SELECT DEALSIZE, SUM(SALES) REVENUE
FROM sales_data
GROUP BY DEALSIZE
ORDER BY 2 DESC;

-- Grouping sales by COUNTRY AND PRODUCTLINE
SELECT COUNTRY, PRODUCTLINE, sum(sales) Revenue
FROM sales_data
GROUP BY  COUNTRY, PRODUCTLINE
ORDER BY 3 DESC;

-- Grouping sales by YEAR
SELECT YEAR_ID, SUM(SALES) REVENUE
FROM sales_data
GROUP BY YEAR_ID
ORDER BY 2 DESC;

-- There is a big difference between sales in 2005 and the other years. Let's see if the operate all year arround.
SELECT DISTINCT MONTH_ID FROM sales_data
WHERE YEAR_ID = 2005; -- Operation: Jan-May

SELECT DISTINCT MONTH_ID FROM sales_data
WHERE YEAR_ID = 2004; -- Operation: Jan-Dec

SELECT DISTINCT MONTH_ID FROM sales_data
WHERE YEAR_ID = 2003; -- Operation: Jan-Dec


-- Best month for sales per year (not taking into account 2005 because they didn't operate all year)
SELECT  MONTH_ID, SUM(sales) Revenue, COUNT(ORDERNUMBER) Frequency
FROM sales_data
WHERE YEAR_ID = 2003
GROUP BY  MONTH_ID
ORDER BY 2 DESC;

SELECT  MONTH_ID, SUM(sales) Revenue, COUNT(ORDERNUMBER) Frequency
FROM sales_data
WHERE YEAR_ID = 2004
GROUP BY  MONTH_ID
ORDER BY 2 DESC;

-- November seems to be the best month. What is the best selling product in Nov?
SELECT  MONTH_ID, PRODUCTLINE, SUM(sales) Revenue, COUNT(ORDERNUMBER)
FROM sales_data
WHERE YEAR_ID = 2004 AND MONTH_ID = 11 
GROUP BY  MONTH_ID, PRODUCTLINE
ORDER BY 3 DESC;

-- Best customers (RFM Analysis)
WITH rfm AS
(
	SELECT
			CUSTOMERNAME,
			SUM(SALES) Monetary_Value,
			AVG(SALES) Avg_Monetary_Value,
			COUNT(ORDERNUMBER) Frequency,
			MAX(ORDERDATE) Last_Order_Date,
			(SELECT MAX(ORDERDATE) from sales_data) Max_Order_Date,
			DATEDIFF((SELECT MAX(ORDERDATE) from sales_data), MAX(ORDERDATE)) Recency
	FROM sales_data
	GROUP BY CUSTOMERNAME
 ),
 rfm_calc AS
 (
 -- Grouping values
	 SELECT r.*,
			NTILE(3) OVER (ORDER BY Recency DESC) R,
			NTILE(3) OVER (ORDER BY Frequency) F,
			NTILE(3) OVER (ORDER BY Monetary_Value) M
	 FROM rfm r
  )      
SELECT 
	c.*, R + F + M AS RFM_Cell,
    concat(R, F, M) AS RFM_Value
FROM rfm_calc c;


