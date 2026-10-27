# คำสั่งรันระบบ (ชุด A) และส่งงาน (ชุด B) — ทุกอย่างรันใน container
set windows-shell := ["powershell.exe", "-NoLogo", "-NoProfile", "-Command"]

default:
    @just --list

# ---------- ชุด A: รันระบบ ----------

# เปิด web · api · postgres ของตัวเอง (รอ healthy · alembic รันเองใน api)
up:
    docker compose up -d --build --wait web
    @echo "เปิดแล้ว: http://localhost:8080  (api: http://localhost:8000/api/health)"

# เหมือน up + worker
up-worker:
    docker compose --profile worker up -d --build --wait
    @echo "เปิดแล้ว (มี worker): http://localhost:8080"

# ปิดทั้งหมด (ไม่ลบฐาน — ลบฐานต้องใช้ db-reset --yes)
down:
    docker compose --profile worker down --timeout 60

status:
    docker compose --profile worker ps

logs service="api":
    docker compose logs -f --tail 100 {{service}}

# เก็บสภาพฐานตัวเองไว้ที่ backups/local.dump
db-save:
    docker compose exec -T postgres pg_dump -U app -Fc -f /backups/local.dump app
    @echo "เก็บแล้ว: backups/local.dump"

# คืนสภาพฐานจาก backups/local.dump (ทับของเดิม ต้องใส่ --yes)
db-load confirm="":
    @echo "{{ if confirm == "--yes" { "ยืนยันแล้ว กำลังคืนสภาพฐาน…" } else { error("จะทับฐานของคุณ ถ้าแน่ใจพิมพ์: just db-load --yes") } }}"
    docker compose exec -T postgres pg_restore -U app -d app --clean --if-exists /backups/local.dump
    @echo "คืนสภาพแล้ว"

# ล้างฐานตัวเองแล้วสร้างใหม่จาก migration (ต้องใส่ --yes)
db-reset confirm="":
    @echo "{{ if confirm == "--yes" { "ยืนยันแล้ว กำลังล้างฐาน…" } else { error("จะลบฐานของคุณทั้งหมด ถ้าแน่ใจพิมพ์: just db-reset --yes") } }}"
    docker compose --profile worker down --timeout 30
    docker volume rm -f test_platform_pgdata
    docker compose up -d --build --wait web
    @echo "สร้างฐานใหม่แล้ว"

# สร้างไฟล์ migration ของห้อง เช่น just migrate hello "เพิ่มคอลัมน์ note"
migrate room message:
    docker compose run --rm --no-deps api alembic revision --autogenerate -m "{{room}}: {{message}}"

# ---------- ชุด B: ส่งงาน ----------

# เหมือน CI ทุกประการ: format · lint · import-linter · เทสต์
check:
    docker compose build api
    docker compose run --rm --no-deps api ruff format --check .
    docker compose run --rm --no-deps api ruff check .
    docker compose run --rm --no-deps api lint-imports
    docker compose run --rm api sh -c "alembic upgrade head && pytest -q"
    @echo "check ผ่านทั้งหมด"

# จัด format ให้อัตโนมัติ
fmt:
    docker compose run --rm --no-deps api ruff format .
    docker compose run --rm --no-deps api ruff check --fix .

# เทสต์อย่างเดียว
test:
    docker compose run --rm api sh -c "alembic upgrade head && pytest -q"

# สร้างโครงห้องใหม่ (ซ้อม: แค่โฟลเดอร์ + ไฟล์ว่าง)
new-room name:
    docker compose run --rm --no-deps api python -m app.tools.new_room {{name}}
