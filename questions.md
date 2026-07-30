# SQL Server DML 練習問題（詳細仕様）

このファイルは `sqlquery_exam/solutions.py` の参照解答と照合し、テストで必要になる
条件を答えのSQLを示さずに記述した問題集です。元の `sqlquery_exam/catalog.py` は
変更していません。

## 共通ルール

- 解答は `sqlquery_exam/exercises.py` の対応する関数に記述します。
- 各関数は引数を取らず、Microsoft SQL Serverで実行できるSQL文字列を返します。
- 取得系の問題では、出力列の順序、列名、行の並び順も仕様の一部です。
- 計算列と集計列には、問題文に記載した列名を付けてください。
- 並び順を複数指定している場合は、先に書かれた項目を優先します。
- 指定のない注文ステータスや販売状態による絞り込みは行いません。
- 問題21〜27は更新系です。明示的なトランザクション内で実行し、結果確認後に
  ロールバックしてください。

## 基礎

### 問題01：全列の取得

- 関数：`q01_select_all_products`
- `Products` の全列を取得してください。
- `ProductId` の昇順に並べてください。

#### 参照テーブル

```sql
CREATE TABLE Products (
    ProductId int PRIMARY KEY,
    ProductName nvarchar(200) NOT NULL,
    CategoryId int NOT NULL REFERENCES Categories(CategoryId),
    UnitPrice decimal(10, 2) NOT NULL CHECK (UnitPrice >= 0),
    StockQuantity int NOT NULL CHECK (StockQuantity >= 0),
    IsActive bit NOT NULL CONSTRAINT DF_Products_IsActive DEFAULT 1
);
```

### 問題02：列の選択

- 関数：`q02_select_product_columns`
- 出力列は、順に `ProductName`、`UnitPrice` としてください。
- `ProductName` の昇順に並べてください。

#### 参照テーブル

```sql
CREATE TABLE Products (
    ProductId int PRIMARY KEY,
    ProductName nvarchar(200) NOT NULL,
    CategoryId int NOT NULL REFERENCES Categories(CategoryId),
    UnitPrice decimal(10, 2) NOT NULL CHECK (UnitPrice >= 0),
    StockQuantity int NOT NULL CHECK (StockQuantity >= 0),
    IsActive bit NOT NULL CONSTRAINT DF_Products_IsActive DEFAULT 1
);
```

### 問題03：販売中の商品

- 関数：`q03_active_products`
- `IsActive` が `1` の商品だけを対象にしてください。
- 出力列は、順に `ProductId`、`ProductName`、`UnitPrice` としてください。
- `ProductId` の昇順に並べてください。

#### 参照テーブル

```sql
CREATE TABLE Products (
    ProductId int PRIMARY KEY,
    ProductName nvarchar(200) NOT NULL,
    CategoryId int NOT NULL REFERENCES Categories(CategoryId),
    UnitPrice decimal(10, 2) NOT NULL CHECK (UnitPrice >= 0),
    StockQuantity int NOT NULL CHECK (StockQuantity >= 0),
    IsActive bit NOT NULL CONSTRAINT DF_Products_IsActive DEFAULT 1
);
```

### 問題04：価格範囲

- 関数：`q04_products_in_price_range`
- `UnitPrice` が1000以上5000以下の商品を対象にしてください。両端を含みます。
- 出力列は、順に `ProductId`、`ProductName`、`UnitPrice` としてください。
- `UnitPrice` の降順、同額の場合は `ProductId` の昇順に並べてください。

#### 参照テーブル

```sql
CREATE TABLE Products (
    ProductId int PRIMARY KEY,
    ProductName nvarchar(200) NOT NULL,
    CategoryId int NOT NULL REFERENCES Categories(CategoryId),
    UnitPrice decimal(10, 2) NOT NULL CHECK (UnitPrice >= 0),
    StockQuantity int NOT NULL CHECK (StockQuantity >= 0),
    IsActive bit NOT NULL CONSTRAINT DF_Products_IsActive DEFAULT 1
);
```

### 問題05：商品名検索

- 関数：`q05_product_name_search`
- `ProductName` に「SQL」を含む商品を対象にしてください。
- 出力列は、順に `ProductId`、`ProductName` としてください。
- `ProductId` の昇順に並べてください。

