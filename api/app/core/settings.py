"""ค่าตั้งระบบ + ตัวตรวจตอนสตาร์ท (บทเรียนจาก PRAJAK: env รั่วทำชี้ผิดฐาน)."""

from urllib.parse import urlparse

from pydantic_settings import BaseSettings, SettingsConfigDict

LOCAL_DB_HOSTS = {"postgres", "localhost", "127.0.0.1"}


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    app_env: str = "local"  # local | ci | dev | prod
    database_url: str = "postgresql+psycopg://app:app@postgres:5432/app"

    def guard(self) -> None:
        """ห้ามเครื่องตัวเองชี้ฐานออกนอก compose และห้ามใครชี้ไป prod โดยไม่ตั้งใจ."""
        host = urlparse(self.database_url).hostname or ""
        if self.app_env in {"local", "ci"} and host not in LOCAL_DB_HOSTS:
            raise RuntimeError(
                f"APP_ENV={self.app_env} แต่ DATABASE_URL ชี้ไป '{host}' "
                "— เครื่องตัวเองต้องใช้ postgres ใน compose เท่านั้น แก้ .env แล้วเปิดใหม่"
            )
        if self.app_env != "prod" and "prod" in host:
            raise RuntimeError(f"APP_ENV={self.app_env} แต่ DATABASE_URL ชี้ไปเครื่อง prod ('{host}')")


settings = Settings()
