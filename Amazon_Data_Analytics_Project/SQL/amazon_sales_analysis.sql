CREATE DATABASE amazon_analytics;

USE amazon_analytics;

CREATE TABLE sales (
    OrderID VARCHAR(20) PRIMARY KEY,
    OrderDate DATE,
    CustomerID VARCHAR(20),
    Product VARCHAR(50),
    Category VARCHAR(50),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    Sales DECIMAL(12,2),
    City VARCHAR(50),
    PaymentMethod VARCHAR(30),
    OrderStatus VARCHAR(30)
);

SELECT COUNT(*) AS Total_Rows
FROM sales;

SELECT *
FROM sales
LIMIT 10;

SELECT SUM(Sales) AS Total_Revenue
FROM sales;

SELECT COUNT(*) AS Total_Orders
FROM sales;

SELECT COUNT(DISTINCT CustomerID) AS Total_Customers
FROM sales;

SELECT
    Product,
    SUM(Sales) AS Total_Revenue
FROM sales
GROUP BY Product
ORDER BY Total_Revenue DESC;

SELECT
    Category,
    SUM(Sales) AS Total_Revenue
FROM sales
GROUP BY Category
ORDER BY Total_Revenue DESC;

SELECT
    City,
    SUM(Sales) AS Total_Revenue
FROM sales
GROUP BY City
ORDER BY Total_Revenue DESC;

SELECT
    SUM(Quantity) AS Total_Quantity_Sold
FROM sales;

SELECT
    ROUND(SUM(Sales) / COUNT(DISTINCT OrderID), 2) AS Average_Order_Value
FROM sales;


SELECT
    OrderStatus,
    COUNT(*) AS Total_Orders
FROM sales
GROUP BY OrderStatus
ORDER BY Total_Orders DESC;

SELECT
    PaymentMethod,
    COUNT(*) AS Total_Orders,
    SUM(Sales) AS Total_Revenue
FROM sales
GROUP BY PaymentMethod
ORDER BY Total_Revenue DESC;

SELECT
    YEAR(OrderDate) AS Year,
    MONTH(OrderDate) AS Month,
    SUM(Sales) AS Monthly_Revenue
FROM sales
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year, Month;

SELECT
    YEAR(OrderDate) AS Year,
    MONTH(OrderDate) AS Month,
    COUNT(DISTINCT OrderID) AS Total_Orders
FROM sales
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year, Month;

SELECT
    CustomerID,
    SUM(Sales) AS Total_Spent
FROM sales
GROUP BY CustomerID
ORDER BY Total_Spent DESC
LIMIT 10;

SELECT
    CustomerID,
    COUNT(DISTINCT OrderID) AS Total_Orders,
    SUM(Sales) AS Total_Spent
FROM sales
GROUP BY CustomerID
ORDER BY Total_Orders DESC
LIMIT 10;

SELECT
    Product,
    SUM(Sales) AS Total_Revenue
FROM sales
GROUP BY Product
ORDER BY Total_Revenue DESC
LIMIT 5;

SELECT
    Product,
    SUM(Quantity) AS Units_Sold
FROM sales
GROUP BY Product
ORDER BY Units_Sold DESC
LIMIT 5;

SELECT
    OrderID,
    Sales,
    CASE
        WHEN Sales >= 30000 THEN 'High Value'
        WHEN Sales >= 10000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Order_Value_Category
FROM sales
LIMIT 20;

SELECT
    CASE
        WHEN Sales >= 30000 THEN 'High Value'
        WHEN Sales >= 10000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Order_Value_Category,
    COUNT(*) AS Total_Orders,
    SUM(Sales) AS Total_Revenue
FROM sales
GROUP BY Order_Value_Category
ORDER BY Total_Revenue DESC;

CREATE TABLE customers (
    CustomerID VARCHAR(20) PRIMARY KEY,
    CustomerName VARCHAR(100),
    CustomerType VARCHAR(30)
);

INSERT INTO customers (CustomerID, CustomerName, CustomerType)
SELECT DISTINCT
    CustomerID,
    CONCAT('Customer_', CustomerID),
    CASE
        WHEN CAST(SUBSTRING(CustomerID, 2) AS UNSIGNED) <= 1170
            THEN 'Regular'
        WHEN CAST(SUBSTRING(CustomerID, 2) AS UNSIGNED) <= 1340
            THEN 'Premium'
        ELSE 'New'
    END
FROM sales;

SELECT *
FROM customers
LIMIT 10;

SELECT
    s.OrderID,
    s.Product,
    s.Sales,
    c.CustomerName,
    c.CustomerType
FROM sales s
JOIN customers c
    ON s.CustomerID = c.CustomerID
LIMIT 20;

SELECT
    c.CustomerType,
    COUNT(DISTINCT s.CustomerID) AS Customers,
    SUM(s.Sales) AS Total_Revenue
FROM sales s
JOIN customers c
    ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerType
ORDER BY Total_Revenue DESC;

WITH city_revenue AS (
    SELECT
        City,
        SUM(Sales) AS Total_Revenue
    FROM sales
    GROUP BY City
)
SELECT *
FROM city_revenue
ORDER BY Total_Revenue DESC
LIMIT 5;

WITH product_revenue AS (
    SELECT
        Product,
        SUM(Sales) AS Total_Revenue
    FROM sales
    GROUP BY Product
)
SELECT
    Product,
    Total_Revenue,
    RANK() OVER (ORDER BY Total_Revenue DESC) AS Revenue_Rank
FROM product_revenue;

SELECT
    City,
    SUM(Sales) AS Total_Revenue,
    RANK() OVER (ORDER BY SUM(Sales) DESC) AS City_Rank
FROM sales
GROUP BY City;

WITH category_sales AS (
    SELECT
        Category,
        SUM(Sales) AS Revenue
    FROM sales
    GROUP BY Category
)
SELECT
    Category,
    Revenue,
    ROUND(
        Revenue * 100.0 / SUM(Revenue) OVER (),
        2
    ) AS Revenue_Percentage
FROM category_sales
ORDER BY Revenue DESC;

SELECT
    OrderStatus,
    COUNT(*) AS Total_Orders,
    SUM(Sales) AS Revenue
FROM sales
WHERE OrderStatus IN ('Returned', 'Cancelled')
GROUP BY OrderStatus;

SELECT
    ROUND(
        SUM(CASE
            WHEN OrderStatus IN ('Returned', 'Cancelled')
            THEN 1 ELSE 0
        END) * 100.0 / COUNT(*),
        2
    ) AS Cancelled_Returned_Percentage
FROM sales;