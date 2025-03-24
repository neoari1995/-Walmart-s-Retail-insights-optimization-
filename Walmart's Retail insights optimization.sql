SELECT * FROM walmartsales;

Task 1: Identifying the Top Branch by Sales Growth Rate.
Walmart wants to identify which branch has exhibited the highest sales growth over time. Analyze the total sales
for each branch and compare the growth rate across months to find the top performer.

a) Walmart wants to identify which branch has exhibited the highest sales growth over time.

The syntax is:

WITH MonthlySales AS (SELECT Branch, DATE_FORMAT(Date, '%Y-%m') AS SalesMonth, SUM(Total) AS TotalSales
FROM walmartsales GROUP BY Branch, SalesMonth), SalesGrowth AS (SELECT Branch, SalesMonth, TotalSales,
LAG(TotalSales) OVER (PARTITION BY Branch ORDER BY SalesMonth) AS PreviousMonthSales,
((TotalSales - LAG(TotalSales) OVER (PARTITION BY Branch ORDER BY SalesMonth)) / 
LAG(TotalSales) OVER (PARTITION BY Branch ORDER BY SalesMonth)) * 100 AS GrowthRate FROM MonthlySales)
SELECT Branch, ROUND(AVG(GrowthRate), 2) AS AvgGrowthRate FROM SalesGrowth WHERE GrowthRate IS NOT NULL
GROUP BY Branch ORDER BY AvgGrowthRate DESC LIMIT 1;

Total sales for each brunch is:

SELECT Branch, ROUND(SUM(Total), 2) AS TotalSales FROM walmartsales GROUP BY Branch ORDER BY TotalSales DESC;

Task 2: Finding the Most Profitable Product Line for Each Branch.

Walmart needs to determine which product line contributes the highest profit to each branch.The profit margin
should be calculated based on the difference between the gross income and cost of goods sold.


SELECT Branch, Product_line, ROUND(SUM(gross_income - cogs), 2) AS Profit_Margin FROM walmartsales
GROUP BY Branch, Product_line ORDER BY Branch, Profit_Margin DESC;


Task 3: Analyzing Customer Segmentation Based on Spending.

Walmart wants to segment customers based on their average spending behavior. Classify customers into three
tiers: High, Medium, and Low spenders based on their total purchase amounts.

a) Walmart wants to segment customers based on their average spending behavior.

The syntax is: 

SELECT Customer_ID, ROUND(AVG(Total), 2) AS average_spending FROM walmartsales GROUP BY Customer_ID ORDER BY 
average_spending DESC;

b) Classify customers into three tiers: High, Medium, and Low spenders based on their total purchase amounts.

The syntax is:

SELECT Customer_ID, ROUND(SUM(Total), 2) AS total_spent, CASE WHEN SUM(Total) > 21000 THEN 'High'
WHEN SUM(Total) BETWEEN 20000 AND 18000 THEN 'Medium' ELSE 'Low' END AS spending_tier FROM walmartsales
GROUP BY Customer_ID ORDER BY total_spent DESC;

Task 4: Detecting Anomalies in Sales Transactions (6 Marks)

Walmart suspects that some transactions have unusually high or low sales compared to the average for the
product line. Identify these anomalies.

The syntax is:

WITH avg_sales AS (SELECT Product_line, ROUND(AVG(Total), 2) AS avg_total_sales FROM walmartsales GROUP BY 
Product_line) SELECT ws.Invoice_ID, ws.Product_line, ROUND(ws.Total, 2) AS Total, avg_sales.avg_total_sales,
ROUND(ABS(ws.Total - avg_sales.avg_total_sales), 2) AS sales_deviation FROM walmartsales ws JOIN 
avg_sales ON ws.Product_line = avg_sales.Product_line WHERE 
ABS(ws.Total - avg_sales.avg_total_sales) > (avg_sales.avg_total_sales * 0.5);

Task 5: Most Popular Payment Method by City.

Walmart needs to determine the most popular payment method in each city to tailor marketing strategies.

The syntax is:

SELECT City, Payment, COUNT(Payment) AS Payment_Count FROM walmartsales GROUP BY City, Payment
ORDER BY City, Payment_Count DESC;

Task 6: Monthly Sales Distribution by Gender.

Walmart wants to understand the sales distribution between male and female customers on a monthly basis.

The syntax is:

SELECT YEAR(Date) AS Year, MONTH(Date) AS Month, Gender, ROUND(SUM(Total), 2) AS Total_Sales,
SUM(Quantity) AS Total_Quantity, ROUND(AVG(Rating), 2) AS Average_Rating FROM walmartsales GROUP BY
YEAR(Date), MONTH(Date), Gender ORDER BY Year, Month, Gender;

Task 7: Best Product Line by Customer Type.

Walmart wants to know which product lines are preferred by different customer types(Member vs. Normal).

The syntax is:

SELECT Customer_type, Product_line, COUNT(*) AS Purchase_Count
FROM walmartsales GROUP BY Customer_type, Product_line
ORDER BY Customer_type, Purchase_Count DESC;

Task 8: Identifying Repeat Customers.

Walmart needs to identify customers who made repeat purchases within a specific time frame (e.g., within 30 days).

The syntax is:

SELECT DISTINCT w1.Customer_ID, w1.City, COUNT(w1.Invoice_ID) AS purchase_count FROM walmartsales w1
JOIN walmartsales w2 ON w1.Customer_ID = w2.Customer_ID AND w1.Invoice_ID <> w2.Invoice_ID 
AND ABS(DATEDIFF(w1.Date, w2.Date)) <= 30 GROUP BY w1.Customer_ID, w1.City HAVING purchase_count > 1
ORDER BY purchase_count DESC;

Task 9: Finding Top 5 Customers by Sales Volume.

Walmart wants to reward its top 5 customers who have generated the most sales Revenue.

The syntax is:

SELECT Customer_ID, City, ROUND(SUM(Total), 2) AS Total_Revenue FROM walmartsales
GROUP BY Customer_ID, City ORDER BY Total_Revenue DESC LIMIT 5;

Task 10: Analyzing Sales Trends by Day of the Week.

Walmart wants to analyze the sales patterns to determine which day of the week brings the highest sales.

The syntax is:

SELECT DAYNAME(Date) AS Day_of_Week, ROUND(SUM(Total), 2) AS Total_Sales FROM walmartsales
GROUP BY DAYNAME(Date) ORDER BY Total_Sales DESC;
