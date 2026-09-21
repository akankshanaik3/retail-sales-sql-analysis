-- ============================================================
-- RETAIL SALES SQL ANALYSIS
-- ============================================================
-- Database: retail_sales_analysis
-- Table: retail_sales
-- Dataset: 1,000 retail transactions
-- Tool: MySQL
-- ============================================================


-- ============================================================
-- 1. DATABASE SETUP
-- ============================================================

CREATE DATABASE IF NOT EXISTS retail_sales_analysis;

USE retail_sales_analysis;


-- ============================================================
-- 2. DATA VALIDATION
-- ============================================================

-- Check total number of records
SELECT COUNT(*) AS total_records
FROM retail_sales;


-- Check sample records
SELECT *
FROM retail_sales
LIMIT 10;


-- ============================================================
-- 3. OVERALL SALES ANALYSIS
-- ============================================================

-- Query 1: Total Sales
SELECT
    SUM(Total_Sales) AS Total_Sales
FROM retail_sales;


-- Query 2: Total Profit
SELECT
    SUM(Profit) AS Total_Profit
FROM retail_sales;


-- Query 3: Total Orders
SELECT
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM retail_sales;


-- Query 4: Total Quantity Sold
SELECT
    SUM(Quantity) AS Total_Quantity
FROM retail_sales;


-- Query 5: Overall Profit Margin
SELECT
    ROUND(
        SUM(Profit) / SUM(Total_Sales) * 100,
        2
    ) AS Profit_Margin_Percent
FROM retail_sales;


-- ============================================================
-- 4. CATEGORY ANALYSIS
-- ============================================================

-- Query 6: Sales by Category
SELECT
    Category,
    SUM(Total_Sales) AS Total_Sales
FROM retail_sales
GROUP BY Category
ORDER BY Total_Sales DESC;


-- Query 7: Profit by Category
SELECT
    Category,
    SUM(Profit) AS Total_Profit
FROM retail_sales
GROUP BY Category
ORDER BY Total_Profit DESC;


-- Query 8: Complete Category Performance
SELECT
    Category,
    COUNT(DISTINCT Order_ID) AS Orders,
    SUM(Quantity) AS Quantity_Sold,
    ROUND(SUM(Total_Sales), 2) AS Sales,
    ROUND(SUM(Profit), 2) AS Profit,
    ROUND(
        SUM(Profit) / SUM(Total_Sales) * 100,
        2
    ) AS Profit_Margin
FROM retail_sales
GROUP BY Category
ORDER BY Sales DESC;


-- ============================================================
-- 5. REGIONAL ANALYSIS
-- ============================================================

-- Query 9: Sales by Region
SELECT
    Region,
    SUM(Total_Sales) AS Total_Sales
FROM retail_sales
GROUP BY Region
ORDER BY Total_Sales DESC;


-- Query 10: Regional Sales and Profit Performance
SELECT
    Region,
    ROUND(SUM(Total_Sales), 2) AS Sales,
    ROUND(SUM(Profit), 2) AS Profit,
    ROUND(
        SUM(Profit) / SUM(Total_Sales) * 100,
        2
    ) AS Profit_Margin
FROM retail_sales
GROUP BY Region
ORDER BY Profit DESC;


-- ============================================================
-- 6. PRODUCT ANALYSIS
-- ============================================================

-- Query 11: Top 10 Products by Sales
SELECT
    Product,
    ROUND(SUM(Total_Sales), 2) AS Total_Sales
FROM retail_sales
GROUP BY Product
ORDER BY Total_Sales DESC
LIMIT 10;


-- Query 12: Top 10 Products by Profit
SELECT
    Product,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM retail_sales
GROUP BY Product
ORDER BY Total_Profit DESC
LIMIT 10;


-- ============================================================
-- 7. CUSTOMER ANALYSIS
-- ============================================================

-- Query 13: Top 10 Customers by Sales
SELECT
    Customer_ID,
    Customer_Name,
    ROUND(SUM(Total_Sales), 2) AS Total_Sales
FROM retail_sales
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Sales DESC
LIMIT 10;


-- Query 14: Repeat Customers
SELECT
    Customer_ID,
    Customer_Name,
    COUNT(DISTINCT Order_ID) AS Number_of_Orders
FROM retail_sales
GROUP BY Customer_ID, Customer_Name
HAVING COUNT(DISTINCT Order_ID) > 1
ORDER BY Number_of_Orders DESC;


-- ============================================================
-- 8. PAYMENT ANALYSIS
-- ============================================================

-- Query 15: Sales by Payment Mode
SELECT
    Payment_Mode,
    COUNT(DISTINCT Order_ID) AS Orders,
    ROUND(SUM(Total_Sales), 2) AS Sales
FROM retail_sales
GROUP BY Payment_Mode
ORDER BY Sales DESC;


-- ============================================================
-- 9. DELIVERY ANALYSIS
-- ============================================================

-- Query 16: Delivery Status Analysis
SELECT
    Delivery_Status,
    COUNT(DISTINCT Order_ID) AS Orders,
    ROUND(
        COUNT(DISTINCT Order_ID) * 100.0 /
        (
            SELECT COUNT(DISTINCT Order_ID)
            FROM retail_sales
        ),
        2
    ) AS Percentage
FROM retail_sales
GROUP BY Delivery_Status
ORDER BY Orders DESC;


-- ============================================================
-- 10. TIME-BASED ANALYSIS
-- ============================================================

-- Query 17: Monthly Sales
SELECT
    YEAR(Order_Date) AS Year,
    MONTH(Order_Date) AS Month,
    ROUND(SUM(Total_Sales), 2) AS Monthly_Sales
FROM retail_sales
GROUP BY
    YEAR(Order_Date),
    MONTH(Order_Date)
ORDER BY
    Year,
    Month;


-- Query 18: Monthly Profit
SELECT
    YEAR(Order_Date) AS Year,
    MONTH(Order_Date) AS Month,
    ROUND(SUM(Profit), 2) AS Monthly_Profit
FROM retail_sales
GROUP BY
    YEAR(Order_Date),
    MONTH(Order_Date)
ORDER BY
    Year,
    Month;


-- ============================================================
-- 11. ADVANCED SQL
-- ============================================================

-- Query 19: Rank Products Within Each Category
WITH product_sales AS (
    SELECT
        Category,
        Product,
        SUM(Total_Sales) AS Sales
    FROM retail_sales
    GROUP BY
        Category,
        Product
)

SELECT
    Category,
    Product,
    ROUND(Sales, 2) AS Sales,
    DENSE_RANK() OVER (
        PARTITION BY Category
        ORDER BY Sales DESC
    ) AS Product_Rank
FROM product_sales
ORDER BY
    Category,
    Product_Rank;


-- Query 20: Top 3 Products in Each Category
WITH product_sales AS (
    SELECT
        Category,
        Product,
        SUM(Total_Sales) AS Sales
    FROM retail_sales
    GROUP BY
        Category,
        Product
),

ranked_products AS (
    SELECT
        Category,
        Product,
        Sales,
        DENSE_RANK() OVER (
            PARTITION BY Category
            ORDER BY Sales DESC
        ) AS Product_Rank
    FROM product_sales
)

SELECT
    Category,
    Product,
    ROUND(Sales, 2) AS Sales,
    Product_Rank
FROM ranked_products
WHERE Product_Rank <= 3
ORDER BY
    Category,
    Product_Rank;


-- ============================================================
-- END OF RETAIL SALES SQL ANALYSIS
-- ============================================================
