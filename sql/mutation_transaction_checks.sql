/*
問題21～27 更新系SQLの手動確認用スクリプト

各問題は独立したトランザクションとして実行します。最初に更新前の
関連テーブルをすべて表示し、回答SQLの実行後に更新対象テーブルを
もう一度表示してから、ROLLBACK で変更を取り消します。

注意:
- 問題ごとにブロックを選択して実行することを想定しています。
- ROLLBACKしても、IDENTITYで一度採番された番号は再利用されません。
- 問題21は、pymssql用プレースホルダーの代わりにSSMSで実行できる
  テスト用SQL変数を使用しています。
*/

USE SqlQueryExam;
GO

/* ================================================================
   問題21：顧客の追加
   ================================================================ */
BEGIN TRANSACTION;

PRINT N'問題21：更新前の Customers';
SELECT *
FROM Customers
ORDER BY CustomerId;

DECLARE @email nvarchar(255) = N'taro.transaction-test@example.com';
DECLARE @first_name nvarchar(50) = N'太郎';
DECLARE @last_name nvarchar(50) = N'山田';
DECLARE @city nvarchar(100) = N'東京';

INSERT INTO Customers (
    Email,
    FirstName,
    LastName,
    City
)
VALUES (
    @email,
    @first_name,
    @last_name,
    @city
);

PRINT N'問題21：更新後の Customers';
SELECT *
FROM Customers
ORDER BY CustomerId;

ROLLBACK TRANSACTION;
GO

/* ================================================================
   問題22：高額商品の割引追加
   ================================================================ */
BEGIN TRANSACTION;

PRINT N'問題22：更新前の Products';
SELECT *
FROM Products
ORDER BY ProductId;

PRINT N'問題22：更新前の ProductDiscounts';
SELECT *
FROM ProductDiscounts
ORDER BY DiscountId;

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
WHERE
    p.UnitPrice >= 5000
    AND NOT EXISTS (
        SELECT 1
        FROM ProductDiscounts AS pd
        WHERE
            pd.ProductId = p.ProductId
            AND CAST(GETDATE() AS date) BETWEEN pd.StartDate AND pd.EndDate
    );

PRINT N'問題22：更新後の ProductDiscounts';
SELECT *
FROM ProductDiscounts
ORDER BY DiscountId;

ROLLBACK TRANSACTION;
GO

/* ================================================================
   問題23：在庫切れ商品の販売停止
   ================================================================ */
BEGIN TRANSACTION;

PRINT N'問題23：更新前の Products';
SELECT *
FROM Products
ORDER BY ProductId;

UPDATE Products
SET IsActive = 0
WHERE StockQuantity = 0;

PRINT N'問題23：更新後の Products';
SELECT *
FROM Products
ORDER BY ProductId;

ROLLBACK TRANSACTION;
GO

/* ================================================================
   問題24：Booksカテゴリの値上げ
   ================================================================ */
BEGIN TRANSACTION;

PRINT N'問題24：更新前の Categories';
SELECT *
FROM Categories
ORDER BY CategoryId;

PRINT N'問題24：更新前の Products';
SELECT *
FROM Products
ORDER BY ProductId;

UPDATE p
SET p.UnitPrice = ROUND(p.UnitPrice * 1.10, 2)
FROM Products AS p
JOIN Categories AS c
    ON p.CategoryId = c.CategoryId
WHERE CategoryName = N'Books';

PRINT N'問題24：更新後の Products';
SELECT *
FROM Products
ORDER BY ProductId;

ROLLBACK TRANSACTION;
GO

/* ================================================================
   問題25：期限切れ割引の削除
   ================================================================ */
BEGIN TRANSACTION;

PRINT N'問題25：更新前の ProductDiscounts';
SELECT *
FROM ProductDiscounts
ORDER BY DiscountId;

DELETE FROM ProductDiscounts
WHERE EndDate < CAST(GETDATE() AS date);

PRINT N'問題25：更新後の ProductDiscounts';
SELECT *
FROM ProductDiscounts
ORDER BY DiscountId;

ROLLBACK TRANSACTION;
GO

/* ================================================================
   問題26：注文履歴がない非アクティブ顧客の削除
   ================================================================ */
BEGIN TRANSACTION;

PRINT N'問題26：更新前の Customers';
SELECT *
FROM Customers
ORDER BY CustomerId;

PRINT N'問題26：更新前の Orders';
SELECT *
FROM Orders
ORDER BY OrderId;

DELETE c
FROM Customers AS c
WHERE
    IsActive = 0
    AND NOT EXISTS (
        SELECT 1
        FROM Orders AS o
        WHERE o.CustomerId = c.CustomerId
    );

PRINT N'問題26：更新後の Customers';
SELECT *
FROM Customers
ORDER BY CustomerId;

ROLLBACK TRANSACTION;
GO

/* ================================================================
   問題27：在庫データの反映
   ================================================================ */
BEGIN TRANSACTION;

PRINT N'問題27：更新前の InventoryImport';
SELECT *
FROM InventoryImport
ORDER BY ProductId;

PRINT N'問題27：更新前の Categories';
SELECT *
FROM Categories
ORDER BY CategoryId;

PRINT N'問題27：更新前の Products';
SELECT *
FROM Products
ORDER BY ProductId;

MERGE INTO Products AS target
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
        StockQuantity
    )
    VALUES (
        source.ProductId,
        source.ProductName,
        source.CategoryId,
        source.UnitPrice,
        source.StockQuantity
    );

PRINT N'問題27：更新後の Products';
SELECT *
FROM Products
ORDER BY ProductId;

ROLLBACK TRANSACTION;
GO
