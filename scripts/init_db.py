"""Load schema and deterministic demonstration data into an EMPTY MySQL database."""
import argparse
import os
from pathlib import Path
import re

import pymysql
from dotenv import load_dotenv

ROOT = Path(__file__).resolve().parents[1]
load_dotenv(ROOT / ".env")


def connection(database=None):
    options = dict(
        host=os.getenv("DB_HOST", "127.0.0.1"),
        port=int(os.getenv("DB_PORT", "3306")),
        user=os.getenv("DB_USER", "otel"),
        password=os.getenv("DB_PASSWORD", ""),
        charset="utf8mb4", autocommit=True,
        init_command="SET time_zone = '+03:00'",
    )
    if os.getenv("DB_SOCKET"):
        options["unix_socket"] = os.environ["DB_SOCKET"]
    if database:
        options["database"] = database
    return pymysql.connect(**options)


def execute_script(conn, path):
    """Honor mysql client's DELIMITER directives without enabling multi-statements."""
    delimiter, buffer = ";", []
    with conn.cursor() as cur:
        for line in Path(path).read_text(encoding="utf-8").splitlines():
            if line.strip().upper().startswith("DELIMITER "):
                delimiter = line.strip().split(None, 1)[1]
                continue
            if not buffer and (not line.strip() or line.lstrip().startswith("--")):
                continue
            buffer.append(line)
            if line.rstrip().endswith(delimiter):
                statement = "\n".join(buffer).rstrip()[:-len(delimiter)].strip()
                buffer = []
                if statement:
                    cur.execute(statement)
                    while cur.nextset():
                        pass
        if "\n".join(buffer).strip():
            raise ValueError(f"Unterminated SQL statement in {path}")


def initialize(name, seed=True):
    if not re.fullmatch(r"[A-Za-z][A-Za-z0-9_]{0,63}", name):
        raise ValueError("Database name must be an SQL identifier")
    with connection() as conn:
        with conn.cursor() as cur:
            cur.execute(f"CREATE DATABASE IF NOT EXISTS `{name}` CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci")
            cur.execute(f"USE `{name}`")
            cur.execute("SHOW TABLES")
            if cur.fetchone():
                raise RuntimeError(f"{name} is not empty. Refusing to overwrite existing data.")
        execute_script(conn, ROOT / "database/schema.sql")
        if seed:
            execute_script(conn, ROOT / "database/seed.sql")
    print(f"Database ready: {name}" + (" (demo data loaded)" if seed else ""))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--database", default=os.getenv("DB_NAME", "mavi_otel"))
    parser.add_argument("--no-seed", action="store_true")
    args = parser.parse_args()
    initialize(args.database, seed=not args.no_seed)

