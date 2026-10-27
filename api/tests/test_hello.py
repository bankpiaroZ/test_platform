"""เทสต์ห้อง hello — ยิง API จริงลงฐาน postgres ใน compose (ไม่ mock ฐาน)."""

import uuid

from app.modules.hello.router import make_message


def test_health(client):
    r = client.get("/api/health")
    assert r.status_code == 200
    assert r.json()["ok"] is True


def test_message_text():
    assert make_message("ปอ") == "สวัสดี ปอ"


def test_add_then_list(client):
    name = f"ทดสอบ-{uuid.uuid4().hex[:6]}"
    r = client.post("/api/hello", json={"name": name})
    assert r.status_code == 201
    assert r.json()["message"] == f"สวัสดี {name}"

    names = [g["name"] for g in client.get("/api/hello").json()]
    assert name in names


def test_reject_empty_name(client):
    assert client.post("/api/hello", json={"name": ""}).status_code == 422
