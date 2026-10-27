"""สร้างโครงห้องใหม่: python -m app.tools.new_room <ชื่อห้อง>."""

import sys
from pathlib import Path

TEMPLATE_INIT = '"""ห้อง {name}."""\n'
TEMPLATE_ROUTER = """from fastapi import APIRouter

router = APIRouter(prefix="/api/{name}", tags=["{name}"])


@router.get("/ping")
def ping() -> dict:
    return {{"room": "{name}"}}
"""


def main() -> None:
    if len(sys.argv) != 2 or not sys.argv[1].isidentifier():
        print("ใช้: python -m app.tools.new_room <ชื่อห้อง a-z>")
        sys.exit(1)
    name = sys.argv[1]
    room = Path(__file__).resolve().parents[1] / "modules" / name
    if room.exists():
        print(f"ห้อง {name} มีอยู่แล้ว")
        sys.exit(1)
    room.mkdir()
    (room / "__init__.py").write_text(TEMPLATE_INIT.format(name=name), encoding="utf-8")
    (room / "router.py").write_text(TEMPLATE_ROUTER.format(name=name), encoding="utf-8")
    print(f"สร้างห้อง {name} แล้ว")
    print("อย่าลืม: include_router ใน app/main.py และเพิ่มชื่อห้องใน pyproject (importlinter)")


if __name__ == "__main__":
    main()
