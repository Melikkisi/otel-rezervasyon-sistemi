"""Flask application factory."""
import os
import secrets
from datetime import date, datetime, time
from decimal import Decimal
from pathlib import Path
import pymysql
from dotenv import load_dotenv
from flask import Flask, jsonify, render_template
from flask.json.provider import DefaultJSONProvider
from werkzeug.exceptions import HTTPException
from .db import close_db
from .entities import AppError


class HotelJSONProvider(DefaultJSONProvider):
    @staticmethod
    def default(value):
        if isinstance(value, Decimal):
            return float(value)
        if isinstance(value, (date, datetime, time)):
            return value.isoformat()
        return DefaultJSONProvider.default(value)


def create_app(config=None):
    load_dotenv(Path(__file__).resolve().parent.parent / ".env")
    app = Flask(__name__)
    app.json = HotelJSONProvider(app)
    app.json.ensure_ascii = False
    app.config.from_mapping(
        DB_HOST=os.getenv("DB_HOST", "127.0.0.1"), DB_PORT=int(os.getenv("DB_PORT", "3306")),
        DB_USER=os.getenv("DB_USER", "hotel"), DB_PASSWORD=os.getenv("DB_PASSWORD", ""),
        DB_NAME=os.getenv("DB_NAME", "mavi_otel"), DB_SOCKET=os.getenv("DB_SOCKET") or None,
        JWT_SECRET=os.getenv("JWT_SECRET"), MAX_CONTENT_LENGTH=64 * 1024,
        SMTP_HOST=os.getenv("SMTP_HOST") or None, SMTP_PORT=int(os.getenv("SMTP_PORT") or "587"),
        SMTP_USER=os.getenv("SMTP_USER") or None, SMTP_PASSWORD=os.getenv("SMTP_PASSWORD") or None,
        SMTP_STARTTLS=os.getenv("SMTP_STARTTLS", "1") == "1", SMTP_SSL=os.getenv("SMTP_SSL", "0") == "1",
        MAIL_FROM=os.getenv("MAIL_FROM", "Mavi Otel <rezervasyon@mavi-otel.test>"),
        MAIL_DIR=os.getenv("MAIL_DIR") or str(Path(__file__).resolve().parent.parent / ".local" / "mail"),
        TESTING=False, JSON_SORT_KEYS=False,
    )
    if config:
        app.config.update(config)
    if not app.config["JWT_SECRET"] and app.config["TESTING"]:
        app.config["JWT_SECRET"] = secrets.token_urlsafe(48)
    if not app.config["JWT_SECRET"] or len(app.config["JWT_SECRET"]) < 32:
        raise RuntimeError("JWT_SECRET en az 32 karakter olmalıdır. .env.example dosyasından .env oluşturun.")
    from .controllers import api
    app.register_blueprint(api)
    app.teardown_appcontext(close_db)

    @app.get("/")
    def index():
        return render_template("index.html")

    @app.errorhandler(AppError)
    def app_error(error):
        return jsonify(error=error.message), error.status

    @app.errorhandler(pymysql.MySQLError)
    def database_error(error):
        code = error.args[0] if error.args else 0
        if code == 1644:
            return jsonify(error=str(error.args[1])), 409
        if code == 1062:
            return jsonify(error="Bu bilgiyle bir kayıt zaten var. E-posta, kimlik veya oda numarasını kontrol edin."), 409
        if code == 1451:
            return jsonify(error="Bu kayıt başka kayıtlarda kullanıldığı için silinemez."), 409
        if code == 1452:
            return jsonify(error="İlişkili kayıt bulunamadı. Seçiminizi yenileyin."), 400
        if code in (3819, 1265, 1264, 1366, 1406, 1048):
            return jsonify(error="Girilen değerler veritabanı kurallarına uygun değil."), 400
        if code in (1205, 1213):
            return jsonify(error="Bu kayıt başka bir işlemde güncelleniyor. Lütfen yeniden deneyin."), 409
        if code in (2002, 2003, 2006, 2013):
            app.logger.warning("Database unavailable: %s", code)
            return jsonify(error="Veritabanına ulaşılamıyor. MySQL hizmetini ve bağlantı ayarlarını kontrol edin."), 503
        app.logger.exception("Unhandled database error")
        return jsonify(error="Veritabanı işlemi tamamlanamadı."), 500

    @app.errorhandler(HTTPException)
    def http_error(error):
        messages = {400: "İstek biçimi geçersiz.", 404: "İstenen sayfa veya API bulunamadı.",
                    405: "Bu işlem için HTTP yöntemi desteklenmiyor.", 413: "İstek boyutu çok büyük.",
                    415: "JSON biçiminde bir istek gönderin."}
        return jsonify(error=messages.get(error.code, "İstek tamamlanamadı.")), error.code

    @app.errorhandler(Exception)
    def unexpected_error(error):
        app.logger.exception("Unhandled application error")
        return jsonify(error="Beklenmeyen bir hata oluştu. Lütfen yeniden deneyin."), 500

    @app.after_request
    def security_headers(response):
        response.headers["X-Content-Type-Options"] = "nosniff"
        response.headers["X-Frame-Options"] = "DENY"
        response.headers["Referrer-Policy"] = "same-origin"
        if response.mimetype == "application/json":
            response.headers["Cache-Control"] = "no-store"
        return response

    return app
