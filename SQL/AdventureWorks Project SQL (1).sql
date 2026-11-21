USE AdventureWorks;
-- Q0: Union of FactInternetSales and FactInternetSales_New

SELECT *
FROM FactInternetSales
UNION
SELECT *
FROM FactInternetSales_New;

-- Q1: Lookup Product Name from Product sheet to Sales sheet

SELECT
    s.ProductKey,
    p.EnglishProductName AS ProductName
FROM Sales AS s
LEFT JOIN DimProduct AS p
    ON s.ProductKey = p.ProductKey;
    
    -- Q2: Lookup CustomerFullName and Unit Price

SELECT
    s.SalesOrderNumber,
    s.CustomerKey,
    c.`Customer Name` AS CustomerFullName,
    s.ProductKey,
    p.UnitPrice AS UnitPrice
FROM Sales AS s
LEFT JOIN DimCustomer AS c
    ON s.CustomerKey = c.CustomerKey
LEFT JOIN DimProduct AS p
    ON s.ProductKey = p.ProductKey;
    
    -- Q3: Create Date Field

SELECT
    OrderDateKey,
    STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d') AS DateField
FROM Sales;
-- Q3.A: Calculate Year

SELECT
    OrderDateKey,
    YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS Year
FROM Sales;

-- Q3.B: Calculate MonthNo

SELECT
    OrderDateKey,
    MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS MonthNo
FROM Sales;

-- Q3.C: Calculate MonthFullName

SELECT
    OrderDateKey,
    MONTHNAME(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS MonthFullName
FROM Sales;

-- Q3.D: Calculate Quarter

SELECT
    OrderDateKey,
    CONCAT(
        'Q',
        QUARTER(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d'))
    ) AS Quarter
FROM Sales;

-- Q3.E: Calculate YearMonth

SELECT
    OrderDateKey,
    DATE_FORMAT(
        STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d'),
        '%Y-%b'
    ) AS YearMonth
FROM Sales;

-- Q3.F: Calculate WeekdayNo

SELECT
    OrderDateKey,
    DAYOFWEEK(
        STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')
    ) AS WeekdayNo
FROM Sales;

-- Q3.G: Calculate WeekdayName

SELECT
    OrderDateKey,
    DAYNAME(
        STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')
    ) AS WeekdayName
FROM Sales;

-- Q3.H: Calculate FinancialMonth

SELECT
    OrderDateKey,
    CASE
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) >= 4
            THEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) - 3
        ELSE MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) + 9
    END AS FinancialMonth
FROM Sales;

-- Q3.I: Calculate FinancialQuarter

SELECT
    OrderDateKey,
    CASE
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 4 AND 6
            THEN 'Q1'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 7 AND 9
            THEN 'Q2'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 10 AND 12
            THEN 'Q3'
        ELSE 'Q4'
    END AS FinancialQuarter
FROM Sales;

-- Q4: Calculate Sales Amount

SELECT
    UnitPrice,
    OrderQuantity,
    UnitPriceDiscountPct,
    UnitPrice * OrderQuantity * (1 - UnitPriceDiscountPct) AS SalesAmount
FROM Sales;

-- Q5: Calculate Production Cost

SELECT
    ProductStandardCost AS UnitCost,
    OrderQuantity,
    ProductStandardCost * OrderQuantity AS ProductionCost
FROM Sales;

-- Q6: Calculate Profit

SELECT
    UnitPrice * OrderQuantity * (1 - UnitPriceDiscountPct) AS SalesAmount,
    ProductStandardCost * OrderQuantity AS ProductionCost,
    (UnitPrice * OrderQuantity * (1 - UnitPriceDiscountPct))
        - (ProductStandardCost * OrderQuantity) AS Profit
FROM Sales;

-- Q7: Month-wise Sales with Year

SELECT
    YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS Year,
    MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS MonthNo,
    MONTHNAME(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS MonthFullName,
    SUM(UnitPrice * OrderQuantity * (1 - UnitPriceDiscountPct)) AS Sales
FROM Sales
GROUP BY
    YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')),
    MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')),
    MONTHNAME(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d'))
ORDER BY
    YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')),
    MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d'));
    -- Q8: Year-wise Sales

SELECT
    YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS Year,
    SUM(UnitPrice * OrderQuantity * (1 - UnitPriceDiscountPct)) AS Sales
FROM Sales
GROUP BY
    YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d'))
ORDER BY
    Year;
    
    -- Q9: Month-wise Sales

SELECT
    MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS MonthNo,
    MONTHNAME(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS MonthFullName,
    SUM(UnitPrice * OrderQuantity * (1 - UnitPriceDiscountPct)) AS Sales
FROM Sales
GROUP BY
    MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')),
    MONTHNAME(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d'))
ORDER BY
    MonthNo;
-- Q10: Quarter-wise Sales

SELECT
    CONCAT('Q', QuarterNo) AS Quarter,
    Sales
FROM
(
    SELECT
        QUARTER(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS QuarterNo,
        SUM(UnitPrice * OrderQuantity * (1 - UnitPriceDiscountPct)) AS Sales
    FROM Sales
    GROUP BY
        QUARTER(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d'))
) AS Q
ORDER BY
    QuarterNo;
    
    -- Q11: Sales Amount and Production Cost

SELECT
    SUM(UnitPrice * OrderQuantity * (1 - UnitPriceDiscountPct)) AS SalesAmount,
    SUM(ProductStandardCost * OrderQuantity) AS ProductionCost
FROM Sales;

-- Q12(a): Product-wise Sales

SELECT
    ProductName,
    SUM(UnitPrice * OrderQuantity * (1 - UnitPriceDiscountPct)) AS Sales
FROM Sales
GROUP BY ProductName
ORDER BY Sales DESC;

-- Q12(b): Customer-wise Sales

SELECT
    CustomerFullName,
    SUM(UnitPrice * OrderQuantity * (1 - UnitPriceDiscountPct)) AS Sales
FROM Sales
GROUP BY CustomerFullName
ORDER BY Sales DESC;

-- Q12(c): Region-wise Sales

SELECT
    t.SalesTerritoryRegion AS Region,
    SUM(s.UnitPrice * s.OrderQuantity * (1 - s.UnitPriceDiscountPct)) AS Sales
FROM Sales AS s
INNER JOIN DimSalesTerritory AS t
    ON s.SalesTerritoryKey = t.SalesTerritoryKey
GROUP BY
    t.SalesTerritoryRegion
ORDER BY
    Sales DESC;