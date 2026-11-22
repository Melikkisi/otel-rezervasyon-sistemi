"""Business rules and transaction boundaries, independent of HTTP routing."""
from datetime import timedelta
from decimal import Decimal
from werkzeug.security import check_password_hash, generate_password_hash
from .db import transaction
from .entities import (AppError, User, ReservationRequest, text, integer, money,
                       iso_date, email_address, password_value, choice, date_range, today)
from .repositories import Repository as Repo, UserRepository, ReservationRepository, StayRepository
from . import notifications


def require_record(record, label="Kayıt"):
    if record is None:
        raise AppError(f"{label} bulunamadı.", 404)
    return record


def require_owner(record, user):
    if user.role == "guest" and record["guest_id"] != user.guest_id:
        raise AppError("Bu kayda erişim yetkiniz yok.", 403)


class AuthService:
    @staticmethod
    def login(data):
        email = email_address(data.get("email"))
        password = data.get("password")
        if not isinstance(password, str) or len(password) > 128:
            raise AppError("E-posta veya parola hatalı.", 401)
        row = UserRepository.by_email(email)
        if row is None or not check_password_hash(row["password_hash"], password):
            raise AppError("E-posta veya parola hatalı.", 401)
        return User.from_row(row)

    @staticmethod
    def register(data):
        email = email_address(data.get("email"))
        password = password_value(data.get("password"))
        first = text(data.get("first_name"), "Ad", 80)
        last = text(data.get("last_name"), "Soyad", 80)
        identity = text(data.get("identity_no"), "TC/pasaport numarası", 30, 4)
        phone = text(data.get("phone"), "Telefon", 30, 6)
        birth = iso_date(data.get("birth_date"), "Doğum tarihi")
        if birth >= today() or birth < today() - timedelta(days=365 * 125):
            raise AppError("Doğum tarihi geçerli aralıkta olmalıdır.")
        with transaction():
            guest_id = Repo.insert("""INSERT INTO guests
                (first_name,last_name,identity_no,phone,email,birth_date) VALUES (%s,%s,%s,%s,%s,%s)""",
                (first, last, identity, phone, email, birth))
            user_id = Repo.insert("""INSERT INTO users
                (email,password_hash,role,guest_id) VALUES (%s,%s,'guest',%s)""",
                (email, generate_password_hash(password), guest_id))
        return User.from_row(UserRepository.by_id(user_id))


class ReservationService:
    @staticmethod
    def available(args):
        start, end = date_range(args, future=True)
        room_type = args.get("room_type_id")
        room_type = integer(room_type, "Oda tipi") if room_type else None
        guests = integer(args.get("guest_count", 1), "Kişi sayısı", 1, 20)
        return Repo.procedure("sp_available_rooms", (start, end, room_type, guests))

    @staticmethod
    def create(data, user):
        request = ReservationRequest.parse(data, user)
        with transaction():
            room = require_record(Repo.one("""SELECT o.*,t.capacity FROM rooms o
                JOIN room_types t ON t.id=o.room_type_id WHERE o.id=%s FOR UPDATE""", (request.room_id,)), "Oda")
            if room["status"] == "maintenance":
                raise AppError("Bakımdaki oda için rezervasyon oluşturulamaz.", 409)
            if request.guest_count > room["capacity"]:
                raise AppError("Kişi sayısı oda kapasitesini aşıyor.")
            require_record(Repo.one("SELECT id FROM guests WHERE id=%s", (request.guest_id,)), "Misafir")
            reservation_id = Repo.insert("""INSERT INTO reservations
                (guest_id,room_id,check_in,check_out,guest_count,status)
                VALUES (%s,%s,%s,%s,%s,'confirmed')""", tuple(vars(request)[key] for key in
                    ("guest_id", "room_id", "check_in", "check_out", "guest_count")))
        reservation = ReservationRepository.detail(reservation_id)
        # E-posta yalnızca COMMIT sonrasında gönderilir.
        reservation["notification"] = notifications.reservation_confirmed(reservation)
        return reservation

    @staticmethod
    def change_status(reservation_id, user, target):
        with transaction():
            reservation = require_record(Repo.one("SELECT * FROM reservations WHERE id=%s FOR UPDATE", (reservation_id,)), "Rezervasyon")
            require_owner(reservation, user)
            if reservation["status"] not in {"pending", "confirmed"}:
                raise AppError("Bu rezervasyonun durumu değiştirilemez.", 409)
            if Repo.one("SELECT id FROM stays WHERE reservation_id=%s", (reservation_id,)):
                raise AppError("Giriş yapılmış rezervasyon iptal edilemez veya yeniden onaylanamaz.", 409)
            if target == "confirmed" and reservation["status"] != "pending":
                raise AppError("Yalnızca bekleyen rezervasyon onaylanabilir.", 409)
            Repo.execute("UPDATE reservations SET status=%s WHERE id=%s", (target, reservation_id))
        reservation = ReservationRepository.detail(reservation_id)
        if target == "confirmed":
            reservation["notification"] = notifications.reservation_confirmed(reservation)
        return reservation


