USE SqlQueryExam;


/* q21：顧客の追加 */

BEGIN TRANSACTION;

DECLARE @q21_email nvarchar(255)
    = CONCAT(N'q21-review-', CONVERT(nvarchar(36), NEWID()), N'@example.com');
DECLARE @q21_first_name nvarchar(50) = N'太郎';
DECLARE @q21_last_name nvarchar(50) = N'確認';
DECLARE @q21_city nvarchar(100) = N'東京';

-- 更新前
SELECT *
FROM Customers
ORDER BY CustomerId;

SELECT
    CustomerId,
    Email,
    FirstName,
    LastName,
    City,
    IsActive,
    CreatedAt
FROM Customers
WHERE Email = @q21_email;

-- q21のSQL
-- exercises.pyのpymssql用プレースホルダーを、確認用のT-SQL変数に置き換えています。
INSERT INTO Customers (
    Email,
    FirstName,
    LastName,
    City
)
VALUES (
    @q21_email,
    @q21_first_name,
    @q21_last_name,
    @q21_city
);

-- 更新後
SELECT *
FROM Customers
ORDER BY CustomerId;

SELECT
    CustomerId,
    Email,
    FirstName,
    LastName,
    City,
    IsActive,
    CreatedAt
FROM Customers
WHERE Email = @q21_email;

ROLLBACK TRANSACTION;


/* q22：高額商品の割引追加 */

BEGIN TRANSACTION;

-- 更新前
SELECT *
FROM ProductDiscounts
ORDER BY DiscountId;

SELECT
    p.ProductId,
    p.ProductName,
    p.UnitPrice,
    pd.DiscountId,
    pd.DiscountRate,
    pd.StartDate,
    pd.EndDate
FROM Products AS p
LEFT JOIN ProductDiscounts AS pd
    ON pd.ProductId = p.ProductId
WHERE p.UnitPrice >= 5000
ORDER BY p.ProductId, pd.DiscountId;

-- q22のSQL
INSERT INTO ProductDiscounts (
    ProductId,
    DiscountRate,
    StartDate,
    EndDate
)
SELECT
    p.ProductId,
    0.10,
    CAST(GETDATE() AS date),
    DATEADD(day, 30, CAST(GETDATE() AS date))
FROM Products AS p
WHERE p.UnitPrice >= 5000
  AND NOT EXISTS (
      SELECT 1
      FROM ProductDiscounts AS pd
      WHERE pd.ProductId = p.ProductId
        AND CAST(GETDATE() AS date)
            BETWEEN pd.StartDate AND pd.EndDate
  );

-- 更新後
SELECT *
FROM ProductDiscounts
ORDER BY DiscountId;

SELECT
    p.ProductId,
    p.ProductName,
    p.UnitPrice,
    pd.DiscountId,
    pd.DiscountRate,
    pd.StartDate,
    pd.EndDate
FROM Products AS p
LEFT JOIN ProductDiscounts AS pd
    ON pd.ProductId = p.ProductId
WHERE p.UnitPrice >= 5000
ORDER BY p.ProductId, pd.DiscountId;

ROLLBACK TRANSACTION;


/* q23：在庫切れ商品の販売停止 */

BEGIN TRANSACTION;

-- 更新前
SELECT *
FROM Products
ORDER BY ProductId;

SELECT
    ProductId,
    ProductName,
    StockQuantity,
    IsActive
FROM Products
WHERE StockQuantity = 0
ORDER BY ProductId;

-- q23のSQL
UPDATE Products
SET IsActive = 0
WHERE StockQuantity = 0;

-- 更新後
SELECT *
FROM Products
ORDER BY ProductId;

SELECT
    ProductId,
    ProductName,
    StockQuantity,
    IsActive
FROM Products
WHERE StockQuantity = 0
ORDER BY ProductId;

ROLLBACK TRANSACTION;


/* q24：Booksカテゴリの値上げ */

BEGIN TRANSACTION;

-- 更新前
SELECT *
FROM Products
ORDER BY ProductId;

SELECT
    p.ProductId,
    p.ProductName,
    c.CategoryName,
    p.UnitPrice
FROM Products AS p
INNER JOIN Categories AS c
    ON c.CategoryId = p.CategoryId
ORDER BY p.ProductId;

