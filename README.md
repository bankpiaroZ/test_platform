# test_platform — repo ซ้อมใหญ่

repo นี้ใช้ **ซ้อมวิธีทำงานหลายคน** ของแพลตฟอร์มใหม่ (PRAJAK + ARAK + DG) เท่านั้น
ไม่มีโค้ดจริง ไม่มีข้อมูลจริง ทิ้งได้หลังซ้อม

## ลงบนเครื่องแค่นี้

git · Docker Desktop · VS Code (+ Claude Code · ส่วนเสริม GitHub Pull Requests) · GitHub CLI (`gh`) · `just`

```powershell
# Windows
winget install --id GitHub.cli -e
winget install --id Casey.Just -e
gh auth login
```

```sh
# Mac
brew install gh just
gh auth login
```

ลงแล้วให้ **เปิดหน้าต่าง terminal ใหม่** ครั้งหนึ่ง ไม่งั้นจะยังหาคำสั่ง `just` ไม่เจอ

Python · Node · Alembic · pytest · ruff **อยู่ใน image** ไม่ต้องติดตั้งเอง ห้ามรันนอก container

## เริ่มใช้ 4 คำสั่ง

```powershell
git clone https://github.com/bankpiaroZ/test_platform
cd test_platform
copy .env.example .env
just up
```

เปิด http://localhost:8080 เห็นหน้า "สวัสดี" ที่อ่าน/เขียนฐานของตัวเองได้ = ระบบเดิน

| คำสั่ง | ทำอะไร |
|---|---|
| `just up` | เปิด web · api · postgres ของตัวเอง รอ healthy แล้ว alembic รันเอง |
| `just up-worker` | เหมือน up + worker |
| `just down` / `just status` / `just logs` | ปิด / ดูสถานะ / ดู log |
| `just check` | format · lint · import-linter · เทสต์ = เหมือน CI ทุกประการ รันก่อน push ทุกครั้ง |
| `just test` | เทสต์อย่างเดียว |
| `just migrate hello "เพิ่มคอลัมน์"` | สร้างไฟล์ migration ของห้องนั้น |
| `just db-save` / `just db-load --yes` | เก็บ / คืนสภาพฐานของตัวเอง |
| `just db-reset --yes` | ล้างฐานตัวเองแล้วสร้างใหม่ |

## โครง

```
api/app/core/       ชั้นล่างสุด: ตั้งค่า · ฐานข้อมูล     ← ของกลาง แก้ต้องมีคนอนุมัติ 1
api/app/platform/   ของที่ทุกห้องใช้ร่วม: health …        ← ของกลาง แก้ต้องมีคนอนุมัติ 1
api/app/modules/    ห้อง: hello (ซ้อม) · dq · access · dg  ← ของห้อง CI เขียว + AI รีวิว = รวมเองได้
web/                หน้าเว็บ (ซ้อมใช้หน้าเดียว)
docs/decisions/     บันทึกตัดสินใจ (ADR)                   ← แก้ต้องมีคนอนุมัติ
docs/proposals/     ข้อเสนอ (ใครก็เขียนได้ ไม่ต้องอนุมัติ)
.claude/commands/   คำสั่งของ AI: /start /check /submit /fix-ci /review /propose
```

## เครื่อง dev (รอบซ้อม = notebook ของ bankpiaroZ)

อยู่ใน `deploy/dev/` ดู [docs/decisions/0001-dev-on-notebook.md](docs/decisions/0001-dev-on-notebook.md)

| ที่อยู่ (แทน `<dev>` ด้วยชื่อเครื่องหรือ IP) | คืออะไร |
|---|---|
| http://`<dev>`:8081 | demo = ตัวล่าสุดของ main (ขึ้นเองเมื่อรวม PR) |
| http://`<dev>`:8180 | Keycloak (admin / admin) realm `dev` · ผู้ใช้ทดสอบ somchai · somying · vendor1 รหัส test1234 |
| `<dev>`:5434 | postgres ฐานทดสอบ user test/test · database demo_a · demo_b · demo_c (มีตาราง customer ตัวอย่าง) |
| `<dev>`:5433 | postgres ของ demo (platform_demo) |

เส้นทาง: รวม PR เข้า main → workflow `deploy-dev` build image บน GitHub เก็บที่ ghcr.io → runner บนเครื่อง dev ดึงมาเปิด
ตั้งเครื่อง dev ครั้งแรก: `cd deploy/dev; copy .env.example .env; docker compose up -d --wait keycloak postgres-demo postgres-test` แล้วรัน `install-runner.ps1`

กติกาละเอียดอยู่ใน [CLAUDE.md](CLAUDE.md)
