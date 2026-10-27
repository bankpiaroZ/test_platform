"""worker: image เดียวกับ api แต่รันงานเบื้องหลัง (ซ้อม: แค่เต้นหัวใจทุก 30 วิ)."""

import time

from sqlalchemy import func, select

from app.core.db import SessionLocal
from app.core.settings import settings
from app.modules.hello.models import Greeting


def main() -> None:
    settings.guard()
    while True:
        with SessionLocal() as db:
            n = db.scalar(select(func.count()).select_from(Greeting))
        print(f"[worker] มีคำทักทาย {n} แถว", flush=True)
        time.sleep(30)


if __name__ == "__main__":
    main()
