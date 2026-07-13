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
