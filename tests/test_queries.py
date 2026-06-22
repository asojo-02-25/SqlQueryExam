"""Fast tests that do not require a running database."""

import importlib
import inspect
import os
import re
import unittest

from sqlquery_exam.catalog import PROBLEMS


MODULE_NAME = os.getenv("SQL_EXAM_MODULE", "sqlquery_exam.solutions")
QUERY_MODULE = importlib.import_module(MODULE_NAME)


class QueryContractTests(unittest.TestCase):
    def test_all_problem_functions_exist(self) -> None:
        for problem in PROBLEMS:
            with self.subTest(problem=problem.number):
                self.assertTrue(hasattr(QUERY_MODULE, problem.function_name))
                self.assertTrue(callable(getattr(QUERY_MODULE, problem.function_name)))

    def test_all_functions_return_nonempty_sql(self) -> None:
        for problem in PROBLEMS:
            with self.subTest(problem=problem.number):
                function = getattr(QUERY_MODULE, problem.function_name)
                self.assertEqual(len(inspect.signature(function).parameters), 0)
                query = function()
                self.assertIsInstance(query, str)
                self.assertTrue(query.strip())
                self.assertNotIn("TODO", query.upper())

    def test_query_starts_with_expected_statement(self) -> None:
        expected = {
            **{number: ("SELECT", "WITH") for number in range(1, 21)},
            21: ("INSERT",),
            22: ("INSERT",),
            23: ("UPDATE",),
            24: ("UPDATE",),
            25: ("DELETE",),
            26: ("DELETE",),
            27: ("MERGE",),
            28: ("WITH",),
            29: ("WITH",),
            30: ("WITH",),
        }
        for problem in PROBLEMS:
            query = getattr(QUERY_MODULE, problem.function_name)()
            first_word = re.match(r"\s*([A-Za-z]+)", query)
            with self.subTest(problem=problem.number):
                self.assertIsNotNone(first_word)
                self.assertIn(first_word.group(1).upper(), expected[problem.number])

    def test_insert_customer_uses_bound_parameters(self) -> None:
        query = QUERY_MODULE.q21_insert_customer()
        for name in ("email", "first_name", "last_name", "city"):
            self.assertIn(f"%({name})s", query)
        self.assertNotIn("test@example.com", query)


if __name__ == "__main__":
    unittest.main()