class StayService:
    @staticmethod
    def check_in(reservation_id, user):
        with transaction():
            reservation = require_record(Repo.one("SELECT * FROM reservations WHERE id=%s FOR UPDATE", (reservation_id,)), "Rezervasyon")
            if reservation["status"] != "confirmed":
                raise AppError("Giriş için onaylı bir rezervasyon gerekir.", 409)
            if not reservation["check_in"] <= today() < reservation["check_out"]:
                raise AppError("Giriş işlemi yalnızca rezervasyon tarih aralığında yapılabilir.", 409)
            if Repo.one("SELECT id FROM stays WHERE reservation_id=%s", (reservation_id,)):
                raise AppError("Bu rezervasyon için zaten giriş yapılmış.", 409)
            room = Repo.one("SELECT * FROM rooms WHERE id=%s FOR UPDATE", (reservation["room_id"],))
            if room["status"] != "available":
                raise AppError("Oda girişe hazır değil; temizlik veya bakım durumunu kontrol edin.", 409)
            stay_id = Repo.insert("INSERT INTO stays (reservation_id,check_in_staff_id) VALUES (%s,%s)", (reservation_id, user.staff_id))
        return StayRepository.detail(stay_id)

    @staticmethod
    def bill(stay_id, user):
        stay = require_record(StayRepository.detail(stay_id), "Konaklama")
        require_owner(stay, user)
        totals = require_record(next(iter(Repo.procedure("sp_stay_total", (stay_id,))), None), "Hesap")
        totals["services"] = Repo.all("""SELECT h.*,e.name FROM stay_services h
            JOIN services e ON e.id=h.service_id WHERE h.stay_id=%s ORDER BY h.used_at,h.id""", (stay_id,))
        totals["nights"] = Repo.all("""SELECT night_date,nightly_price FROM reservation_nights
            WHERE reservation_id=%s ORDER BY night_date""", (stay["reservation_id"],))
        totals["payments"] = Repo.all("SELECT * FROM payments WHERE stay_id=%s ORDER BY paid_at,id", (stay_id,))
        return totals

    @staticmethod
    def add_service(stay_id, data):
        service_id = integer(data.get("service_id"), "Hizmet")
        quantity = integer(data.get("quantity", 1), "Adet", 1, 1000)
        with transaction():
            stay = require_record(StayRepository.detail(stay_id, lock=True), "Konaklama")
            if stay["checked_out_at"] is not None:
                raise AppError("Kapanmış konaklamaya hizmet eklenemez.", 409)
            service = require_record(Repo.one("SELECT * FROM services WHERE id=%s FOR SHARE", (service_id,)), "Hizmet")
            service_record_id = Repo.insert("""INSERT INTO stay_services
                (stay_id,service_id,quantity,unit_price) VALUES (%s,%s,%s,%s)""",
                (stay_id, service_id, quantity, service["unit_price"]))
        return Repo.one("SELECT * FROM stay_services WHERE id=%s", (service_record_id,))

    @staticmethod
    def check_out(stay_id, data, user):
        method = choice(data.get("method"), ("cash", "card"), "Ödeme türü")
        with transaction():
            stay = require_record(StayRepository.detail(stay_id, lock=True), "Konaklama")
            if stay["checked_out_at"] is not None:
                raise AppError("Bu konaklamanın çıkışı daha önce yapılmış.", 409)
            bill = Repo.procedure("sp_stay_total", (stay_id,))[0]
            balance = Decimal(str(bill["balance"]))
            if balance < 0:
                raise AppError("Hesap bakiyesi tutarsız; çıkış tamamlanamadı.", 409)
            # The trigger marks the room cleaning and reservation completed.
            # A later payment failure rolls those changes and their audit records back.
            Repo.execute("""UPDATE stays SET checked_out_at=CURRENT_TIMESTAMP,
                check_out_staff_id=%s WHERE id=%s""", (user.staff_id, stay_id))
            if balance > 0:
                Repo.insert("INSERT INTO payments (stay_id,amount,method) VALUES (%s,%s,%s)", (stay_id, balance, method))
        return {"stay": StayRepository.detail(stay_id), "bill": StayService.bill(stay_id, user)}


