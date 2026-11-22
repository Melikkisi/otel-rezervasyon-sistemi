"""Domain entities and shared, explicit input validation."""
from dataclasses import dataclass
from datetime import date, datetime
from decimal import Decimal, InvalidOperation
import re
from zoneinfo import ZoneInfo


class AppError(Exception):
    def __init__(self, message, status=400):
        super().__init__(message)
        self.message = message
        self.status = status


def today():
    return datetime.now(ZoneInfo("Europe/Istanbul")).date()


def text(value, label, maximum=120, minimum=1):
    if not isinstance(value, str) or not minimum <= len(value.strip()) <= maximum:
        raise AppError(f"{label}, {minimum}–{maximum} karakter olmalıdır.")
    return value.strip()


def integer(value, label, minimum=1, maximum=2_147_483_647):
    if isinstance(value, bool) or isinstance(value, float):
        raise AppError(f"{label} bir tam sayı olmalıdır.")
    try:
        result = int(value)
    except (ValueError, TypeError):
        raise AppError(f"{label} bir tam sayı olmalıdır.") from None
    if not minimum <= result <= maximum:
        raise AppError(f"{label}, {minimum}–{maximum} arasında olmalıdır.")
    return result


def money(value, label):
    if isinstance(value, bool):
        raise AppError(f"{label} geçerli bir tutar olmalıdır.")
    try:
        result = Decimal(str(value))
    except (ValueError, InvalidOperation):
        raise AppError(f"{label} geçerli bir tutar olmalıdır.") from None
    if not result.is_finite() or result < Decimal("0.01") or result > Decimal("9999999.99") or result.as_tuple().exponent < -2:
        raise AppError(f"{label} 0,01–9999999,99 aralığında, en çok iki ondalıklı olmalıdır.")
    return result


def iso_date(value, label):
    if not isinstance(value, str) or not re.fullmatch(r"\d{4}-\d{2}-\d{2}", value):
        raise AppError(f"{label} YYYY-AA-GG biçiminde olmalıdır.")
    try:
        return date.fromisoformat(value)
    except ValueError:
        raise AppError(f"{label} geçerli bir tarih olmalıdır.") from None


def email_address(value):
    value = text(value, "E-posta", 254).lower()
    if not re.fullmatch(r"[^\s@]+@[^\s@]+\.[^\s@]+", value):
        raise AppError("Geçerli bir e-posta adresi girin.")
    return value


def password_value(value):
    if not isinstance(value, str) or not 8 <= len(value) <= 128:
        raise AppError("Parola 8–128 karakter uzunluğunda olmalıdır.")
    return value


def choice(value, options, label):
    if value not in options:
        raise AppError(f"{label} için geçerli bir seçim yapın.")
    return value


def date_range(data, future=False):
    start = iso_date(data.get("check_in"), "Giriş tarihi")
    end = iso_date(data.get("check_out"), "Çıkış tarihi")
    if not 1 <= (end - start).days <= 365:
        raise AppError("Konaklama süresi 1–365 gece arasında olmalıdır.")
    if future and start < today():
        raise AppError("Giriş tarihi geçmişte olamaz.")
    return start, end


@dataclass(frozen=True)
class User:
    id: int
    email: str
    role: str
    guest_id: int | None
    staff_id: int | None
    name: str

    @classmethod
    def from_row(cls, row):
        return cls(**{field: row[field] for field in cls.__dataclass_fields__})

    def public(self):
        return dict(vars(self))

    @property
    def is_staff(self):
        return self.role in {"admin", "reception"}


@dataclass(frozen=True)
class ReservationRequest:
    room_id: int
    guest_id: int
    check_in: date
    check_out: date
    guest_count: int

    @classmethod
    def parse(cls, data, user):
        start, end = date_range(data, future=True)
        guest_id = user.guest_id if user.role == "guest" else integer(data.get("guest_id"), "Misafir")
        return cls(integer(data.get("room_id"), "Oda"), guest_id, start, end,
                   integer(data.get("guest_count", 1), "Kişi sayısı", 1, 20))
