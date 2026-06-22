"""Reference solutions written for Microsoft SQL Server."""


def q01_select_all_products() -> str:
    return "SELECT * FROM Products ORDER BY ProductId;"


def q02_select_product_columns() -> str:
    return "SELECT ProductName, UnitPrice FROM Products ORDER BY ProductName;"


def q03_active_products() -> str:
    return "SELECT ProductId, ProductName, UnitPrice FROM Products WHERE IsActive = 1 ORDER BY ProductId;"


def q04_products_in_price_range() -> str:
    return """SELECT ProductId, ProductName, UnitPrice
FROM Products
WHERE UnitPrice BETWEEN 1000 AND 5000
ORDER BY UnitPrice DESC, ProductId;"""


def q05_product_name_search() -> str:
    return """SELECT ProductId, ProductName
FROM Products
WHERE ProductName LIKE N'%SQL%'
ORDER BY ProductId;"""


def q06_distinct_customer_cities() -> str:
    return "SELECT DISTINCT City FROM Customers WHERE City IS NOT NULL ORDER BY City;"


def q07_recent_orders() -> str:
    return "SELECT TOP (5) * FROM Orders ORDER BY OrderDate DESC, OrderId DESC;"


def q08_customer_display_name() -> str:
    return """SELECT CustomerId, CONCAT(LastName, N' ', FirstName) AS DisplayName
FROM Customers
ORDER BY CustomerId;"""


def q09_order_amounts() -> str:
    return """SELECT OrderId, ProductId, Quantity, UnitPrice,
       Quantity * UnitPrice AS LineAmount
FROM OrderDetails
ORDER BY OrderId, ProductId;"""


def q10_products_with_category() -> str:
    return """SELECT p.ProductId, p.ProductName, c.CategoryName
FROM Products AS p
INNER JOIN Categories AS c ON c.CategoryId = p.CategoryId
ORDER BY p.ProductId;"""


def q11_customers_and_orders() -> str:
    return """SELECT c.CustomerId, c.LastName, c.FirstName, o.OrderId, o.OrderDate
FROM Customers AS c
LEFT JOIN Orders AS o ON o.CustomerId = c.CustomerId
ORDER BY c.CustomerId, o.OrderDate, o.OrderId;"""


def q12_order_detail_report() -> str:
    return """SELECT o.OrderId, p.ProductName, od.Quantity, od.UnitPrice,
       od.Quantity * od.UnitPrice AS LineAmount
FROM Orders AS o
INNER JOIN OrderDetails AS od ON od.OrderId = o.OrderId
INNER JOIN Products AS p ON p.ProductId = od.ProductId
ORDER BY o.OrderId, p.ProductId;"""


def q13_product_count_by_category() -> str:
    return """SELECT c.CategoryId, c.CategoryName, COUNT(p.ProductId) AS ProductCount
FROM Categories AS c
LEFT JOIN Products AS p ON p.CategoryId = c.CategoryId
GROUP BY c.CategoryId, c.CategoryName
ORDER BY c.CategoryId;"""


def q14_order_total_by_order() -> str:
    return """SELECT o.OrderId, SUM(od.Quantity * od.UnitPrice) AS OrderTotal
FROM Orders AS o
INNER JOIN OrderDetails AS od ON od.OrderId = o.OrderId
GROUP BY o.OrderId
ORDER BY o.OrderId;"""


def q15_large_order_customers() -> str:
    return """SELECT c.CustomerId, c.LastName, c.FirstName,
       SUM(od.Quantity * od.UnitPrice) AS TotalAmount
FROM Customers AS c
INNER JOIN Orders AS o ON o.CustomerId = c.CustomerId
INNER JOIN OrderDetails AS od ON od.OrderId = o.OrderId
GROUP BY c.CustomerId, c.LastName, c.FirstName
HAVING SUM(od.Quantity * od.UnitPrice) >= 10000
ORDER BY TotalAmount DESC, c.CustomerId;"""


def q16_products_above_average_price() -> str:
    return """SELECT ProductId, ProductName, UnitPrice
FROM Products
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products)
ORDER BY UnitPrice DESC, ProductId;"""


def q17_customers_without_orders() -> str:
    return """SELECT c.CustomerId, c.LastName, c.FirstName
FROM Customers AS c
WHERE NOT EXISTS (
    SELECT 1 FROM Orders AS o WHERE o.CustomerId = c.CustomerId
)
ORDER BY c.CustomerId;"""


def q18_rank_products_by_category() -> str:
    return """SELECT ProductId, ProductName, CategoryId, UnitPrice,
       DENSE_RANK() OVER (
           PARTITION BY CategoryId ORDER BY UnitPrice DESC
       ) AS PriceRank
FROM Products
ORDER BY CategoryId, PriceRank, ProductId;"""


def q19_monthly_sales() -> str:
    return """SELECT CONVERT(char(7), o.OrderDate, 120) AS SalesMonth,
       SUM(od.Quantity * od.UnitPrice) AS SalesAmount
FROM Orders AS o
INNER JOIN OrderDetails AS od ON od.OrderId = o.OrderId
GROUP BY CONVERT(char(7), o.OrderDate, 120)
ORDER BY SalesMonth;"""


