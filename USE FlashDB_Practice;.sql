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