#!/bin/sh
# ใส่ตารางตัวอย่างเล็กๆ ลงทุกฐาน ให้ DQ มีอะไรให้ตรวจ
set -e
for db in demo_a demo_b demo_c demo_shared; do
psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$db" <<'SQL'
CREATE TABLE customer (
  id         serial PRIMARY KEY,
  code       varchar(10),
  name       varchar(100),
  email      varchar(100),
  created_at date
);
INSERT INTO customer (code, name, email, created_at) VALUES
  ('C001', 'บริษัท ก', 'a@example.test', '2026-01-05'),
  ('C002', 'บริษัท ข', NULL,              '2026-02-10'),
  ('C002', 'บริษัท ข (ซ้ำ)', 'b@example.test', '2026-02-11'),
  ('C004', '',          'd@example',      '2026-03-01');
SQL
done
