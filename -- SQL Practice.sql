USE FlashDB_Practice;

-- 0. 全件表示

SELECT * FROM tbl_Branch

-- 3.1 branchID > 10 のラベルを表示

SELECT * FROM dbo.tbl_Branch WHERE BranchID > 10;

-- 3.2 BranchCode > 100 のラベルを削除dbo

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
    WHEN D THEN '戸建て' END) AS 属性

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

-- 7.6 練習問題

-- 7-3

-- 1.
INSERT INTO 頭数集計テーブル (飼育県, 頭数) SELECT 飼育県, COUNT(*) FROM 個体識別テーブル GROUP BY 飼育県;

-- 2. 
SELECT 県名 AS 都道府県名, 個体識別番号,
CASE 雌雄コード 
    WHEN '1' THEN '雄'
    WHEN '2' THEN '雌' END AS 雌雄
FROM 個体識別 
WHERE 県名 IN (SELECT 県名 FROM 頭数集計 ORDER BY 頭数 DESC OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY) 

-- 3. 
SELECT 都道府県名, 個体識別番号,
CASE 品種 
    WHEN '01' THEN '乳用種'
    WHEN '02' THEN '肉用種'
    WHEN '03' THEN '交雑種' END AS 品種, 
出生日, 母牛番号 
FROM 個体識別 WHERE 品種コード IN (SELECT 個体識別番号 FROM 個体識別 WHERE 品種コード = '01')

-- 8.6 練習問題

-- 8-2

-- 1.
SELECT 社員番号, 社員.名前 AS 名前, 部署.名前 AS 部署名 FROM 社員 JOIN 部署 ON 社員.部署ID = 部署.部署ID;

-- 2. 
SELECT A.社員番号, A.名前, B.名前 AS 上司名 FROM 社員 AS A LEFT JOIN 社員 AS B ON A.上司ID = B.社員番号

-- 3. 
SELECT A.社員番号, A.名前, B.名前 AS 部署名, C.名前 AS 支店 
FROM 社員 AS A 
    JOIN 部署 AS B 
    ON A.部署ID = B.部署ID 
    JOIN 支店 AS C 
    ON A.勤務地ID = C.支店ID;

-- 4. 
SELECT B.支店ID AS 支店コード, B.名前 AS 支店名, E.名前 AS 支店長名, C.社員数
FROM 支店 AS B 
    JOIN 社員 AS E
    ON B.支店長ID = E.社員番号
    JOIN (SELECT E.勤務地ID, COUNT(社員番号) FROM 社員 GROUP BY E.勤務地ID) AS C
    ON B.支店ID = C.勤務地ID;

-- 5. 
SELECT E1.社員番号, E1.名前, B1.名前 AS 本人勤務地, B2.名前 AS 上司勤務地 
FROM 社員 AS E1
    JOIN 社員 AS E2
    ON E1.上司ID = E2.社員番号
    AND E1.勤務地ID <> E2.勤務地ID
    JOIN 支店 AS B1 
    ON E1.勤務地ID = B1.支店ID 
    JOIN 支店 AS B2 
    ON E2.勤務地ID = B2.支店ID

-- 9.5

-- 1. 
BEGIN TRANSACTION;

INSERT INTO 家計簿 VALUES ('2024-03-20', '住居費', '4月の家賃', 0, 60000);

INSERT INTO 家計簿 VALUES ('2024-03-20', '手数料', '4月の家賃の振り込み', 0, 420);

COMMIT;

-- 2. 
BEGIN TRANSACTION;
DELETE FROM 家計簿 WHERE 日付 = '2024-03-20';
ROLLBACK;

-- 3. 
BEGIN TRANSACTION;
LOCK TABLE 家計簿 IN EXCLUSIVE MODE;
INSERT INTO 統計結果 SELECT 'データ件数', COUNT(*) FROM 家計簿;
INSERT INTO 統計結果 SELECT '出金額平均', AVG(出金額) FROM 家計簿;
COMMIT;

-- 9.6 練習問題
BEGIN TRANSACTION;
INSERT INTO 受注 (注文番号, 日付, 顧客番号, 商品番号, 注文数)
    VALUES ('1192296', '2024-03-20', '8828', '0008', 12);

UPDATE 在庫 SET 残数 = 残数 - 12 WHERE 商品番号 = '0008';
COMMIT;

-- 10.2

CREATE TABLE 家計簿(
    日付    DATE            NOT NULL,
    費用ID  INTEGER         PRIMARY KEY,
    外部ID  INTEGER         REFERENCES 費用(ID), 
    メモ    VARCHAR(100)    DEFAULT '不明' NOT NULL,
    入金額  INTEGER         DEFAULT 0 CHECK (入金額 >= 0),
    出金額  INTEGER         DEFAULT 0 CHECK (出金額 >= 0)
)

SELECT * FROM 家計簿;

ALTER TABLE 家計簿 ADD 関連日 DATE;
ALTER TABLE 家計簿 DROP COLUMN 関連日;

DROP TABLE IF EXISTS 家計簿;

-- 11.5 練習問題

-- 11-2 

-- 1. 
CREATE INDEX 学生IDX ON 名前;       -- WHERE句の検索に利用
CREATE INDEX 学部IDX ON 学部ID;     -- JOIN句の結合に利用

-- 2.
CREATE VIEW 学部付き学生 AS 
    SELECT S.学籍番号, S.名前, S.生年月日, S.血液型, S.学部ID, S.登録順, B.名前 AS 学部
        FROM 学生 AS S
        JOIN 学部 AS B 
        ON S.学部ID = B.ID;

-- 3. 
INSERT INTO 学生(学籍番号, 名前, 生年月日, 血液型, 学部ID, 登録順)
    VALUES(B1101022, '古島進', '2004-02-12', 'A', 'K', 
    (SELECT NEXTVAL ('ISTD')))

