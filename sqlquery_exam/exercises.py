"""Learner answer slots.

Each function must return one SQL Server query string. Copy a function from
``solutions.py`` only after attempting the problem yourself.
"""


def _todo(number: int) -> str:
    return f"-- TODO: 問題 {number:02d} のSQLをここに書いてください"


def q01_select_all_products() -> str: 
    return """
    SELECT * FROM Products;
    """

def q02_select_product_columns() -> str: 
    return """
    SELECT ProductName, UnitPrice FROM Products ORDER BY ProductName ASC;
    """ 

def q03_active_products() -> str: 
    return """
    SELECT ProductId, ProductName, UnitPrice FROM Products WHERE IsActive = 1;
    """

def q04_products_in_price_range() -> str: 
    return """
    SELECT ProductId, ProductName, UnitPrice FROM Products WHERE UnitPrice BETWEEN 1000 AND 5000 ORDER BY UnitPrice DESC;
    """

def q05_product_name_search() -> str: 
    return """
    SELECT ProductId, ProductName FROM Products WHERE ProductName LIKE '%SQL%';
    """

def q06_distinct_customer_cities() -> str: 
    return """
    SELECT DISTINCT City FROM Customers WHERE City IS NOT NULL;
    """

def q07_recent_orders() -> str: 
    return """
    SELECT * FROM Orders ORDER BY OrderDate DESC OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;
    """ 

def q08_customer_display_name() -> str: 
    return """
    SELECT CustomerId, CONCAT(LastName, ' ', FirstName) AS DisplayName FROM Customers;
    """

def q09_order_amounts() -> str: 
    return """
    SELECT OrderId, ProductId, Quantity, UnitPrice, (Quantity * UnitPrice) AS LineAmount FROM OrderDetails;
    """

def q10_products_with_category() -> str: 
    return """
    SELECT P.ProductId, P.ProductName, C.CategoryName
        FROM Products AS P
        JOIN Categories AS C
        ON P.CategoryId = C.CategoryId; 
    """

def q11_customers_and_orders() -> str: 
    return """
    SELECT C.CustomerId, C.LastName, C.FirstName, O.OrderId, O.OrderDate
        FROM Customers AS C
        LEFT JOIN Orders AS O
        ON C.CustomerId = O.CustomerId;
    """

def q12_order_detail_report() -> str: 
    return """
    SELECT OD.OrderId, P.ProductName, OD.Quantity, OD.UnitPrice, (OD.Quantity * OD.UnitPrice) AS LineAmount
        FROM OrderDetails AS OD
        JOIN Products AS P
        ON OD.ProductId = P.ProductId
        ORDER BY OD.OrderId, P.ProductId;
    """

def q13_product_count_by_category() -> str: 
    return """
    SELECT C.CategoryId, C.CategoryName, COUNT(P.ProductId) AS ProductCount 
        FROM Categories AS C
        JOIN Products AS P 
        ON C.CategoryId = P.CategoryId
        GROUP BY C.CategoryId, C.CategoryName;
    """

def q14_order_total_by_order() -> str: 
    return """
    SELECT OrderId, SUM(Quantity * UnitPrice) AS OrderTotal FROM OrderDetails GROUP BY OrderId;
    """

def q15_large_order_customers() -> str: 
    return """
    SELECT 
        C.CustomerId, 
        C.LastName, 
        C.FirstName, 
        SUM(OD.Quantity * OD.UnitPrice) AS TotalAmount
    FROM Customers AS C
    JOIN Orders AS O
        ON C.CustomerId = O.CustomerId
    JOIN OrderDetails AS OD
        ON O.OrderID = OD.OrderId
    GROUP BY 
        C.CustomerId,
        C.LastName, 
        C.FirstName
    HAVING 
        SUM(OD.Quantity * OD.UnitPrice) >= 10000
    ORDER BY 
        TotalAmount DESC, 
        C.CustomerId ASC;
    """

def q16_products_above_average_price() -> str: 
    return """
    SELECT 
        ProductId, 
        ProductName, 
        UnitPrice 
    FROM Products 
    WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products)
    ORDER BY UnitPrice DESC, ProductId ASC;
    """

def q17_customers_without_orders() -> str: 
    return """
    SELECT 
        CustomerId,
        LastName,
        FirstName
    FROM Customers AS C
    WHERE NOT EXISTS (
        SELECT 1 
        FROM Orders AS O
        WHERE C.CustomerId = O.CustomerId
        )
    ORDER BY CustomerId ASC; 
    """

