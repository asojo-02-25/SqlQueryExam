USE FlashDB_Practice;

-- 0. 全件表示

SELECT * FROM tbl_Branch

-- 3.1 branchID > 10 のラベルを表示

SELECT * FROM dbo.tbl_Branch WHERE BranchID > 10;

-- 3.2 BranchCode > 100 のラベルを削除

BEGIN TRAN;

DELETE FROM dbo.tbl_Branch
WHERE BranchCode > 100;

-- 結果確認

SELECT * FROM dbo.tbl_Branch;

-- ロールバック

ROLLBACK;

-- 3.3 null の判定

SELECT * FROM dbo.tbl_Branch
WHERE ZipCode IS NULL;

-- 3.4 LIKE演算子

SELECT * FROM dbo.tbl_Branch
WHERE Name LIKE '%立川%';

-- 3.5 Between演算子

SELECT * FROM dbo.tbl_Branch
WHERE CompanyID BETWEEN 10 AND 20;

-- 3.6 IN演算子

SELECT * FROM dbo.tbl_Branch
WHERE CompanyID IN (1, 2, 15);

SELECT * FROM dbo.tbl_Branch
WHERE CompanyID NOT IN (1, 2, 15);

-- 3.7 論理演算子

SELECT * FROM dbo.tbl_Branch
WHERE Address LIKE '兵庫県%' AND ShortName LIKE '%神戸%';

-- 4.2 DISTINCT

SELECT DISTINCT CompanyID FROM dbo.tbl_Branch;

-- 4.4 EstablishDateが新しい順に10件取得

SELECT * FROM dbo.tbl_Branch ORDER BY EstablishDate DESC OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

-- 4.5 UNION

SELECT * FROM dbo.tbl_Branch WHERE BranchID >= 10

UNION ALL

SELECT * FROM dbo.tbl_Branch WHERE BranchID <= 10 ORDER BY BranchID ASC;

-- 4.6 EXCEPT(MINUS)

SELECT * FROM dbo.tbl_Branch

EXCEPT

SELECT * FROM dbo.tbl_Branch WHERE BranchID <= 10 ORDER BY BranchID ASC;

-- 4.7 INTERSECT

SELECT * FROM dbo.tbl_Branch WHERE BranchID >= 10

INTERSECT

SELECT * FROM dbo.tbl_Branch WHERE BranchID <= 10 ORDER BY BranchID ASC;

-- 5.2 CASE

SELECT *, 
    CASE WHEN EstablishDate < '2026-04-01' THEN '昨年度以前'
        ELSE '今年度'   
    END AS 年度管理
FROM dbo.tbl_Branch

-- 5.3 関数

SELECT Name, NameKana, Length(Name) AS 名前の長さ, Length(NamaKana) AS 読み仮名の長さ
FROM dbo.tbl_Branch;