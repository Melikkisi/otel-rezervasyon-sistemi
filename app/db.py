"""One MySQL connection per request; transactions never cross requests."""
from contextlib import contextmanager
import pymysql
from flask import current_app, g


def get_db():
    if "db" not in g:
        config = current_app.config
        options = dict(host=config["DB_HOST"], port=int(config["DB_PORT"]),
                       user=config["DB_USER"], password=config["DB_PASSWORD"],
                       database=config["DB_NAME"], charset="utf8mb4", autocommit=False,
                       cursorclass=pymysql.cursors.DictCursor, connect_timeout=5,
                       read_timeout=15, write_timeout=15)
        if config.get("DB_SOCKET"):
            options["unix_socket"] = config["DB_SOCKET"]
        g.db = pymysql.connect(**options)
        with g.db.cursor() as cursor:
            cursor.execute("SET SESSION time_zone = '+03:00'")
            cursor.execute("SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED")
    return g.db


def close_db(_error=None):
    connection = g.pop("db", None)
    if connection is not None:
        connection.rollback()
        connection.close()


@contextmanager
def transaction():
    connection = get_db()
    connection.begin()
    try:
        yield connection
        connection.commit()
    except Exception:
        connection.rollback()
        raise
