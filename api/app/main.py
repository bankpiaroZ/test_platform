"""จุดประกอบระบบ: core → platform → ห้องต่างๆ (image เดียว รันเป็น api และ worker)."""

from contextlib import asynccontextmanager

from fastapi import FastAPI

from app.core.settings import settings
from app.modules.hello.router import router as hello_router
from app.platform.health import router as health_router


@asynccontextmanager
async def lifespan(_: FastAPI):
    settings.guard()  # ชี้ผิดฐาน = ไม่ขึ้น
    yield


app = FastAPI(title="test_platform", lifespan=lifespan)
app.include_router(health_router)
app.include_router(hello_router)
