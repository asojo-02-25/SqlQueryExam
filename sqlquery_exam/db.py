"""Small pymssql helpers used by setup scripts and integration tests."""

from collections.abc import Iterator
from contextlib import contextmanager
from pathlib import Path
from typing import Any

import pymssql

from sqlquery_exam.config import DATABASE, DatabaseConfig


def connect(
    config: DatabaseConfig = DATABASE,
    *,
    database: str | None = None,
    autocommit: bool = False,
):
    return pymssql.connect(
        server=config.server,
        port=str(config.port),
        user=config.user,
        password=config.password,
        database=database or config.database,
        login_timeout=config.login_timeout,
        as_dict=True,
        autocommit=autocommit,
    )


@contextmanager
def transaction(config: DatabaseConfig = DATABASE) -> Iterator[Any]:
    connection = connect(config)
    try:
        yield connection
        connection.commit()
    except Exception:
        connection.rollback()
        raise
    finally:
        connection.close()


def execute_script(
    path: Path,
    config: DatabaseConfig = DATABASE,
    *,
    database: str | None = None,
    autocommit: bool = False,
) -> None:
    """Execute a SQL Server script, splitting batches on standalone GO lines."""
    import re

    script = path.read_text(encoding="utf-8")
    batches = re.split(r"(?im)^\s*GO\s*$", script)
    connection = connect(config, database=database, autocommit=autocommit)
    try:
        with connection.cursor() as cursor:
            for batch in batches:
                if batch.strip():
                    cursor.execute(batch)
        if not autocommit:
            connection.commit()
    except Exception:
        if not autocommit:
            connection.rollback()
        raise
    finally:
        connection.close()


def fetch_all(query: str, parameters: dict[str, Any] | None = None) -> list[dict[str, Any]]:
    with transaction() as connection:
        with connection.cursor() as cursor:
            cursor.execute(query, parameters)
            return list(cursor.fetchall())
