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

-- 4.4 OFFSET - FETCH

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

-- 5.3 文字列に関する関数

-- LEN

SELECT Name, NameKana, LEN(Name) AS 名前の長さ, LEN(NameKana) AS 読み仮名の長さ
FROM dbo.tbl_Branch;

-- REPLACE

BEGIN TRANSACTION;

UPDATE dbo.tbl_Branch SET Phone1 = REPLACE(Phone1, 1000000000, '100-000-0000')

SELECT * FROM dbo.tbl_Branch;

ROLLBACK TRANSACTION;

-- SUBSTRING

SELECT BranchID, Address FROM dbo.tbl_Branch
WHERE SUBSTRING(Address, 1, 3) = '兵庫県';

-- CONCAT 

SELECT CONCAT(BranchCode, ':', Name)  AS '支店コード : 名前' FROM dbo.tbl_Branch ORDER BY BranchCode;

-- 5.5 数値に関する関数

-- ROUND

SELECT ZipCode, ROUND(CAST(ZipCode AS int), -6) AS '四捨五入した郵便番号' FROM dbo.tbl_Branch;

SELECT ZipCode, ROUND(CAST(ZipCode AS int), -6, 1) AS '切り捨てた郵便番号' FROM dbo.tbl_Branch;

SELECT ZipCode, POWER(ZipCode, 10) AS '郵便番号の10乗' FROM dbo.tbl_Branch;

-- 5.6 日付に関する関数

BEGIN TRANSACTION;

INSERT INTO dbo.tbl_Branch (BranchID, EstablishDate) VALUES (295, CURRENT_TIMESTAMP);

SELECT * FROM dbo.tbl_Branch;

ROLLBACK TRANSACTION;

-- 5.7 置換に関する関数

SELECT ZipCode, COALESCE(ZipCode, '未設定') AS 編集済み郵便番号 FROM dbo.tbl_Branch; 

-- 5.9 練習問題

-- 5-2-1
UPDATE 回答者 SET 国名 = CASE SUBSTRING(TRIM(メールアドレス), LEN(TRIM(メールアドレス))-1, 2)
                        WHEN 'jp' THEN '日本'
                        WHEN 'uk' THEN 'イギリス'
                        WHEN 'cn' THEN '中国'
                        WHEN 'fr' THEN 'フランス'
                        WHEN 'vn' THEN 'ベトナム'
                        END;

-- 5-2-2 

SELECT TRIM(メールアドレス), 
CONCAT(
CASE
    WHEN 年齢 >= 20 AND 年齢 < 30 THEN '20代'
    WHEN 年齢 >= 30 AND 年齢 < 40 THEN '30代'
    WHEN 年齢 >= 40 AND 年齢 < 50 THEN '40代'
    WHEN 年齢 >= 50 AND 年齢 < 60 THEN '50代' END, ':',

CASE 住居
    WHEN C THEN '集合住宅'
    WHEN D THEN '戸建て' END AS 属性

FROM 回答者

-- 5-3-1
UPDATE 受注 SET 文字数 = LEN(REPLACE(文字, ' ', ''))

-- 5-3-2


-- 6.1 集計関数

SELECT SUM(LEN(Address)), AVG(LEN(Address)), MAX(LEN(Address)), MIN(LEN(Address))
FROM dbo.tbl_Branch;

SELECT COUNT(*) FROM dbo.tbl_Branch;
SELECT COUNT(BranchID) FROM dbo.tbl_Branch;
SELECT COUNT(ZipCode) FROM dbo.tbl_Branch;

-- 6.2 nullの取り扱い

SELECT SUM(LEN(FAX2)), AVG(LEN(Address)), MAX(LEN(Address)), MIN(LEN(Address))
FROM dbo.tbl_Branch;

SELECT SUM(COALESCE(FAX2, 0)), AVG(COALESCE(FAX2, 0)), MAX(COALESCE(FAX2, 0)), MIN(COALESCE(FAX2, 0))
FROM dbo.tbl_Branch;