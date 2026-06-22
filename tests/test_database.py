"""Optional smoke tests against SQL Server.

Run only after setting SQLSERVER_TESTS=1 and initializing the database.
Mutation queries are deliberately excluded here; learners should inspect their
effects inside an explicit transaction before committing.
"""

import importlib
import os
import unittest

from sqlquery_exam.catalog import PROBLEMS
from sqlquery_exam.config import DATABASE
from sqlquery_exam.db import connect
from sqlquery_exam import solutions


MODULE_NAME = os.getenv("SQL_EXAM_MODULE", "sqlquery_exam.solutions")
QUERY_MODULE = importlib.import_module(MODULE_NAME)


@unittest.skipUnless(
    os.getenv("SQLSERVER_TESTS") == "1" and DATABASE.is_configured,
    "SQLSERVER_TESTS=1 と接続環境変数を設定した場合のみ実行します",
)
class SqlServerSelectTests(unittest.TestCase):
    def test_select_query_results_match_reference(self) -> None:
        connection = connect()
        try:
            with connection.cursor() as cursor:
                for problem in PROBLEMS:
                    if problem.mutates_data:
                        continue
                    with self.subTest(problem=problem.number):
                        cursor.execute(getattr(solutions, problem.function_name)())
                        expected_columns = tuple(column[0] for column in cursor.description)
                        expected_rows = cursor.fetchall()

                        cursor.execute(getattr(QUERY_MODULE, problem.function_name)())
                        actual_columns = tuple(column[0] for column in cursor.description)
                        actual_rows = cursor.fetchall()

                        self.assertEqual(actual_columns, expected_columns)
                        self.assertEqual(actual_rows, expected_rows)
        finally:
            connection.rollback()
            connection.close()


if __name__ == "__main__":
    unittest.main()