def q20_customer_sales_summary() -> str:
    return """WITH CustomerSales AS (
    SELECT c.CustomerId, c.LastName, c.FirstName,
           COUNT(DISTINCT o.OrderId) AS OrderCount,
           COALESCE(SUM(od.Quantity * od.UnitPrice), 0) AS TotalAmount
    FROM Customers AS c
    LEFT JOIN Orders AS o ON o.CustomerId = c.CustomerId
    LEFT JOIN OrderDetails AS od ON od.OrderId = o.OrderId
    GROUP BY c.CustomerId, c.LastName, c.FirstName
)
SELECT CustomerId, LastName, FirstName, OrderCount, TotalAmount
FROM CustomerSales
ORDER BY TotalAmount DESC, CustomerId;"""


def q21_insert_customer() -> str:
    return """INSERT INTO Customers (Email, FirstName, LastName, City)
VALUES (%(email)s, %(first_name)s, %(last_name)s, %(city)s);"""


def q22_insert_discounted_products() -> str:
    return """INSERT INTO ProductDiscounts (ProductId, DiscountRate, StartDate, EndDate)
SELECT p.ProductId, 0.10, CAST(GETDATE() AS date), DATEADD(day, 30, CAST(GETDATE() AS date))
FROM Products AS p
WHERE p.UnitPrice >= 5000
  AND NOT EXISTS (
      SELECT 1
      FROM ProductDiscounts AS d
      WHERE d.ProductId = p.ProductId
        AND CAST(GETDATE() AS date) BETWEEN d.StartDate AND d.EndDate
  );"""


def q23_update_inactive_products() -> str:
    return "UPDATE Products SET IsActive = 0 WHERE StockQuantity = 0;"


def q24_update_category_prices() -> str:
    return """UPDATE p
SET p.UnitPrice = ROUND(p.UnitPrice * 1.10, 2)
FROM Products AS p
INNER JOIN Categories AS c ON c.CategoryId = p.CategoryId
WHERE c.CategoryName = N'Books';"""


def q25_delete_expired_discounts() -> str:
    return "DELETE FROM ProductDiscounts WHERE EndDate < CAST(GETDATE() AS date);"


def q26_delete_customers_without_orders() -> str:
    return """DELETE c
FROM Customers AS c
WHERE c.IsActive = 0
  AND NOT EXISTS (
      SELECT 1 FROM Orders AS o WHERE o.CustomerId = c.CustomerId
  );"""


def q27_upsert_inventory() -> str:
    return """MERGE Products AS target
USING InventoryImport AS source
ON target.ProductId = source.ProductId
WHEN MATCHED THEN
    UPDATE SET target.StockQuantity = source.StockQuantity
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductId, ProductName, CategoryId, UnitPrice, StockQuantity, IsActive)
    VALUES (source.ProductId, source.ProductName, source.CategoryId,
            source.UnitPrice, source.StockQuantity, 1);"""


def q28_best_selling_product_per_category() -> str:
    return """WITH ProductSales AS (
    SELECT c.CategoryId, c.CategoryName, p.ProductId, p.ProductName,
           COALESCE(SUM(od.Quantity * od.UnitPrice), 0) AS SalesAmount
    FROM Categories AS c
    INNER JOIN Products AS p ON p.CategoryId = c.CategoryId
    LEFT JOIN OrderDetails AS od ON od.ProductId = p.ProductId
    GROUP BY c.CategoryId, c.CategoryName, p.ProductId, p.ProductName
),
RankedSales AS (
    SELECT *, DENSE_RANK() OVER (
        PARTITION BY CategoryId ORDER BY SalesAmount DESC
    ) AS SalesRank
    FROM ProductSales
)
SELECT CategoryId, CategoryName, ProductId, ProductName, SalesAmount
FROM RankedSales
WHERE SalesRank = 1
ORDER BY CategoryId, ProductId;"""


def q29_customer_order_interval() -> str:
    return """WITH OrderHistory AS (
    SELECT CustomerId, OrderId, OrderDate,
           LAG(OrderDate) OVER (
               PARTITION BY CustomerId ORDER BY OrderDate, OrderId
           ) AS PreviousOrderDate
    FROM Orders
)
SELECT CustomerId, OrderId, OrderDate, PreviousOrderDate,
       DATEDIFF(day, PreviousOrderDate, OrderDate) AS DaysSincePreviousOrder
FROM OrderHistory
ORDER BY CustomerId, OrderDate, OrderId;"""


def q30_sales_dashboard() -> str:
    return """WITH MonthlyCategorySales AS (
    SELECT DATEFROMPARTS(YEAR(o.OrderDate), MONTH(o.OrderDate), 1) AS SalesMonth,
           c.CategoryId, c.CategoryName,
           SUM(od.Quantity * od.UnitPrice) AS SalesAmount
    FROM Orders AS o
    INNER JOIN OrderDetails AS od ON od.OrderId = o.OrderId
    INNER JOIN Products AS p ON p.ProductId = od.ProductId
    INNER JOIN Categories AS c ON c.CategoryId = p.CategoryId
    GROUP BY DATEFROMPARTS(YEAR(o.OrderDate), MONTH(o.OrderDate), 1),
             c.CategoryId, c.CategoryName
),
WithPrevious AS (
    SELECT *,
           LAG(SalesAmount) OVER (
               PARTITION BY CategoryId ORDER BY SalesMonth
           ) AS PreviousMonthAmount
    FROM MonthlyCategorySales
)
SELECT SalesMonth, CategoryId, CategoryName, SalesAmount, PreviousMonthAmount,
       CAST(
           (SalesAmount - PreviousMonthAmount) * 100.0
           / NULLIF(PreviousMonthAmount, 0)
           AS decimal(10, 2)
       ) AS GrowthRatePercent
FROM WithPrevious
ORDER BY SalesMonth, CategoryId;"""