#### 参照テーブル

```sql
CREATE TABLE Products (
    ProductId int PRIMARY KEY,
    ProductName nvarchar(200) NOT NULL,
    CategoryId int NOT NULL REFERENCES Categories(CategoryId),
    UnitPrice decimal(10, 2) NOT NULL CHECK (UnitPrice >= 0),
    StockQuantity int NOT NULL CHECK (StockQuantity >= 0),
    IsActive bit NOT NULL CONSTRAINT DF_Products_IsActive DEFAULT 1
);
```

### 問題06：都市の重複除去

- 関数：`q06_distinct_customer_cities`
- `Customers` から重複しない `City` を取得してください。
- `NULL` は除外してください。
- 出力列は `City` のみとし、その昇順に並べてください。

#### 参照テーブル

```sql
CREATE TABLE Customers (
    CustomerId int IDENTITY(1, 1) PRIMARY KEY,
    Email nvarchar(255) NOT NULL UNIQUE,
    FirstName nvarchar(50) NOT NULL,
    LastName nvarchar(50) NOT NULL,
    City nvarchar(100) NULL,
    IsActive bit NOT NULL CONSTRAINT DF_Customers_IsActive DEFAULT 1,
    CreatedAt datetime2 NOT NULL CONSTRAINT DF_Customers_CreatedAt DEFAULT SYSDATETIME()
);
```

### 問題07：直近の注文

- 関数：`q07_recent_orders`
- `Orders` の全列を、直近の5件だけ取得してください。
- `OrderDate` の降順、日時が同じ場合は `OrderId` の降順に並べてください。

#### 参照テーブル

```sql
CREATE TABLE Orders (
    OrderId int IDENTITY(1, 1) PRIMARY KEY,
    CustomerId int NOT NULL REFERENCES Customers(CustomerId),
    OrderDate datetime2 NOT NULL,
    Status varchar(20) NOT NULL CHECK (Status IN ('Pending', 'Paid', 'Shipped', 'Cancelled'))
);
```

### 問題08：顧客表示名

- 関数：`q08_customer_display_name`
- 出力列は、順に `CustomerId`、`DisplayName` としてください。
- `DisplayName` は「姓、半角スペース、名」の順で連結してください。
- `CustomerId` の昇順に並べてください。

#### 参照テーブル

```sql
CREATE TABLE Customers (
    CustomerId int IDENTITY(1, 1) PRIMARY KEY,
    Email nvarchar(255) NOT NULL UNIQUE,
    FirstName nvarchar(50) NOT NULL,
    LastName nvarchar(50) NOT NULL,
    City nvarchar(100) NULL,
    IsActive bit NOT NULL CONSTRAINT DF_Customers_IsActive DEFAULT 1,
    CreatedAt datetime2 NOT NULL CONSTRAINT DF_Customers_CreatedAt DEFAULT SYSDATETIME()
);
```

### 問題09：注文明細金額

- 関数：`q09_order_amounts`
- `OrderDetails` の各明細を対象にしてください。
- 出力列は、順に `OrderId`、`ProductId`、`Quantity`、`UnitPrice`、
  `LineAmount` としてください。
- `LineAmount` は数量と明細単価の積です。
- `OrderId` の昇順、同じ注文内では `ProductId` の昇順に並べてください。

#### 参照テーブル

```sql
CREATE TABLE OrderDetails (
    OrderId int NOT NULL REFERENCES Orders(OrderId),
    ProductId int NOT NULL REFERENCES Products(ProductId),
    Quantity int NOT NULL CHECK (Quantity > 0),
    UnitPrice decimal(10, 2) NOT NULL CHECK (UnitPrice >= 0),
    CONSTRAINT PK_OrderDetails PRIMARY KEY (OrderId, ProductId)
);
```

## 結合

### 問題10：商品とカテゴリ

- 関数：`q10_products_with_category`
- `Products` と、その商品が属する `Categories` を結合してください。
- 出力列は、順に `ProductId`、`ProductName`、`CategoryName` としてください。
- `ProductId` の昇順に並べてください。

#### 参照テーブル

```sql
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
```

### 問題11：顧客と注文

