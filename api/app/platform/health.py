"""ของกลาง: health check ที่ compose/CI/dev server ใช้รอให้ api พร้อม."""

from fastapi import APIRouter, Depends
from sqlalchemy import text
from sqlalchemy.orm import Session

from app.core.db import get_db
from app.core.settings import settings

router = APIRouter(prefix="/api", tags=["platform"])


@router.get("/health")
def health(db: Session = Depends(get_db)) -> dict:
    db.execute(text("select 1"))
    return {"ok": True, "env": settings.app_env}
