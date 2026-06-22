DROP TABLE IF EXISTS InventoryImport;
DROP TABLE IF EXISTS ProductDiscounts;
DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Customers;
GO

CREATE TABLE Customers (
    CustomerId int IDENTITY(1, 1) PRIMARY KEY,
    Email nvarchar(255) NOT NULL UNIQUE,
    FirstName nvarchar(50) NOT NULL,
    LastName nvarchar(50) NOT NULL,
    City nvarchar(100) NULL,
    IsActive bit NOT NULL CONSTRAINT DF_Customers_IsActive DEFAULT 1,
    CreatedAt datetime2 NOT NULL CONSTRAINT DF_Customers_CreatedAt DEFAULT SYSDATETIME()
);

CREATE TABLE Categories (
    CategoryId int IDENTITY(1, 1) PRIMARY KEY,
    CategoryName nvarchar(100) NOT NULL UNIQUE
);

CREATE TABLE Products (
    ProductId int PRIMARY KEY,
    ProductName nvarchar(200) NOT NULL,
    CategoryId int NOT NULL REFERENCES Categories(CategoryId),
    UnitPrice decimal(10, 2) NOT NULL CHECK (UnitPrice >= 0),
    StockQuantity int NOT NULL CHECK (StockQuantity >= 0),
    IsActive bit NOT NULL CONSTRAINT DF_Products_IsActive DEFAULT 1
);

CREATE TABLE Orders (
    OrderId int IDENTITY(1, 1) PRIMARY KEY,
    CustomerId int NOT NULL REFERENCES Customers(CustomerId),
    OrderDate datetime2 NOT NULL,
    Status varchar(20) NOT NULL CHECK (Status IN ('Pending', 'Paid', 'Shipped', 'Cancelled'))
);

CREATE TABLE OrderDetails (
    OrderId int NOT NULL REFERENCES Orders(OrderId),
    ProductId int NOT NULL REFERENCES Products(ProductId),
    Quantity int NOT NULL CHECK (Quantity > 0),
    UnitPrice decimal(10, 2) NOT NULL CHECK (UnitPrice >= 0),
    CONSTRAINT PK_OrderDetails PRIMARY KEY (OrderId, ProductId)
);

CREATE TABLE ProductDiscounts (
    DiscountId int IDENTITY(1, 1) PRIMARY KEY,
    ProductId int NOT NULL REFERENCES Products(ProductId),
    DiscountRate decimal(5, 4) NOT NULL CHECK (DiscountRate > 0 AND DiscountRate < 1),
    StartDate date NOT NULL,
    EndDate date NOT NULL,
    CHECK (StartDate <= EndDate)
);

CREATE TABLE InventoryImport (
    ProductId int PRIMARY KEY,
    ProductName nvarchar(200) NOT NULL,
    CategoryId int NOT NULL,
    UnitPrice decimal(10, 2) NOT NULL,
    StockQuantity int NOT NULL
);
GO

SET IDENTITY_INSERT Categories ON;
INSERT INTO Categories (CategoryId, CategoryName) VALUES
    (1, N'Books'),
    (2, N'Software'),
    (3, N'Accessories'),
    (4, N'Training');
SET IDENTITY_INSERT Categories OFF;

INSERT INTO Products
    (ProductId, ProductName, CategoryId, UnitPrice, StockQuantity, IsActive)
VALUES
    (101, N'SQL入門',                  1,  2800, 20, 1),
    (102, N'SQL Server実践ガイド',     1,  5200,  8, 1),
    (103, N'Python基礎',               1,  3200,  0, 1),
    (201, N'Database Tool Pro',        2, 12800, 15, 1),
    (202, N'Query Formatter',          2,  4800, 30, 1),
    (301, N'USB Keyboard',             3,  3500, 12, 1),
    (302, N'Wireless Mouse',           3,  2400,  0, 1),
    (401, N'SQLオンライン講座',         4,  9800, 50, 1),
    (402, N'Pythonオンライン講座',      4,  8800, 50, 1);

SET IDENTITY_INSERT Customers ON;
INSERT INTO Customers
    (CustomerId, Email, FirstName, LastName, City, IsActive)
VALUES
    (1, N'aoi@example.com',   N'葵', N'佐藤', N'東京', 1),
    (2, N'ren@example.com',   N'蓮', N'鈴木', N'大阪', 1),
    (3, N'yui@example.com',   N'結衣', N'高橋', N'東京', 1),
    (4, N'sora@example.com',  N'空', N'田中', NULL, 1),
    (5, N'old@example.com',   N'旧', N'顧客', N'札幌', 0);
SET IDENTITY_INSERT Customers OFF;

SET IDENTITY_INSERT Orders ON;
INSERT INTO Orders (OrderId, CustomerId, OrderDate, Status) VALUES
    (1001, 1, '2025-01-10T10:00:00', 'Paid'),
    (1002, 1, '2025-02-12T11:30:00', 'Shipped'),
    (1003, 2, '2025-01-15T09:00:00', 'Paid'),
    (1004, 2, '2025-03-01T14:00:00', 'Pending'),
    (1005, 3, '2025-02-20T16:00:00', 'Cancelled'),
    (1006, 3, '2025-03-18T13:00:00', 'Paid'),
    (1007, 1, '2025-03-25T08:30:00', 'Shipped');
SET IDENTITY_INSERT Orders OFF;

INSERT INTO OrderDetails (OrderId, ProductId, Quantity, UnitPrice) VALUES
    (1001, 101, 2,  2800),
    (1001, 301, 1,  3500),
    (1002, 201, 1, 12800),
    (1002, 401, 1,  9800),
    (1003, 102, 1,  5200),
    (1003, 202, 2,  4800),
    (1004, 302, 3,  2400),
    (1005, 402, 1,  8800),
    (1006, 101, 1,  2800),
    (1006, 401, 1,  9800),
    (1007, 102, 2,  5200);

INSERT INTO ProductDiscounts
    (ProductId, DiscountRate, StartDate, EndDate)
VALUES
    (101, 0.10, '2024-01-01', '2024-01-31'),
    (201, 0.15, '2025-01-01', '2099-12-31');

INSERT INTO InventoryImport
    (ProductId, ProductName, CategoryId, UnitPrice, StockQuantity)
VALUES
    (101, N'SQL入門', 1, 2800, 35),
    (501, N'Desk Light', 3, 4200, 10);
GO
