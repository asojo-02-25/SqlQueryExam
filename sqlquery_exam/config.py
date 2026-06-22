"""Database settings loaded from environment variables."""

from dataclasses import dataclass
import os
from pathlib import Path

from dotenv import load_dotenv


PROJECT_ROOT = Path(__file__).resolve().parents[1]
load_dotenv(PROJECT_ROOT / ".env", override=False)


@dataclass(frozen=True)
class DatabaseConfig:
    server: str = os.getenv("SQLSERVER_HOST", "localhost")
    port: int = int(os.getenv("SQLSERVER_PORT", "1433"))
    user: str = os.getenv("SQLSERVER_USER", "sa")
    password: str = os.getenv("SQLSERVER_PASSWORD", "")
    database: str = os.getenv("SQLSERVER_DATABASE", "SqlQueryExam")
    login_timeout: int = int(os.getenv("SQLSERVER_LOGIN_TIMEOUT", "10"))

    @property
    def is_configured(self) -> bool:
        return bool(self.password)


DATABASE = DatabaseConfig()
