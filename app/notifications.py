"""Rezervasyon onayı e-postası.

SMTP_HOST tanımlıysa e-posta SMTP ile gönderilir. Tanımlı değilse mesaj MAIL_DIR
klasörüne .eml dosyası olarak yazılır (yerel geliştirme için).
Testlerde mesajlar bellekteki kutuda tutulur. Bildirim hatası rezervasyonu
geri almaz; rezervasyon zaten kaydedilmiş olur ve hata günlüğe yazılır.
"""
from datetime import datetime
from email.message import EmailMessage
from email.utils import formataddr, make_msgid
from pathlib import Path
import smtplib

from flask import current_app

from .repositories import Repository as Repo


def _money(value):
    text = f"{float(value):,.2f}"
    return text.replace(",", "X").replace(".", ",").replace("X", ".") + " TL"


def _date(value):
    return value.strftime("%d.%m.%Y") if hasattr(value, "strftime") else str(value)


def build_message(reservation, guest_email, sender):
    nights = (reservation["check_out"] - reservation["check_in"]).days
    message = EmailMessage()
    message["Subject"] = f"Rezervasyonunuz onaylandı · #{reservation['id']}"
    message["From"] = sender
    message["To"] = formataddr((reservation["guest_name"], guest_email))
    message["Message-ID"] = make_msgid(domain="mavi-otel.local")
    message.set_content(
        f"Sayın {reservation['guest_name']},\n\n"
        f"Mavi Otel rezervasyonunuz onaylanmıştır.\n\n"
        f"Rezervasyon no : {reservation['id']}\n"
        f"Oda            : {reservation['room_number']} ({reservation['type_name']})\n"
        f"Giriş          : {_date(reservation['check_in'])} (14:00'ten itibaren)\n"
        f"Çıkış          : {_date(reservation['check_out'])} (12:00'ye kadar)\n"
        f"Gece / kişi    : {nights} gece, {reservation['guest_count']} kişi\n"
        f"Oda tutarı     : {_money(reservation['total_price'])}\n\n"
        "Ek hizmetler konaklama sırasında hesabınıza eklenir ve çıkışta tahsil edilir.\n"
        "Rezervasyonunuzu giriş tarihinden önce uygulama üzerinden iptal edebilirsiniz.\n\n"
        "İyi konaklamalar dileriz.\nMavi Otel Resepsiyon\n"
    )
    return message


def _deliver(message):
    config = current_app.config
    if config.get("TESTING") and not config.get("SMTP_HOST"):
        current_app.extensions.setdefault("mail_outbox", []).append(message)
        return "outbox"
    if config.get("SMTP_HOST"):
        smtp_class = smtplib.SMTP_SSL if config.get("SMTP_SSL") else smtplib.SMTP
        with smtp_class(config["SMTP_HOST"], int(config.get("SMTP_PORT") or 587), timeout=10) as smtp:
            if config.get("SMTP_STARTTLS") and not config.get("SMTP_SSL"):
                smtp.starttls()
            if config.get("SMTP_USER"):
                smtp.login(config["SMTP_USER"], config.get("SMTP_PASSWORD") or "")
            smtp.send_message(message)
        return "smtp"
    folder = Path(config.get("MAIL_DIR") or "mail")
    folder.mkdir(parents=True, exist_ok=True)
    stamp = datetime.now().strftime("%Y%m%d-%H%M%S")
    path = folder / f"{stamp}-rezervasyon-{message['Subject'].split('#')[-1]}.eml"
    path.write_bytes(bytes(message))
    return "file"


def reservation_confirmed(reservation):
    """Onaylı rezervasyon için misafire e-posta gönderir. Sonucu sözlük olarak döner."""
    if reservation is None or reservation.get("status") != "confirmed":
        return {"sent": False}
    guest = Repo.one("SELECT email FROM guests WHERE id=%s", (reservation["guest_id"],))
    if not guest or not guest.get("email"):
        return {"sent": False}
    try:
        message = build_message(reservation, guest["email"], current_app.config["MAIL_FROM"])
        channel = _deliver(message)
    except Exception:  # bildirim hatası rezervasyonu etkilememeli
        current_app.logger.exception("Rezervasyon e-postası gönderilemedi: #%s", reservation["id"])
        return {"sent": False, "to": guest["email"]}
    current_app.logger.info("Rezervasyon e-postası (%s): #%s -> %s", channel, reservation["id"], guest["email"])
    return {"sent": True, "to": guest["email"], "channel": channel}