- 関数：`q11_customers_and_orders`
- 注文がない顧客も結果に残るよう、`Customers` と `Orders` を結合してください。
- 出力列は、順に `CustomerId`、`LastName`、`FirstName`、`OrderId`、
  `OrderDate` としてください。
- `CustomerId` の昇順、同じ顧客内では `OrderDate`、`OrderId` の昇順に
  並べてください。
- 注文がない顧客の注文側の列は `NULL` になります。

#### 参照テーブル

```sql
CREATE TABLE Customers (
    CustomerId int IDENTITY(1, 1) PRIMARY KEY,
    Email nvarchar(255) NOT NULL UNIQUE,
    FirstName nvarchar(50) NOT NULL,
    LastName nvarchar(50) NOT NULL,
    City nvarchar(100) NULL,
    IsActive bit NOT NULL CONSTRAINT DF_Customers_IsActive DEFAULT 1,
    CreatedAt datetime2 NOT NULL CONSTRAINT DF_Customers_CreatedAt DEFAULT SYSDATETIME()
);

CREATE TABLE Orders (
    OrderId int IDENTITY(1, 1) PRIMARY KEY,
    CustomerId int NOT NULL REFERENCES Customers(CustomerId),
    OrderDate datetime2 NOT NULL,
    Status varchar(20) NOT NULL CHECK (Status IN ('Pending', 'Paid', 'Shipped', 'Cancelled'))
);
```

### 問題12：注文明細レポート

- 関数：`q12_order_detail_report`
- `Orders`、`OrderDetails`、`Products` を、それぞれのIDの関係に従って
  結合してください。
- 出力列は、順に `OrderId`、`ProductName`、`Quantity`、`UnitPrice`、
  `LineAmount` としてください。
- `LineAmount` は数量と明細単価の積です。
- `OrderId` の昇順、同じ注文内では `ProductId` の昇順に並べてください。
  `ProductId` は並べ替えに使用しますが、出力列には含めません。

#### 参照テーブル

```sql
CREATE TABLE Orders (
    OrderId int IDENTITY(1, 1) PRIMARY KEY,
    CustomerId int NOT NULL REFERENCES Customers(CustomerId),
    OrderDate datetime2 NOT NULL,
    Status varchar(20) NOT NULL CHECK (Status IN ('Pending', 'Paid', 'Shipped', 'Cancelled'))
);

CREATE TABLE Products (
    ProductId int PRIMARY KEY,
    ProductName nvarchar(200) NOT NULL,
    CategoryId int NOT NULL REFERENCES Categories(CategoryId),
    UnitPrice decimal(10, 2) NOT NULL CHECK (UnitPrice >= 0),
    StockQuantity int NOT NULL CHECK (StockQuantity >= 0),
    IsActive bit NOT NULL CONSTRAINT DF_Products_IsActive DEFAULT 1
);

CREATE TABLE OrderDetails (
    OrderId int NOT NULL REFERENCES Orders(OrderId),
    ProductId int NOT NULL REFERENCES Products(ProductId),
    Quantity int NOT NULL CHECK (Quantity > 0),
    UnitPrice decimal(10, 2) NOT NULL CHECK (UnitPrice >= 0),
    CONSTRAINT PK_OrderDetails PRIMARY KEY (OrderId, ProductId)
);
```

## 集計

### 問題13：カテゴリ別の商品数

- 関数：`q13_product_count_by_category`
- 商品が0件のカテゴリも結果に残るよう、`Categories` と `Products` を
  結合してください。
- カテゴリ単位で集計してください。
- 出力列は、順に `CategoryId`、`CategoryName`、`ProductCount` としてください。
- `ProductCount` は、そのカテゴリに属する商品の件数です。商品がない場合は
  `0` としてください。
- `CategoryId` の昇順に並べてください。

#### 参照テーブル

```sql
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
```

### 問題14：注文別の合計金額

- 関数：`q14_order_total_by_order`
- `Orders` と `OrderDetails` を結合し、明細が存在する注文を対象にしてください。
- 注文単位で、数量と明細単価の積を合計してください。
- 出力列は、順に `OrderId`、`OrderTotal` としてください。
- `OrderId` の昇順に並べてください。

#### 参照テーブル

```sql
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
```

### 問題15：購入額が10000以上の顧客

