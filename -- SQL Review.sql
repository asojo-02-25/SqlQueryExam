-- Review
USE FlashDB_Practice;

-- 0. 全件表示

SELECT * FROM tbl_Branch;

-- 0.1 接続DB確認

SELECT DB_NAME() AS 現在のデータベース;

-- 1.4 練習問題

-- 1-3 
-- 1. ID = 1 の行を検索しすべて表示

SELECT * FROM tbl_Branch WHERE CompanyID = 1; 

-- 2. BranchCodeが10を超える行をすべて削除

-- トランザクションの開始

BEGIN TRANSACTION;

DELETE FROM tbl_Branch WHERE BranchCode > 10;

-- 変更の確認

SELECT * FROM dbo.tbl_Branch;

-- 変更の取り消し

ROLLBACK TRANSACTION;

-- 3. BranchID = 47 の行の ZipCode を3000000 に更新

BEGIN TRANSACTION;

UPDATE tbl_Branch SET ZipCode = '3000000' WHERE BranchID = 47;

SELECT * FROM dbo.tbl_Branch;

INSERT INTO dbo.tbl_Branch(BranchID, CompanyID, BranchCode, Name) VALUES(0, 0, 0, 'test'); 

SELECT * FROM dbo.tbl_Branch;

ROLLBACK TRANSACTION;

-- 2.10 練習問題

-- 2-3

-- 1.2.  全行取得

SELECT * FROM dbo.tbl_Branch;

-- 3. BranchID, CompanyIDについて、「支店ID」「会社ID」をつけて全行を表示

SELECT BranchID AS '支店ID'  , CompanyID AS '会社ID' FROM dbo.tbl_Branch;

-- 2-4 データの挿入

-- INSERT INTO 都道府県 (コード, 地域, 都道府県名, 面積) VALUES (26, '近畿', '京都', 4613);

-- 2-5 null部分へのデータの追加

-- UPDATE 都道府県 SET 県庁所在地 = '京都' WHERE コード = 26;tbl

-- 2-6 挿入行の削除

-- DELETE FROM 都道府県 WHERE コード = 26; 

-- 3.7 練習問題

-- 3-1 

-- 1. 
SELECT * FROM 気象観測 WHERE 月 = 6;

-- 2.
SELECT * FROM 気象観測 WHERE 月 <> 6;

-- 3. 
SELECT * FROM 気象観測 WHERE 降水量 < 100;

-- 4. 
SELECT * FROM 気象観測 WHERE 降水量 > 200;

-- 5. 
SELECT * FROM 気象観測 WHERE 最高気温 >= 30;

-- 6.
SELECT * FROM 気象観測 WHERE 最低気温 <= 0;

-- 7. 
SELECT * FROM 気象観測 WHERE 月 IN (3, 5, 7);

-- 8. 
SELECT * FROM 気象観測 WHERE 月 NOT IN (3, 5, 7);

-- 9. 
SELECT * FROM 気象観測 WHERE 降水量 <= 100 AND 湿度 < 50;

-- 10. 
SELECT * FROM 気象観測 WHERE 最低気温 <= 5 OR 最高気温 > 35;

-- 11. 
SELECT * FROM 気象観測 WHERE 湿度 BETWEEN 60 AND 79;

-- 12.
SELECT * FROM 気象観測 WHERE 月 IS NULL OR 降水量 IS NULL OR 最高気温 IS NULL OR 最低気温 IS NULL OR 湿度 IS NULL;


-- 3-3

-- 1. 
SELECT * FROM 成績表;

-- 2. 
INSERT INTO 成績表 (学籍番号, 学生名, 法学, 経済学, 哲学, 情報倫理, 外国語) VALUES ('S001', '織田信長', 77, 55, 80, 75, 93);

-- 3. 
UPDATE 成績表 SET 法学 = 85, 哲学 = 67 WHERE 学籍番号 = 'S001';

-- 4. 
UPDATE 成績表 SET 外国語 = 81 WHERE 学籍番号 IN ('A002', 'E003');

-- 5. 
UPDATE 成績表 SET 総合成績 = 'A' WHERE 法学 >= 80 AND 経済学 >= 80 AND 哲学 >= 80 AND 情報倫理 >= 80 AND 外国語 >= 80;
UPDATE 成績表 SET 総合成績 = 'B' WHERE (法学 >= 80 OR 外国語 >= 80) AND (経済学 >= 80 OR 哲学 >= 80) AND 総合成績 IS NULL;
UPDATE 成績表 SET 総合成績 = 'D' WHERE 法学 < 50 AND 経済学 < 50 AND 哲学 < 50 AND 情報倫理 < 50 AND 外国語 < 50 AND 総合成績 IS NULL;
UPDATE 成績表 SET 総合成績 = 'C' WHERE 総合成績 IS NULL;

-- 6. 
DELETE FROM 成績表 WHERE 法学 <> 0 OR 経済学 <> 0 OR 哲学 <> 0 OR 情報倫理 <> 0 OR 外国語 <> 0;


-- 4.7 練習問題

-- 4-1

-- 1. 
SELECT * FROM 注文履歴 ORDER BY 日付 DESC;

-- 2. 
SELECT * FROM 注文履歴 WHERE 日付 < '2024-01-01' ORDER BY 商品名 ASC;

-- 3.

SELECT 注文番号, 注文枝番, 注文金額 FROM 注文履歴 WHERE 分類 = 1 ORDER BY 注文金額 OFFSET 1 ROWS FETCH NEXT 3 ROWS ONLY;

-- 4. 
SELECT 日付, 商品名、単価, 数量, 注文金額 FROM 注文履歴 WHERE 分類 = 3 AND 数量 >= 2 ORDER BY 数量 DESC;

-- 5. 
SELECT 分類, 商品名, サイズ, 単価 FROM 註文履歴 WHERE 分類 = 1
UNION
SELECT 分類, 商品名, NULL, 単価 FROM 註文履歴 WHERE 分類 IN (2, 3)
ORDER BY 分類 ASC, 商品名 ASC;

-- 4-2 

-- 1. 
SELECT * FROM 偶数テーブル
UNION ALL 
SELECT * FROM 奇数テーブル;

-- 2. 
SELECT * FROM 整数テーブル
EXCEPT ALL
SELECT * FROM 偶数テーブル;


-- 3. 
SELECT * FROM 整数テーブル
INTERSECT ALL
SELECT * FROM 偶数テーブル;

-- 4. 
SELECT * FROM 偶数テーブル
INTERSECT ALL
SELECT * FROM 奇数テーブル;