class DashboardService:
    @staticmethod
    def dashboard():
        rooms = Repo.all("SELECT * FROM v_room_status ORDER BY number")
        movements = Repo.all("SELECT * FROM v_today_movements ORDER BY movement,room_number")
        return {"rooms": rooms, "movements": movements, "stats": {
            "total_rooms": len(rooms), "available_rooms": sum(r["status"] == "available" for r in rooms),
            "occupied_rooms": sum(r["status"] == "occupied" for r in rooms),
            "cleaning_rooms": sum(r["status"] == "cleaning" for r in rooms),
            "today_arrivals": sum(r["movement"] == "arrival" for r in movements),
            "today_departures": sum(r["movement"] == "departure" for r in movements)}}

    @staticmethod
    def clean(room_id, user):
        with transaction():
            room = require_record(Repo.one("SELECT * FROM rooms WHERE id=%s FOR UPDATE", (room_id,)), "Oda")
            if room["status"] != "cleaning":
                raise AppError("Yalnızca temizlikteki odanın temizliği tamamlanabilir.", 409)
            Repo.insert("INSERT INTO cleaning_records (room_id,staff_id,status) VALUES (%s,%s,'completed')", (room_id, user.staff_id))
            Repo.execute("UPDATE rooms SET status='available' WHERE id=%s", (room_id,))
        return Repo.one("SELECT * FROM v_room_status WHERE id=%s", (room_id,))

    @staticmethod
    def monthly(args):
        year = integer(args.get("year", today().year), "Yıl", 2000, 2100)
        month = integer(args.get("month", today().month), "Ay", 1, 12)
        return Repo.procedure("sp_monthly_report", (year, month))[0]