- 関数：`q15_large_order_customers`
- `Customers`、`Orders`、`OrderDetails` を結合してください。
- 注文単位ではなく顧客単位で、全注文明細の「数量×明細単価」を合計してください。
- 合計額が10000以上の顧客だけを対象にしてください。10000ちょうどを含みます。
- 出力列は、順に `CustomerId`、`LastName`、`FirstName`、`TotalAmount` と
  してください。
- `TotalAmount` の降順、同額の場合は `CustomerId` の昇順に並べてください。

#### 参照テーブル

```sql
CREATE TABLE Customers (
    CustomerId int IDENTITY(1, 1) PRIMARY KEY,
    Email nvarchar(255) NOT NULL UNIQUE,
    FirstName nvarchar(50) NOT NULL,
    LastName nvarchar(50) NOT NULL,
    City nvarchar(100) NULL,
    IsActive bit NOT NULL CONSTRAINT DF_Customers_IsActive DEFAULT 1,
    CreatedAt datetime2 NOT NULL CONSTRAINT DF_Customers_CreatedAt DEFAULT SYSDATETIME()
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
```

## 応用

### 問題16：平均単価より高い商品

- 関数：`q16_products_above_average_price`
- 全商品の `UnitPrice` の平均を求め、その平均より単価が高い商品を
  対象にしてください。平均と同額の商品は含めません。
- 出力列は、順に `ProductId`、`ProductName`、`UnitPrice` としてください。
- `UnitPrice` の降順、同額の場合は `ProductId` の昇順に並べてください。

#### 参照テーブル

```sql
CREATE TABLE Products (
    ProductId int PRIMARY KEY,
    ProductName nvarchar(200) NOT NULL,
    CategoryId int NOT NULL REFERENCES Categories(CategoryId),
    UnitPrice decimal(10, 2) NOT NULL CHECK (UnitPrice >= 0),
    StockQuantity int NOT NULL CHECK (StockQuantity >= 0),
    IsActive bit NOT NULL CONSTRAINT DF_Products_IsActive DEFAULT 1
);
```

### 問題17：注文履歴がない顧客

- 関数：`q17_customers_without_orders`
- `Orders` に1件も注文が存在しない顧客を対象にしてください。
- 出力列は、順に `CustomerId`、`LastName`、`FirstName` としてください。
- `CustomerId` の昇順に並べてください。

#### 参照テーブル

```sql
CREATE TABLE Customers (
    CustomerId int IDENTITY(1, 1) PRIMARY KEY,
    Email nvarchar(255) NOT NULL UNIQUE,
    FirstName nvarchar(50) NOT NULL,
    LastName nvarchar(50) NOT NULL,
    City nvarchar(100) NULL,
    IsActive bit NOT NULL CONSTRAINT DF_Customers_IsActive DEFAULT 1,
    CreatedAt datetime2 NOT NULL CONSTRAINT DF_Customers_CreatedAt DEFAULT SYSDATETIME()
);

CREATE TABLE Orders (
    OrderId int IDENTITY(1, 1) PRIMARY KEY,
    CustomerId int NOT NULL REFERENCES Customers(CustomerId),
    OrderDate datetime2 NOT NULL,
    Status varchar(20) NOT NULL CHECK (Status IN ('Pending', 'Paid', 'Shipped', 'Cancelled'))
);
```

### 問題18：カテゴリ内の価格順位

- 関数：`q18_rank_products_by_category`
- カテゴリごとに、`UnitPrice` が高い商品から順位を付けてください。
- 同額には同じ順位を付け、その次の順位を飛ばさない方式を使用してください。
- 出力列は、順に `ProductId`、`ProductName`、`CategoryId`、`UnitPrice`、
  `PriceRank` としてください。
- `CategoryId`、`PriceRank`、`ProductId` の順ですべて昇順に並べてください。

#### 参照テーブル

```sql
CREATE TABLE Products (
    ProductId int PRIMARY KEY,
    ProductName nvarchar(200) NOT NULL,
    CategoryId int NOT NULL REFERENCES Categories(CategoryId),
    UnitPrice decimal(10, 2) NOT NULL CHECK (UnitPrice >= 0),
    StockQuantity int NOT NULL CHECK (StockQuantity >= 0),
    IsActive bit NOT NULL CONSTRAINT DF_Products_IsActive DEFAULT 1
);
```

