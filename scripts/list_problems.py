"""Print the ordered exercise catalog."""

from pathlib import Path
import sys


PROJECT_ROOT = Path(__file__).resolve().parents[1]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from sqlquery_exam.catalog import PROBLEMS


for problem in PROBLEMS:
    mutation = " [更新]" if problem.mutates_data else ""
    print(f"{problem.number:02d}. ({problem.level}) {problem.title}{mutation}")
    print(f"    {problem.requirement}")
