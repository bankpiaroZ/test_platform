import uuid
from datetime import datetime

from sqlalchemy import DateTime, String, func
from sqlalchemy.orm import Mapped, mapped_column

from app.core.db import Base


class Greeting(Base):
    """ทักทาย 1 แถว = 1 คนที่กดปุ่มในหน้าเว็บ."""

    __tablename__ = "greeting"
    __table_args__ = {"schema": "hello"}

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, default=uuid.uuid4)
    name: Mapped[str] = mapped_column(String(100))
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