### 問題19：月別売上

- 関数：`q19_monthly_sales`
- `Orders` と `OrderDetails` を結合し、注文月単位で明細金額を合計してください。
- 月は `YYYY-MM` 形式の7文字で表し、列名を `SalesMonth` としてください。
- 合計額の列名は `SalesAmount` としてください。
- 出力列は、順に `SalesMonth`、`SalesAmount` としてください。
- `SalesMonth` の昇順に並べてください。

#### 参照テーブル

```sql
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
```

### 問題20：顧客別売上集計

- 関数：`q20_customer_sales_summary`
- CTEを使用してください。
- 注文がない顧客も含む、すべての顧客を対象にしてください。
- 顧客単位で、重複しない注文の件数と全注文明細の合計額を求めてください。
- 注文がない顧客の注文件数と合計額は、どちらも `0` としてください。
- 出力列は、順に `CustomerId`、`LastName`、`FirstName`、`OrderCount`、
  `TotalAmount` としてください。
- `TotalAmount` の降順、同額の場合は `CustomerId` の昇順に並べてください。

#### 参照テーブル

```sql
CREATE TABLE Customers (
    CustomerId int IDENTITY(1, 1) PRIMARY KEY,
    Email nvarchar(255) NOT NULL UNIQUE,
    FirstName nvarchar(50) NOT NULL,
    LastName nvarchar(50) NOT NULL,
    City nvarchar(100) NULL,
    IsActive bit NOT NULL CONSTRAINT DF_Customers_IsActive DEFAULT 1,
    CreatedAt datetime2 NOT NULL CONSTRAINT DF_Customers_CreatedAt DEFAULT SYSDATETIME()
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
```

## 更新

### 問題21：顧客の追加

- 関数：`q21_insert_customer`
- `Customers` に1件追加してください。
- 対象列は、順に `Email`、`FirstName`、`LastName`、`City` です。
- 値をSQL文字列へ直接埋め込まず、pymssqlの名前付きプレースホルダー
  `%(email)s`、`%(first_name)s`、`%(last_name)s`、`%(city)s` を使用してください。
- `CustomerId`、`IsActive`、`CreatedAt` はデータベース側の既定値に任せます。

#### 参照テーブル

```sql
CREATE TABLE Customers (
    CustomerId int IDENTITY(1, 1) PRIMARY KEY,
    Email nvarchar(255) NOT NULL UNIQUE,
    FirstName nvarchar(50) NOT NULL,
    LastName nvarchar(50) NOT NULL,
    City nvarchar(100) NULL,
    IsActive bit NOT NULL CONSTRAINT DF_Customers_IsActive DEFAULT 1,
    CreatedAt datetime2 NOT NULL CONSTRAINT DF_Customers_CreatedAt DEFAULT SYSDATETIME()
);
```

### 問題22：高額商品の割引追加

- 関数：`q22_insert_discounted_products`
- `UnitPrice` が5000以上の商品を、`ProductDiscounts` への追加候補にしてください。
- 追加する列は、順に `ProductId`、`DiscountRate`、`StartDate`、`EndDate` です。
- 割引率は `0.10`、開始日はSQL Server上の今日、終了日は開始日の30日後とします。
- 今日が開始日から終了日までの範囲内にある割引が、その商品にすでに存在する場合は
  追加しないでください。日付範囲は両端を含みます。

#### 参照テーブル

```sql
CREATE TABLE Products (
    ProductId int PRIMARY KEY,
    ProductName nvarchar(200) NOT NULL,
    CategoryId int NOT NULL REFERENCES Categories(CategoryId),
    UnitPrice decimal(10, 2) NOT NULL CHECK (UnitPrice >= 0),
    StockQuantity int NOT NULL CHECK (StockQuantity >= 0),
    IsActive bit NOT NULL CONSTRAINT DF_Products_IsActive DEFAULT 1
);

CREATE TABLE ProductDiscounts (
    DiscountId int IDENTITY(1, 1) PRIMARY KEY,
    ProductId int NOT NULL REFERENCES Products(ProductId),
    DiscountRate decimal(5, 4) NOT NULL CHECK (DiscountRate > 0 AND DiscountRate < 1),
    StartDate date NOT NULL,
    EndDate date NOT NULL,
    CHECK (StartDate <= EndDate)
);
```

