เริ่มงานเรื่อง: $ARGUMENTS

ทำตามลำดับ ห้ามข้าม:
1. อ่าน CLAUDE.md ของ repo
2. `git switch main` แล้ว `git pull`
3. ถามผู้ใช้ว่าเรื่องนี้อยู่ห้องไหน (hello / dq / access / dg) ถ้ายังไม่รู้จากชื่อเรื่อง
4. สร้าง branch ชื่อ `<ห้อง>/<เรื่องสั้นๆ เป็นอังกฤษ>` ด้วย `git switch -c`
5. ประเมินว่าจะต้องแตะของกลางไหม (api/app/core, api/app/platform, web/shared, .github, .claude, docs/decisions)
   - ถ้าใช่: บอกผู้ใช้ว่า PR นี้จะต้องมีคนอนุมัติ 1 คน + ป้าย decision + ไฟล์ใน docs/decisions/ แล้วถามว่าจะไปต่อหรือทำเป็นข้อเสนอ (/propose) ก่อน
6. สรุปแผนสั้นๆ ว่าจะแก้ไฟล์ไหนบ้าง แล้วรอผู้ใช้ตกลงก่อนลงมือ
