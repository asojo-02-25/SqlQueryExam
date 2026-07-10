"""Learner answer slots.

Each function must return one SQL Server query string. Copy a function from
``solutions.py`` only after attempting the problem yourself.
"""


def _todo(number: int) -> str:
    return f"-- TODO: 問題 {number:02d} のSQLをここに書いてください"


def q01_select_all_products() -> str:
    return """
    SELECT * FROM Products
    ORDER BY ProductId;
    """

def q02_select_product_columns() -> str: return _todo(2)
def q03_active_products() -> str: return _todo(3)
def q04_products_in_price_range() -> str: return _todo(4)
def q05_product_name_search() -> str: return _todo(5)
def q06_distinct_customer_cities() -> str: return _todo(6)
def q07_recent_orders() -> str: return _todo(7)
def q08_customer_display_name() -> str: return _todo(8)
def q09_order_amounts() -> str: return _todo(9)
def q10_products_with_category() -> str: return _todo(10)
def q11_customers_and_orders() -> str: return _todo(11)
def q12_order_detail_report() -> str: return _todo(12)
def q13_product_count_by_category() -> str: return _todo(13)
def q14_order_total_by_order() -> str: return _todo(14)
def q15_large_order_customers() -> str: return _todo(15)
def q16_products_above_average_price() -> str: return _todo(16)
def q17_customers_without_orders() -> str: return _todo(17)
def q18_rank_products_by_category() -> str: return _todo(18)
def q19_monthly_sales() -> str: return _todo(19)
def q20_customer_sales_summary() -> str: return _todo(20)


def q21_insert_customer() -> str:
    """Use parameters: %(email)s, %(first_name)s, %(last_name)s, %(city)s."""
    return _todo(21)


def q22_insert_discounted_products() -> str: return _todo(22)
def q23_update_inactive_products() -> str: return _todo(23)
def q24_update_category_prices() -> str: return _todo(24)
def q25_delete_expired_discounts() -> str: return _todo(25)
def q26_delete_customers_without_orders() -> str: return _todo(26)
def q27_upsert_inventory() -> str: return _todo(27)
def q28_best_selling_product_per_category() -> str: return _todo(28)
def q29_customer_order_interval() -> str: return _todo(29)
def q30_sales_dashboard() -> str: return _todo(30)