### 問題23：在庫切れ商品の販売停止

- 関数：`q23_update_inactive_products`
- `StockQuantity` が `0` の商品だけを対象にしてください。
- 対象商品の `IsActive` を `0` に更新してください。
- その他の列は変更しないでください。

#### 参照テーブル

```sql
CREATE TABLE Products (
    ProductId int PRIMARY KEY,
    ProductName nvarchar(200) NOT NULL,
    CategoryId int NOT NULL REFERENCES Categories(CategoryId),
    UnitPrice decimal(10, 2) NOT NULL CHECK (UnitPrice >= 0),
    StockQuantity int NOT NULL CHECK (StockQuantity >= 0),
    IsActive bit NOT NULL CONSTRAINT DF_Products_IsActive DEFAULT 1
);
```

### 問題24：Booksカテゴリの値上げ

- 関数：`q24_update_category_prices`
- `Products` と `Categories` をカテゴリIDで対応付け、カテゴリ名が
  「Books」の商品だけを対象にしてください。
- 対象商品の `UnitPrice` を現在価格の110%に更新してください。
- 更新後の価格は小数第2位に丸めてください。
- その他のカテゴリと列は変更しないでください。

#### 参照テーブル

```sql
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
```

### 問題25：期限切れ割引の削除

- 関数：`q25_delete_expired_discounts`
- `ProductDiscounts` のうち、`EndDate` がSQL Server上の今日より前の行を
  削除してください。
- 終了日が今日の割引は削除しないでください。

#### 参照テーブル

```sql
CREATE TABLE ProductDiscounts (
    DiscountId int IDENTITY(1, 1) PRIMARY KEY,
    ProductId int NOT NULL REFERENCES Products(ProductId),
    DiscountRate decimal(5, 4) NOT NULL CHECK (DiscountRate > 0 AND DiscountRate < 1),
    StartDate date NOT NULL,
    EndDate date NOT NULL,
    CHECK (StartDate <= EndDate)
);
```

### 問題26：注文履歴がない非アクティブ顧客の削除

- 関数：`q26_delete_customers_without_orders`
- `IsActive` が `0` で、かつ `Orders` に注文が1件も存在しない顧客だけを
  削除してください。
- 非アクティブでも注文履歴がある顧客、およびアクティブな顧客は削除しないで
  ください。

#### 参照テーブル

```sql
CREATE TABLE Customers (
    CustomerId int IDENTITY(1, 1) PRIMARY KEY,
    Email nvarchar(255) NOT NULL UNIQUE,
    FirstName nvarchar(50) NOT NULL,
    LastName nvarchar(50) NOT NULL,
    City nvarchar(100) NULL,
    IsActive bit NOT NULL CONSTRAINT DF_Customers_IsActive DEFAULT 1,
    CreatedAt datetime2 NOT NULL CONSTRAINT DF_Customers_CreatedAt DEFAULT SYSDATETIME()
);

CREATE TABLE Orders (
    OrderId int IDENTITY(1, 1) PRIMARY KEY,
    CustomerId int NOT NULL REFERENCES Customers(CustomerId),
    OrderDate datetime2 NOT NULL,
    Status varchar(20) NOT NULL CHECK (Status IN ('Pending', 'Paid', 'Shipped', 'Cancelled'))
);
```

### 問題27：在庫データの反映

- 関数：`q27_upsert_inventory`
- `InventoryImport` を入力、`Products` を更新先とし、`ProductId` で
  対応を判定してください。
- 同じ `ProductId` が存在する場合は、`StockQuantity` だけを入力側の値で
  更新してください。
- 存在しない場合は、`ProductId`、`ProductName`、`CategoryId`、`UnitPrice`、
  `StockQuantity` を入力側から追加し、`IsActive` は `1` としてください。
- 入力側に存在しない既存商品は、更新も削除もしないでください。

#### 参照テーブル

