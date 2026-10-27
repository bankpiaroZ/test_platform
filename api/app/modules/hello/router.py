from fastapi import APIRouter, Depends
from pydantic import BaseModel, Field
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.db import get_db
from app.modules.hello.models import Greeting

router = APIRouter(prefix="/api/hello", tags=["hello"])


class GreetingIn(BaseModel):
    name: str = Field(min_length=1, max_length=100)


class GreetingOut(BaseModel):
    id: str
    name: str
    message: str


def make_message(name: str) -> str:
    return f"สวัสดี {name}"


@router.get("", response_model=list[GreetingOut])
def list_greetings(db: Session = Depends(get_db)) -> list[GreetingOut]:
    rows = db.scalars(select(Greeting).order_by(Greeting.created_at.desc()).limit(20)).all()
    return [GreetingOut(id=str(r.id), name=r.name, message=make_message(r.name)) for r in rows]


@router.post("", response_model=GreetingOut, status_code=201)
def add_greeting(body: GreetingIn, db: Session = Depends(get_db)) -> GreetingOut:
    row = Greeting(name=body.name.strip())
    db.add(row)
    db.commit()
    return GreetingOut(id=str(row.id), name=row.name, message=make_message(row.name))
