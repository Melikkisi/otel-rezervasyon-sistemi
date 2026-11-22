"""Integration tests use a NEW random database and never change the demo database."""
import os
import uuid

import pymysql
import pytest

from scripts.init_db import connection, initialize


@pytest.fixture(scope="session")
def database_name():
    name = "mavi_test_" + uuid.uuid4().hex[:12]
    initialize(name)
    yield name
    with connection() as conn, conn.cursor() as cur:
        cur.execute(f"DROP DATABASE `{name}`")


@pytest.fixture(scope="session")
def app(database_name):
    from app import create_app
    return create_app({"TESTING": True, "DB_NAME": database_name,
                       "JWT_SECRET": "integration-test-secret-32-characters-minimum"})


@pytest.fixture
def client(app):
    return app.test_client()


@pytest.fixture
def db(database_name):
    conn = connection(database_name)
    conn.autocommit(False)
    yield conn
    conn.rollback()
    conn.close()


@pytest.fixture
def headers(client):
    result = {}
    for role, email in [("admin", "admin@otel.test"), ("reception", "resepsiyon@otel.test"), ("guest", "misafir@otel.test")]:
        response = client.post("/api/auth/login", json={"email": email, "password": "Otel2026!"})
        assert response.status_code == 200, response.json
        result[role] = {"Authorization": "Bearer " + response.json["data"]["token"]}
    return result


def scalar(db, sql, args=None):
    with db.cursor() as cur:
        cur.execute(sql, args)
        return cur.fetchone()[0]


def insert_reservation(db, room_id=1, start="2090-01-01", end="2090-01-03", guest_id=1):
    with db.cursor() as cur:
        cur.execute("INSERT INTO reservations (guest_id,room_id,check_in,check_out,guest_count,status) VALUES (%s,%s,%s,%s,1,'confirmed')", (guest_id, room_id, start, end))
        return cur.lastrowid