-- q24のSQL
UPDATE p
SET p.UnitPrice = ROUND(p.UnitPrice * 1.10, 2)
FROM Products AS p
INNER JOIN Categories AS c
    ON p.CategoryId = c.CategoryId
WHERE c.CategoryName = N'Books';

-- 更新後
SELECT *
FROM Products
ORDER BY ProductId;

SELECT
    p.ProductId,
    p.ProductName,
    c.CategoryName,
    p.UnitPrice
FROM Products AS p
INNER JOIN Categories AS c
    ON c.CategoryId = p.CategoryId
ORDER BY p.ProductId;

ROLLBACK TRANSACTION;


/* q25：期限切れ割引の削除 */

BEGIN TRANSACTION;

-- 更新前
SELECT *
FROM ProductDiscounts
ORDER BY DiscountId;

-- q25のSQL
DELETE FROM ProductDiscounts
WHERE EndDate < CAST(GETDATE() AS date);

-- 更新後
SELECT *
FROM ProductDiscounts
ORDER BY DiscountId;

ROLLBACK TRANSACTION;


/* q26：注文履歴がない非アクティブ顧客の削除 */

BEGIN TRANSACTION;

-- 更新前
SELECT *
FROM Customers
ORDER BY CustomerId;

SELECT
    c.CustomerId,
    c.Email,
    c.FirstName,
    c.LastName,
    c.IsActive,
    COUNT(o.OrderId) AS OrderCount
FROM Customers AS c
LEFT JOIN Orders AS o
    ON o.CustomerId = c.CustomerId
GROUP BY
    c.CustomerId,
    c.Email,
    c.FirstName,
    c.LastName,
    c.IsActive
ORDER BY c.CustomerId;

-- q26のSQL
DELETE c
FROM Customers AS c
LEFT JOIN Orders AS o
    ON c.CustomerId = o.CustomerId
WHERE c.IsActive = 0
  AND o.OrderId IS NULL;

-- 更新後
SELECT *
FROM Customers
ORDER BY CustomerId;

SELECT
    c.CustomerId,
    c.Email,
    c.FirstName,
    c.LastName,
    c.IsActive,
    COUNT(o.OrderId) AS OrderCount
FROM Customers AS c
LEFT JOIN Orders AS o
    ON o.CustomerId = c.CustomerId
GROUP BY
    c.CustomerId,
    c.Email,
    c.FirstName,
    c.LastName,
    c.IsActive
ORDER BY c.CustomerId;

ROLLBACK TRANSACTION;


/* q27：在庫データの反映 */

BEGIN TRANSACTION;

-- 更新前
SELECT *
FROM Products
ORDER BY ProductId;

SELECT *
FROM InventoryImport
ORDER BY ProductId;

SELECT
    source.ProductId,
    source.ProductName AS ImportProductName,
    source.CategoryId AS ImportCategoryId,
    source.UnitPrice AS ImportUnitPrice,
    source.StockQuantity AS ImportStockQuantity,
    target.ProductName AS CurrentProductName,
    target.StockQuantity AS CurrentStockQuantity,
    target.IsActive AS CurrentIsActive
FROM InventoryImport AS source
LEFT JOIN Products AS target
    ON target.ProductId = source.ProductId
ORDER BY source.ProductId;

-- q27のSQL
MERGE Products AS target
USING InventoryImport AS source
ON target.ProductId = source.ProductId
WHEN MATCHED THEN
    UPDATE SET
        target.StockQuantity = source.StockQuantity
WHEN NOT MATCHED BY TARGET THEN
    INSERT (
        ProductId,
        ProductName,
        CategoryId,
        UnitPrice,
        StockQuantity,
        IsActive
    )
    VALUES (
        source.ProductId,
        source.ProductName,
        source.CategoryId,
        source.UnitPrice,
        source.StockQuantity,
        1
    );

-- 更新後
SELECT *
FROM Products
ORDER BY ProductId;

SELECT
    p.ProductId,
    p.ProductName,
    p.CategoryId,
    p.UnitPrice,
    p.StockQuantity,
    p.IsActive
FROM Products AS p
WHERE p.ProductId IN (
    SELECT ProductId
    FROM InventoryImport
)
ORDER BY p.ProductId;

ROLLBACK TRANSACTION;
