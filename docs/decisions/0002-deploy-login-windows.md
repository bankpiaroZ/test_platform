# 0002 — job deploy ใช้ docker/login-action ไม่ใช้ echo | docker login

สถานะ: ตกลงแล้ว · 2026-10-28

## บริบท
deploy-dev รอบแรกหลังติดตั้ง runner บน notebook ล้มที่ขั้น login ghcr ด้วย `denied: denied`
สั่งรันซ้ำด้วย token ใหม่ก็ล้มเหมือนเดิม จึงไม่ใช่เรื่องสิทธิ์หรือ token หมดอายุ
ทดสอบบนเครื่อง runner: Windows PowerShell 5.1 ใส่ BOM นำหน้าข้อความที่ส่งเข้า stdin ของโปรแกรมอื่น
(`b'\xef\xbb\xbfghs_token\r\n'`) docker จึงส่ง token ผิดให้ ghcr

## ตัดสินใจ
- ทุก job ที่ต้อง login registry ใช้ `docker/login-action@v3` เหมือนกันหมด ไม่เขียน `echo | docker login` เองอีก
- ขั้น `run:` บน runner Windows เรียกโปรแกรมด้วยชื่อเต็ม `.exe` เมื่อชื่อชนกับ alias ของ PowerShell (เช่น `curl.exe`)
- สคริปต์ `.ps1` ที่มีภาษาไทยต้องบันทึกเป็น UTF-8 มี BOM

## ผล
PR นี้เป็นการแก้บั๊กของท่อส่ง ไม่ได้เปลี่ยนกติกาการทำงาน แต่กติกา CI ปัจจุบันนับการแตะ `.github/` ทุกกรณีเป็น "decision"
บันทึกข้อเสนอให้แยก "แก้บั๊กของกลาง" ออกจาก "เปลี่ยนกติกา" ไว้ที่ docs/proposals/
