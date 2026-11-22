"""Start this project's local MySQL and Flask without changing other databases."""
import os
from pathlib import Path
import secrets
import shutil
import subprocess
import sys
import time

ROOT=Path(__file__).resolve().parents[1]
LOCAL=ROOT/".local"
os.chdir(ROOT)


def main():
    try:
        import pymysql
        import flask
        from dotenv import load_dotenv
    except ImportError:
        sys.exit("Önce: python3 -m venv .venv && .venv/bin/pip install -r requirements.txt")
    LOCAL.mkdir(exist_ok=True)
    env_file=ROOT/".env"
    if not env_file.exists():
        env_file.write_text(f"DB_NAME=mavi_otel\nDB_USER=root\nDB_PASSWORD=\nDB_HOST=127.0.0.1\nDB_PORT=33077\nDB_SOCKET={LOCAL/'mysql.sock'}\nJWT_SECRET={secrets.token_urlsafe(48)}\nPORT=5000\n")
        env_file.chmod(0o600)
    load_dotenv(env_file)
    from init_db import connection,initialize
    def ready():
        try:
            with connection():
                return True
        except pymysql.MySQLError:
            return False
    if not ready():
        # Only start a private instance for this script's own socket path.
        if os.getenv('DB_SOCKET')!=str(LOCAL/'mysql.sock'):
            sys.exit(".env bağlantısı kapalı. Kendi MySQL sunucunuzu başlatın veya README'deki Docker kurulumunu kullanın.")
        candidates=[shutil.which('mysqld'),'/opt/homebrew/bin/mysqld','/usr/local/mysql/bin/mysqld','/usr/sbin/mysqld']
        binary=next((p for p in candidates if p and Path(p).exists()),None)
        if not binary:
            sys.exit("MySQL 8.4 bulunamadı. MySQL kurun veya docker compose up --build komutunu kullanın.")
        data=LOCAL/'mysql'
        if not (data/'mysql').exists():
            data.mkdir(exist_ok=True)
            subprocess.run([binary,'--no-defaults','--initialize-insecure',f'--datadir={data}',f'--log-error={LOCAL/"mysql-init.log"}'],check=True)
        with (LOCAL/'mysql-launch.log').open('a') as log:
            subprocess.Popen([binary,'--no-defaults',f'--datadir={data}',f'--socket={LOCAL/"mysql.sock"}','--skip-networking','--mysqlx=OFF','--default-time-zone=+03:00',f'--log-error={LOCAL/"mysql.log"}',f'--pid-file={LOCAL/"mysql.pid"}'],stdout=log,stderr=log,start_new_session=True)
        for _ in range(60):
            if ready():
                break
            time.sleep(0.5)
        else:
            sys.exit(f"MySQL başlamadı. Günlük: {LOCAL/'mysql.log'}")
    name=os.getenv('DB_NAME','mavi_otel')
    with connection() as conn,conn.cursor() as cur:
        cur.execute("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema=%s",(name,))
        if cur.fetchone()[0]==0:
            initialize(name)
    print(f"Mavi Otel: http://127.0.0.1:{os.getenv('PORT','5000')}",flush=True)
    print("Web sunucusunu durdurmak için Ctrl+C. Projeye ait MySQL arka planda kalır.",flush=True)
    os.execv(sys.executable,[sys.executable,str(ROOT/'run.py')])


if __name__=='__main__':
    main()
