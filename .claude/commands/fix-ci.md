แก้ CI แดง

1. `gh pr checks` ดูว่า step ไหนแดง แล้ว `gh run view <id> --log-failed` อ่าน error
2. อธิบายผู้ใช้สั้นๆ ว่าพังเพราะอะไร (ภาษาไทย)
3. แก้ในเครื่องแล้ว `just check` จนผ่าน
4. ถามผู้ใช้ก่อน push แล้ว push ขึ้น branch เดิม
5. `gh pr checks --watch` รายงานผล
