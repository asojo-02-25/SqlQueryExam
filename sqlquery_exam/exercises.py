"""Learner answer slots.

Each function must return one SQL Server query string. Copy a function from
``solutions.py`` only after attempting the problem yourself.
"""


def _todo(number: int) -> str:
    return f"-- TODO: 問題 {number:02d} のSQLをここに書いてください"


def q01_select_all_products() -> str:
    return """
    SELECT * FROM Products
    ORDER BY ProductId;
    """

def q02_select_product_columns() -> str:
    return """ 
    SELECT ProductName, UnitPrice FROM Products
    ORDER BY ProductName ASC;
    """
 
def q03_active_products() -> str:
    return """
    SELECT ProductId, ProductName, UnitPrice FROM Products
    WHERE isActive = 1
    """

def q04_products_in_price_range() -> str: 
    return """
    SELECT ProductId, ProductName, UnitPrice FROM Products
    WHERE UnitPrice BETWEEN 1000 AND 5000
    ORDER BY UnitPrice DESC;
    """

def q05_product_name_search() -> str: 
    return """
    SELECT ProductId, ProductName FROM Products 
    WHERE ProductName LIKE '%SQL%';
    """

def q06_distinct_customer_cities() -> str:
    return """
    SELECT DISTINCT City FROM Customers
    WHERE City IS NOT NULL
    ORDER BY City; 
    """

def q07_recent_orders() -> str: 
    return """
    SELECT * FROM Orders
    ORDER BY OrderDate Desc
    OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;
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
    ON P.CategoryId = C.CategoryId
    """

def q11_customers_and_orders() -> str: 
    return """
    SELECT C.CustomerId, C.LastName, C.FirstName, O.OrderId, O.OrderDate 
    FROM Customers AS C
    LEFT JOIN Orders AS O
    ON C.CustomerId = O.CustomerId
    """

def q12_order_detail_report() -> str: 
    return """
    SELECT O.OrderId, P.ProductName, O.Quantity, O.UnitPrice, (O.Quantity * O.UnitPrice) AS LineAmount
    FROM OrderDetails AS O
    JOIN Products AS P
    ON O.ProductId = P.ProductId;
    """

def q13_product_count_by_category() -> str: 
    return """
    SELECT CategoryId, CategoryName, COUNT(*) AS ProductCount FROM Products GROUP BY CategoryId;
    """

def q14_order_total_by_order() -> str: 
    return """
    SELECT OrderId, SUM(Quantity * UnitPrice) AS OrderTotal FROM OrderDetails GROUP BY OrderId;
    """

def q15_large_order_customers() -> str: 
    return """
    SELECT C.CustomerId, C.LastName, C.FirstName, SUM(OD.Quantity * OD.UnitPrice) AS TotalAmount
    FROM Customers AS C
    JOIN Orders AS O
    ON C.CustomerId = O.CustomerId
    JOIN OrderDetails AS OD
    ON O.OrderId = OD.OrderId
    GROUP BY C.CustomerId
    HAVING SUM(OD.Quantity * OD.UnitPrice) >= 10000;
    """

def q16_products_above_average_price() -> str: 
    return """
    SELECT * FROM Products WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products);
    """

def q17_customers_without_orders() -> str: 
    return """
    
    """
def q18_rank_products_by_category() -> str: return _todo(18)
def q19_monthly_sales() -> str: return _todo(19)
def q20_customer_sales_summary() -> str: return _todo(20)


def q21_insert_customer() -> str:
    """Use parameters: %(email)s, %(first_name)s, %(last_name)s, %(city)s."""
    return _todo(21)


def q22_insert_discounted_products() -> str: return _todo(22)
def q23_update_inactive_products() -> str: return _todo(23)
def q24_update_category_prices() -> str: return _todo(24)
def q25_delete_expired_discounts() -> str: return _todo(25)
def q26_delete_customers_without_orders() -> str: return _todo(26)
def q27_upsert_inventory() -> str: return _todo(27)
def q28_best_selling_product_per_category() -> str: return _todo(28)
def q29_customer_order_interval() -> str: return _todo(29)
def q30_sales_dashboard() -> str: return _todo(30)
