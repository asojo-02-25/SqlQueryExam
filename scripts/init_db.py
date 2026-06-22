"""Create and seed the exercise database."""

from pathlib import Path
import sys


PROJECT_ROOT = Path(__file__).resolve().parents[1]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from sqlquery_exam.config import DATABASE
from sqlquery_exam.db import connect, execute_script


def ensure_database_exists() -> None:
    connection = connect(database="master", autocommit=True)
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT DB_ID(%s) AS DatabaseId", (DATABASE.database,))
            if cursor.fetchone()["DatabaseId"] is None:
                database_name = DATABASE.database.replace("]", "]]")
                cursor.execute(f"CREATE DATABASE [{database_name}]")
    finally:
        connection.close()


def main() -> None:
    if not DATABASE.is_configured:
        raise SystemExit("SQLSERVER_PASSWORD を設定してください。")
    ensure_database_exists()
    execute_script(PROJECT_ROOT / "sql" / "setup.sql")
    print(f"{DATABASE.database} を初期化しました。")


if __name__ == "__main__":
    main()
