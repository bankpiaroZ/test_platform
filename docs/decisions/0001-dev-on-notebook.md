# 0001 — รอบซ้อม: notebook ของ bankpiaroZ ทำหน้าที่ dev server · GitHub ทำหน้าที่ build

สถานะ: ตกลงแล้ว · 2026-10-27

## บริบท
ยังไม่มีเครื่อง build / dev / prod ในออฟฟิศ แต่อยากซ้อมเส้นทาง "รวมเข้า main → มี image → ขึ้น dev" ให้ครบ

## ตัดสินใจ
- **build**: GitHub Actions (runner ของ GitHub) build image แล้วเก็บที่ ghcr.io ติด tag `main` และ `<sha>`
- **dev**: notebook ของ bankpiaroZ รัน `deploy/dev/compose.yaml` (keycloak · demo web/api/postgres · postgres ฐานทดสอบ)
  และรัน runner ของ GitHub ติดป้าย `dev` เพื่อรับงาน "ดึง image ใหม่แล้วเปิด" (workflow `deploy-dev`)
- เพื่อนเข้าถึง demo ผ่าน Wi-Fi วงเดียวกัน ที่ `http://<ชื่อเครื่อง>:8081` · keycloak ที่ `:8180`
- ไม่มี mssql / mysql / prod ในรอบนี้

## ผลที่ตามมา
- notebook ปิด = dev หาย ยอมรับได้ในรอบซ้อม
- พอได้เครื่องจริง: ย้าย runner + `deploy/dev/` ไปเครื่องนั้น เปลี่ยน `runs-on` ของงาน build เป็น self-hosted และชี้ registry ในบ้าน ขั้นตอนอื่นเหมือนเดิม
- ขั้นตั้งต้นครั้งแรก (PR นี้) แตะ `.github/` และยังไม่มีคนที่ 2 ว่างรีวิว จึงใช้สิทธิ์ admin ข้ามกติกา 1 ครั้ง แล้วเปิดกติกากลับทันที
