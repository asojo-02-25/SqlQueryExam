# SQL Server DML 練習問題

プログラミング初学者が、SQL Server の基本的な検索から DML、CTE、
ウィンドウ関数を使う総合問題まで段階的に学ぶための教材です。

## 学習範囲

全30問を次の順で扱います。

1. `SELECT`、列、別名、`WHERE`、`LIKE`、`BETWEEN`、`DISTINCT`
2. `ORDER BY`、`TOP`、計算列、文字列操作
3. `INNER JOIN`、`LEFT JOIN`、複数テーブル結合
4. `GROUP BY`、`COUNT`、`SUM`、`HAVING`
5. サブクエリ、`EXISTS`、CTE、ウィンドウ関数、日付処理
6. `INSERT`、`INSERT SELECT`、`UPDATE`、`DELETE`、`MERGE`
7. 複数の技法を組み合わせる売上分析

問題文と順番は `sqlquery_exam/catalog.py`、解答欄は
`sqlquery_exam/exercises.py`、参照解答は
`sqlquery_exam/solutions.py` にあります。

## セットアップ

```powershell
uv sync
uv run python scripts/list_problems.py
```

各問題では、引数なしの関数が SQL 文字列を返すように
`exercises.py` を編集します。問題21だけは SQL インジェクションを避けるため、
pymssql の名前付きプレースホルダーをSQL内に記述します。

## テスト

まず、教材と参照解答が正常であることを確認します。

```powershell
uv run python -m unittest discover -s tests -v
```

自分の解答をテストするには対象モジュールを切り替えます。

```powershell
$env:SQL_EXAM_MODULE = "sqlquery_exam.exercises"
uv run python -m unittest tests.test_queries -v
```

未回答の関数には `TODO` があるため、契約テストは未回答数を表示して失敗します。
まず問題を実装し、問題一覧と失敗した `subTest` の番号を照合してください。

標準の高速テストはデータベースを必要とせず、関数の存在、戻り値、
命令の種類、パラメータ化を検査します。SQLとしての実行結果は次の統合テストで
参照解答と比較します。

## SQL Server 接続

接続情報は環境変数で設定します。パスワードをソースコードへ保存しないでください。
プロジェクト直下の `.env` も自動的に読み込みます。OS環境変数と `.env` の両方に
同じ設定がある場合は、OS環境変数を優先します。

```dotenv
SQLSERVER_HOST=localhost
SQLSERVER_PORT=1433
SQLSERVER_USER=sa
SQLSERVER_PASSWORD=your-strong-password
SQLSERVER_DATABASE=SqlQueryExam
SQLSERVER_LOGIN_TIMEOUT=10
```

`sqlquery_exam/config.py` の `DatabaseConfig` がこれらを読み込みます。
初期データは学習用データベースを削除せず、テーブルを再作成します。

```powershell
uv run python scripts/init_db.py
```

SQL Server に対して参照解答の検索問題を実行するには:

```powershell
$env:SQLSERVER_TESTS = "1"
uv run python -m unittest tests.test_database -v
```

自分の解答を実行するには:

```powershell
$env:SQL_EXAM_MODULE = "sqlquery_exam.exercises"
uv run python -m unittest tests.test_database -v
```

## 各問題のテスト方法

検索問題（問題1〜20）は、回答した関数だけを実行して結果を確認できます。
次の `q01_select_all_products` を、`catalog.py` にある確認したい問題の関数名に
置き換えてください。

```powershell
uv run python -c "from sqlquery_exam.db import fetch_all; from sqlquery_exam.exercises import q01_select_all_products; print(*fetch_all(q01_select_all_products()), sep='\n')"
```

例えば問題2を確認する場合は、`q01_select_all_products` の2か所を
`q02_select_product_columns` に置き換えます。このコマンドは自分のSQLを
SQL Serverで実行し、取得した各行を表示します。実行前に「何行・何列になり、
どの順番で並ぶか」を予想してから結果を確認してください。

また、以下のコマンドより全選択時のラベルを出力、現在の問題との比較を行い、ソートの正確性を確認してください。

```powershell
uv run python -c "from sqlquery_exam.db import fetch_all; print(*fetch_all('SELECT * FROM Products'), sep='\n')"
```

PowerShellで設定した環境変数は現在のプロセスでのみ有効です。統合テストでは、
次のように環境変数を設定してから実行します。

```powershell
$env:SQLSERVER_TESTS = "1"
$env:SQL_EXAM_MODULE = "sqlquery_exam.exercises"
uv run python -m unittest tests.test_database -v
```

全問用の `unittest` は未回答の `TODO` がある間は失敗します。学習途中では、
まず上記の個別実行で確認し、解答がそろってから全体テストを実行してください。

更新系の問題21〜27は、誤操作を避けるため自動統合テストから除外しています。
SQL Server Management Studio などで `BEGIN TRANSACTION` を開始し、結果を
`SELECT` で確認してから `ROLLBACK` してください。

## pymssql のパラメータ (21問目以降で使用)

値を文字列結合でSQLへ埋め込まず、次のように別途渡します。

```python
from sqlquery_exam.db import transaction
from sqlquery_exam.exercises import q21_insert_customer

values = {
    "email": "taro@example.com",
    "first_name": "太郎",
    "last_name": "山田",
    "city": "東京",
}

with transaction() as connection:
    with connection.cursor() as cursor:
        cursor.execute(q21_insert_customer(), values)
```

## 推奨する進め方

問題番号順に解き、各SQLを実行する前に「何行・何列になるか」を予想します。
検索系では並び順と `NULL`、集計では粒度、更新系では対象行を同じ `WHERE` の
`SELECT` で確認する習慣を付けてください。