def q18_rank_products_by_category() -> str: 
    return """
    SELECT 
        ProductId, 
        ProductName, 
        CategoryId, 
        UnitPrice, 
        DENSE_RANK() OVER(
            PARTITION BY CategoryId
            ORDER BY UnitPrice DESC
        ) AS PriceRank 
    FROM Products
    ORDER BY 
        CategoryId, 
        PriceRank,
        ProductId;
    """
def q19_monthly_sales() -> str: 
    return """
    SELECT 
        CONVERT(char(7), O.Orderdate, 120) AS SalesMonth,
        SUM(Quantity * UnitPrice) AS SalesAmount
    FROM Orders AS O
    JOIN OrderDetails AS OD
        ON O.OrderId = OD.OrderId
    GROUP BY CONVERT(char(7), O.Orderdate, 120)
    ORDER BY CONVERT(char(7), O.Orderdate, 120);
    """
def q20_customer_sales_summary() -> str: 
    return """
    WITH CustomerSalesSummary AS (
        SELECT 
            C.CustomerId, 
            C.LastName, 
            C.FirstName, 
            COALESCE(COUNT(DISTINCT O.OrderId), 0) AS OrderCount, 
            COALESCE(SUM(OD.Quantity * OD.UnitPrice), 0) AS TotalAmount
        FROM Customers AS C
        LEFT JOIN Orders AS O
            ON C.CustomerId = O.CustomerId
        LEFT JOIN OrderDetails AS OD
            ON O.OrderId = OD.OrderId
        GROUP BY 
            C.CustomerId, 
            C.LastName, 
            C.FirstName
    )
    SELECT * 
    FROM CustomerSalesSummary
    ORDER BY 
        TotalAmount DESC,
        CustomerId ASC; 
    """

def q21_insert_customer() -> str:
    """Use parameters: %(email)s, %(first_name)s, %(last_name)s, %(city)s."""
    return """
    INSERT INTO Customers (
        Email, 
        FirstName, 
        LastName, 
        City
    )
    VALUES (
        %(email)s, 
        %(first_name)s,
        %(last_name)s, 
        %(city)s
    )

    """

def q22_insert_discounted_products() -> str: 
    return """
    INSERT INTO ProductDiscounts(
        ProductId, 
        DiscountRate,
        StartDate,
        EndDate
    )
    SELECT
        P.ProductId, 
        0.10,
        CAST(GETDATE() AS date),
        DATEADD(day, 30, CAST(GETDATE() AS date))
    FROM Products AS P
    WHERE 
        UnitPrice >= 5000 AND
        NOT EXISTS (
            SELECT 1
            FROM ProductDiscounts AS PD
            WHERE 
                PD.ProductId = P.ProductId AND
                CAST(GETDATE() AS date) BETWEEN PD.StartDate AND PD.EndDate
        ); 
    """
def q23_update_inactive_products() -> str: 
    return """
    UPDATE Products 
    SET IsActive = 0
    WHERE StockQuantity = 0;
    """

def q24_update_category_prices() -> str: 
    return """
    UPDATE p
    SET p.UnitPrice = ROUND(p.UnitPrice * 1.10, 2)
    FROM Products AS p
    JOIN Categories AS c
        ON p.CategoryId = c.CategoryId
    WHERE CategoryName = N'Books'
    """

def q25_delete_expired_discounts() -> str: 
    return """
    DELETE FROM productDiscounts
    WHERE EndDate < CAST(GETDATE() AS date);
    """

def q26_delete_customers_without_orders() -> str: 
    return """
    DELETE c 
    FROM Customers AS c
    WHERE 
        IsActive = 0
        AND NOT EXISTS(
            SELECT 1 
            FROM Orders AS o
            WHERE o.CustomerID = c.CustomerId
        );
    """

def q27_upsert_inventory() -> str: 
    return """
    MERGE INTO Products AS target
    USING InventoryImport AS source
        ON target.ProductId = source.ProductId
    WHEN MATCHED THEN 
        UPDATE SET
        target.StockQuantity = source.StockQuantity
    WHEN NOT MATCHED BY target THEN
        INSERT (
            ProductId, 
            ProductName, 
            CategoryId, 
            UnitPrice, 
            StockQuantity
        )
        VALUES(
            source.ProductId, 
            source.ProductName, 
            source.CategoryId, 
            source.UnitPrice, 
            source.StockQuantity
        )
    """
def q28_best_selling_product_per_category() -> str: return _todo(28)
def q29_customer_order_interval() -> str: return _todo(29)
def q30_sales_dashboard() -> str: return _todo(30)
