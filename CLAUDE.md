# กติกาของ repo นี้ (AI ทุกตัวอ่านไฟล์นี้ก่อนทำงาน)

## 1. ภาษาและท่าที
- คุยกับคนเป็นภาษาไทยง่ายๆ ผู้ใช้เป็น data engineer ไม่ใช่ software engineer
- ห้ามพูดว่า "เสร็จแล้ว" ก่อนรัน `just check` แล้วเห็นผลจริง
- ถ้าไม่แน่ใจว่าแตะของกลางหรือไม่ ให้ถามก่อนแก้

## 2. ของกลาง vs ของห้อง
- **ของกลาง** = `api/app/core/` · `api/app/platform/` · `web/shared/` · `.github/` · `.claude/` · `docs/decisions/`
  แก้ได้ แต่ PR ต้องมีคนอนุมัติ 1 คน (CODEOWNERS บังคับ) และต้องติดป้าย `decision` + มีไฟล์ใน `docs/decisions/`
- **ของห้อง** = `api/app/modules/<ห้อง>/` · `web/features/<ห้อง>/`
  CI เขียว + AI รีวิวตัวเอง = เจ้าของห้องรวมเองได้
- ห้องห้าม import ห้องอื่น (import-linter จับ) · ห้องเรียกของกลางได้ · ของกลางห้ามเรียกห้อง

## 3. เครื่องมือ
- รันเครื่องมือของโปรเจกต์ (python · alembic · pytest · ruff) **ใน container เท่านั้น** ผ่าน `just …`
- ห้าม `pip install` บนเครื่อง · ห้ามแก้ `pyproject.toml` โดยไม่บอกใน PR
- ห้าม `docker compose down -v` · ลบฐานต้องผ่าน `just db-reset --yes` เท่านั้น

## 4. git
- ทำงานบน branch ชื่อ `<ห้อง>/<เรื่องสั้นๆ>` เช่น `hello/add-greeting-time` · ห้าม commit ลง main ตรง
- commit เฉพาะไฟล์ที่เกี่ยวกับเรื่องนั้น · ห้าม commit `.env` · `backups/`
- ก่อน push ต้อง `just check` ผ่าน · push/merge/แตะ server ต้องถามคนก่อนเสมอ
- PR ต้องกรอก template ครบทุกช่อง (CI ตรวจ) · 1 PR = 1 เรื่อง

## 5. ฐานข้อมูล
- ทุกตาราง PK เป็น uuid · ไม่ gen ใหม่ · natural key เป็น UNIQUE
- schema ต่อห้อง (`hello.` · `dq.` · `access.` · `dg.`) · migration ของห้องแตะเฉพาะ schema ตัวเอง
- `.env` ของตัวเองต้องชี้ postgres ใน compose เท่านั้น มีตัวตรวจตอนสตาร์ท ชี้ออกนอกจะไม่ขึ้น

## 6. คำสั่งที่ใช้
`/start เรื่อง` → แก้งาน → `/check` → `/submit` → (CI แดง? `/fix-ci`) → รีวิว/รวมใน GitHub