```sql
CREATE TABLE Products (
    ProductId int PRIMARY KEY,
    ProductName nvarchar(200) NOT NULL,
    CategoryId int NOT NULL REFERENCES Categories(CategoryId),
    UnitPrice decimal(10, 2) NOT NULL CHECK (UnitPrice >= 0),
    StockQuantity int NOT NULL CHECK (StockQuantity >= 0),
    IsActive bit NOT NULL CONSTRAINT DF_Products_IsActive DEFAULT 1
);

CREATE TABLE InventoryImport (
    ProductId int PRIMARY KEY,
    ProductName nvarchar(200) NOT NULL,
    CategoryId int NOT NULL,
    UnitPrice decimal(10, 2) NOT NULL,
    StockQuantity int NOT NULL
);
```

## 発展

### 問題28：カテゴリ別の売上最大商品

- 関数：`q28_best_selling_product_per_category`
- CTEと順位付けを使用してください。
- 商品ごとに、全注文明細の「数量×明細単価」を合計してください。
- 売上明細がない商品も対象に含め、その売上金額は `0` としてください。
- カテゴリごとに売上金額が最大の商品だけを取得してください。
- 最大額が同じ商品が複数ある場合は、すべて取得してください。
- 出力列は、順に `CategoryId`、`CategoryName`、`ProductId`、`ProductName`、
  `SalesAmount` としてください。順位そのものは出力しません。
- `CategoryId`、`ProductId` の順ですべて昇順に並べてください。

#### 参照テーブル

```sql
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

CREATE TABLE OrderDetails (
    OrderId int NOT NULL REFERENCES Orders(OrderId),
    ProductId int NOT NULL REFERENCES Products(ProductId),
    Quantity int NOT NULL CHECK (Quantity > 0),
    UnitPrice decimal(10, 2) NOT NULL CHECK (UnitPrice >= 0),
    CONSTRAINT PK_OrderDetails PRIMARY KEY (OrderId, ProductId)
);
```

### 問題29：顧客の注文間隔

- 関数：`q29_customer_order_interval`
- CTEと、直前行の値を参照するウィンドウ関数を使用してください。
- 顧客ごとに、`OrderDate`、同日時なら `OrderId` の昇順で注文履歴を
  並べ、直前の注文日時を求めてください。
- 出力列は、順に `CustomerId`、`OrderId`、`OrderDate`、
  `PreviousOrderDate`、`DaysSincePreviousOrder` としてください。
- `DaysSincePreviousOrder` は前回注文日から今回注文日までの日数です。
- 各顧客の最初の注文では、`PreviousOrderDate` と
  `DaysSincePreviousOrder` を `NULL` としてください。
- 最終結果も `CustomerId`、`OrderDate`、`OrderId` の順ですべて昇順に
  並べてください。

#### 参照テーブル

```sql
CREATE TABLE Orders (
    OrderId int IDENTITY(1, 1) PRIMARY KEY,
    CustomerId int NOT NULL REFERENCES Customers(CustomerId),
    OrderDate datetime2 NOT NULL,
    Status varchar(20) NOT NULL CHECK (Status IN ('Pending', 'Paid', 'Shipped', 'Cancelled'))
);
```

### 問題30：月・カテゴリ別売上ダッシュボード

- 関数：`q30_sales_dashboard`
- CTEを使用し、`Orders`、`OrderDetails`、`Products`、`Categories` を
  結合してください。
- 月とカテゴリの組み合わせごとに、全注文明細の「数量×明細単価」を
  合計してください。売上が存在しない組み合わせを補完する必要はありません。
- `SalesMonth` は各注文月の1日を表す日付値としてください。
- 同じカテゴリについて、売上月順で1つ前に存在する集計行の売上を
  `PreviousMonthAmount` としてください。
- 前回比率 `GrowthRatePercent` は、
  「今回売上と前回売上の差÷前回売上×100」で求め、小数第2位までの
  `decimal(10, 2)` としてください。
- 前の集計行がない場合、または前回売上が `0` の場合、
  `GrowthRatePercent` は `NULL` としてください。
- 出力列は、順に `SalesMonth`、`CategoryId`、`CategoryName`、
  `SalesAmount`、`PreviousMonthAmount`、`GrowthRatePercent` としてください。
- `SalesMonth`、`CategoryId` の順ですべて昇順に並べてください。

#### 参照テーブル

```sql
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
```
