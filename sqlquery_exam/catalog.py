"""Exercise descriptions and ordering."""

from dataclasses import dataclass


@dataclass(frozen=True)
class Problem:
    number: int
    function_name: str
    title: str
    requirement: str
    level: str
    mutates_data: bool = False


PROBLEMS = (
    Problem(1, "q01_select_all_products", "全列の取得", "Products の全列を ProductId 順で取得する。", "基礎"),
    Problem(2, "q02_select_product_columns", "列の選択", "商品名と単価だけを取得し、商品名を昇順にする。", "基礎"),
    Problem(3, "q03_active_products", "WHERE", "販売中 (IsActive = 1) の商品を取得する。", "基礎"),
    Problem(4, "q04_products_in_price_range", "BETWEEN", "単価が1000以上5000以下の商品を単価降順で取得する。", "基礎"),
    Problem(5, "q05_product_name_search", "LIKE", "商品名に「SQL」を含む商品を取得する。", "基礎"),
    Problem(6, "q06_distinct_customer_cities", "DISTINCT", "顧客の都市を重複なしで取得する。NULLは除く。", "基礎"),
    Problem(7, "q07_recent_orders", "TOP と並べ替え", "注文日の新しい順に上位5件を取得する。", "基礎"),
    Problem(8, "q08_customer_display_name", "別名と文字列結合", "顧客IDと「姓 名」を DisplayName として取得する。", "基礎"),
    Problem(9, "q09_order_amounts", "計算列", "注文明細ごとの数量、単価、LineAmount (数量×単価) を取得する。", "基礎"),
    Problem(10, "q10_products_with_category", "INNER JOIN", "商品とカテゴリ名を結合して取得する。", "結合"),
    Problem(11, "q11_customers_and_orders", "LEFT JOIN", "注文がない顧客も含め、顧客と注文を取得する。", "結合"),
    Problem(12, "q12_order_detail_report", "複数JOIN", "注文番号、商品名、数量、単価、明細金額を取得する。", "結合"),
    Problem(13, "q13_product_count_by_category", "GROUP BY", "カテゴリごとの商品数を取得する。", "集計"),
    Problem(14, "q14_order_total_by_order", "SUM", "注文ごとの合計金額を取得する。", "集計"),
    Problem(15, "q15_large_order_customers", "HAVING", "注文合計が10000以上の顧客と合計額を取得する。", "集計"),
    Problem(16, "q16_products_above_average_price", "サブクエリ", "全商品の平均単価より高い商品を取得する。", "応用"),
    Problem(17, "q17_customers_without_orders", "NOT EXISTS", "注文履歴がない顧客を取得する。", "応用"),
    Problem(18, "q18_rank_products_by_category", "ウィンドウ関数", "カテゴリ内で単価が高い順の順位を付ける。", "応用"),
    Problem(19, "q19_monthly_sales", "日付と集計", "月ごとの売上合計を YYYY-MM とともに取得する。", "応用"),
    Problem(20, "q20_customer_sales_summary", "CTE", "顧客ごとの注文回数と総購入額を、購入額降順で取得する。", "応用"),
    Problem(21, "q21_insert_customer", "INSERT", "指定値を使って顧客を1件追加する。", "更新", True),
    Problem(22, "q22_insert_discounted_products", "INSERT SELECT", "高額商品の割引情報を ProductDiscounts に追加する。", "更新", True),
    Problem(23, "q23_update_inactive_products", "UPDATE", "在庫0の商品を販売停止に更新する。", "更新", True),
    Problem(24, "q24_update_category_prices", "JOIN付きUPDATE", "Booksカテゴリの商品価格を10%値上げする。", "更新", True),
    Problem(25, "q25_delete_expired_discounts", "DELETE", "期限切れの割引を削除する。", "更新", True),
    Problem(26, "q26_delete_customers_without_orders", "NOT EXISTS付きDELETE", "注文履歴がない非アクティブ顧客を削除する。", "更新", True),
    Problem(27, "q27_upsert_inventory", "MERGE", "InventoryImport の内容で在庫を更新・追加する。", "発展", True),
    Problem(28, "q28_best_selling_product_per_category", "CTEと順位", "カテゴリごとに売上金額が最大の商品を取得する。同額はすべて含める。", "発展"),
    Problem(29, "q29_customer_order_interval", "LAG", "各顧客の注文と前回注文からの日数を取得する。", "発展"),
    Problem(30, "q30_sales_dashboard", "総合問題", "月・カテゴリ別の売上、前月売上、前月比を取得する。", "発展"),
)


def get_problem(number: int) -> Problem:
    """Return one problem by its 1-based number."""
    try:
        return next(problem for problem in PROBLEMS if problem.number == number)
    except StopIteration as exc:
        raise ValueError(f"問題 {number} は存在しません") from exc