class AdminService:
    resources = {
        "room-types": ("room_types", {
            "name": lambda x: text(x, "Tip adı", 80),
            "capacity": lambda x: integer(x, "Kapasite", 1, 20),
            "description": lambda x: text(x, "Açıklama", 1000, 0),
            "base_price": lambda x: money(x, "Temel fiyat")}),
        "rooms": ("rooms", {
            "number": lambda x: text(str(x) if x is not None else x, "Oda numarası", 12),
            "floor": lambda x: integer(x, "Kat", -5, 200),
            "room_type_id": lambda x: integer(x, "Oda tipi"),
            "status": lambda x: choice(x, ("available", "cleaning", "maintenance"), "Oda durumu")}),
        "seasonal-prices": ("seasonal_prices", {
            "room_type_id": lambda x: integer(x, "Oda tipi"),
            "start_date": lambda x: iso_date(x, "Başlangıç tarihi"),
            "end_date": lambda x: iso_date(x, "Bitiş tarihi"),
            "nightly_price": lambda x: money(x, "Gecelik fiyat")}),
        "services": ("services", {
            "name": lambda x: text(x, "Hizmet adı", 100),
            "unit_price": lambda x: money(x, "Birim fiyat")}),
        "staff": ("staff", {
            "first_name": lambda x: text(x, "Ad", 80),
            "last_name": lambda x: text(x, "Soyad", 80),
            "position": lambda x: choice(x, ("reception", "housekeeping", "admin"), "Görev"),
            "hire_date": lambda x: iso_date(x, "İşe giriş tarihi")})}

    @classmethod
    def resource(cls, name):
        if name not in cls.resources:
            raise AppError("Kaynak bulunamadı.", 404)
        return cls.resources[name]

    @classmethod
    def list(cls, name):
        table, _ = cls.resource(name)
        if name == "staff":
            return Repo.all("SELECT s.*,u.email FROM staff s LEFT JOIN users u ON u.staff_id=s.id ORDER BY s.id")
        return Repo.all(f"SELECT * FROM {table} ORDER BY id")

    @classmethod
    def save(cls, name, data, user, record_id=None):
        table, validators = cls.resource(name)
        allowed = set(validators) | ({"email", "password"} if name == "staff" else set())
        unknown = set(data) - allowed
        if unknown:
            raise AppError("Desteklenmeyen alan: " + ", ".join(sorted(unknown)))
        if not data:
            raise AppError("Kaydedilecek alan bulunamadı.")
        clean = {key: validators[key](value) for key, value in data.items() if key in validators}
        if record_id is None and set(validators) - set(clean):
            raise AppError("Zorunlu alanlar eksik: " + ", ".join(sorted(set(validators) - set(clean))))
        account_email = email_address(data["email"]) if data.get("email") else None
        account_password = password_value(data["password"]) if data.get("password") else None
        with transaction():
            old = require_record(Repo.one(f"SELECT * FROM {table} WHERE id=%s FOR UPDATE", (record_id,))) if record_id else {}
            merged = {**old, **clean}
            if name == "seasonal-prices" and merged["end_date"] <= merged["start_date"]:
                raise AppError("Sezon bitişi başlangıçtan sonra olmalıdır.")
            if name == "rooms" and record_id:
                if old["status"] == "occupied" or Repo.one("""SELECT s.id FROM stays s JOIN reservations r
                    ON r.id=s.reservation_id WHERE r.room_id=%s AND s.checked_out_at IS NULL""", (record_id,)):
                    raise AppError("Konaklama sürerken oda bilgileri değiştirilemez.", 409)
                if ("room_type_id" in clean and clean["room_type_id"] != old["room_type_id"]) or clean.get("status") == "maintenance":
                    if Repo.one("SELECT id FROM reservations WHERE room_id=%s AND status IN ('pending','confirmed') AND check_out>CURRENT_DATE LIMIT 1", (record_id,)):
                        raise AppError("Gelecek rezervasyonu olan odanın tipi veya bakım durumu değiştirilemez.", 409)
            if name == "room-types" and record_id and clean.get("capacity", old["capacity"]) < old["capacity"]:
                if Repo.one("""SELECT r.id FROM reservations r JOIN rooms o ON o.id=r.room_id
                    WHERE o.room_type_id=%s AND r.guest_count>%s AND r.status IN ('pending','confirmed')
                    AND r.check_out>CURRENT_DATE LIMIT 1""", (record_id, clean["capacity"])):
                    raise AppError("Yeni kapasite mevcut rezervasyonlar için yetersiz.", 409)
            if name == "staff" and record_id == user.staff_id and merged["position"] != "admin":
                raise AppError("Kendi yönetici yetkinizi kaldıramazsınız.", 409)
            if record_id is None:
                columns = ",".join(clean)
                placeholders = ",".join(["%s"] * len(clean))
                record_id = Repo.insert(f"INSERT INTO {table} ({columns}) VALUES ({placeholders})", tuple(clean.values()))
            elif clean:
                sets = ",".join(f"{column}=%s" for column in clean)
                Repo.execute(f"UPDATE {table} SET {sets} WHERE id=%s", (*clean.values(), record_id))
            if name == "staff":
                cls.save_staff_account(record_id, merged["position"], account_email, account_password)
        if name == "staff":
            return Repo.one("SELECT s.*,u.email FROM staff s LEFT JOIN users u ON u.staff_id=s.id WHERE s.id=%s", (record_id,))
        return Repo.one(f"SELECT * FROM {table} WHERE id=%s", (record_id,))

    @staticmethod
    def save_staff_account(staff_id, position, email, password):
        account = Repo.one("SELECT * FROM users WHERE staff_id=%s", (staff_id,))
        if position == "housekeeping":
            if email or password:
                raise AppError("Kat görevlisine giriş hesabı atanamaz; resepsiyon veya yönetici görevi seçin.")
            if account:
                Repo.execute("DELETE FROM users WHERE id=%s", (account["id"],))
            return
        if account:
            Repo.execute("UPDATE users SET role=%s,email=%s WHERE id=%s", (position, email or account["email"], account["id"]))
            if password:
                Repo.execute("UPDATE users SET password_hash=%s WHERE id=%s", (generate_password_hash(password), account["id"]))
        elif email or password:
            if not email or not password:
                raise AppError("Yeni personel hesabı için e-posta ve parola birlikte gereklidir.")
            Repo.insert("INSERT INTO users (email,password_hash,role,staff_id) VALUES (%s,%s,%s,%s)",
                        (email, generate_password_hash(password), position, staff_id))

    @classmethod
    def delete(cls, name, record_id, user):
        table, _ = cls.resource(name)
        with transaction():
            require_record(Repo.one(f"SELECT id FROM {table} WHERE id=%s FOR UPDATE", (record_id,)))
            if name == "staff":
                if record_id == user.staff_id:
                    raise AppError("Kendi personel kaydınızı silemezsiniz.", 409)
                Repo.execute("DELETE FROM users WHERE staff_id=%s", (record_id,))
            Repo.execute(f"DELETE FROM {table} WHERE id=%s", (record_id,))
        return {"id": record_id, "deleted": True}
