"""Persistence layer. SQL identifiers are internal constants, values are bound."""
from .db import get_db


class Repository:
    @staticmethod
    def all(sql, args=()):
        with get_db().cursor() as cursor:
            cursor.execute(sql, args)
            return cursor.fetchall()

    @staticmethod
    def one(sql, args=()):
        with get_db().cursor() as cursor:
            cursor.execute(sql, args)
            return cursor.fetchone()

    @staticmethod
    def execute(sql, args=()):
        with get_db().cursor() as cursor:
            cursor.execute(sql, args)
            return cursor.rowcount

    @staticmethod
    def insert(sql, args=()):
        with get_db().cursor() as cursor:
            cursor.execute(sql, args)
            return cursor.lastrowid

    @staticmethod
    def procedure(name, args):
        if name not in {"sp_available_rooms", "sp_stay_total", "sp_monthly_report"}:
            raise ValueError("Unsupported procedure")
        with get_db().cursor() as cursor:
            cursor.callproc(name, args)
            rows = cursor.fetchall()
            # MySQL CALL appends an empty result set; always consume it.
            while cursor.nextset():
                pass
            return rows


class UserRepository(Repository):
    query = """SELECT u.*, COALESCE(CONCAT(g.first_name,' ',g.last_name),
                  CONCAT(s.first_name,' ',s.last_name),u.email) AS name
               FROM users u LEFT JOIN guests g ON g.id=u.guest_id
               LEFT JOIN staff s ON s.id=u.staff_id"""

    @classmethod
    def by_email(cls, email):
        return cls.one(cls.query + " WHERE u.email=%s", (email,))

    @classmethod
    def by_id(cls, user_id):
        return cls.one(cls.query + " WHERE u.id=%s", (user_id,))


class ReservationRepository(Repository):
    query = """SELECT r.*, CONCAT(g.first_name,' ',g.last_name) guest_name,
                      o.number room_number,t.name type_name,s.id stay_id,
                      s.checked_in_at,s.checked_out_at,
                      (SELECT COALESCE(SUM(n.nightly_price),0) FROM reservation_nights n
                       WHERE n.reservation_id=r.id) total_price
               FROM reservations r JOIN guests g ON g.id=r.guest_id
               JOIN rooms o ON o.id=r.room_id JOIN room_types t ON t.id=o.room_type_id
               LEFT JOIN stays s ON s.reservation_id=r.id"""

    @classmethod
    def list_for(cls, user):
        where = " WHERE r.guest_id=%s" if user.role == "guest" else ""
        args = (user.guest_id,) if user.role == "guest" else ()
        return cls.all(cls.query + where + " ORDER BY r.check_in DESC,r.id DESC LIMIT 1000", args)

    @classmethod
    def detail(cls, reservation_id):
        return cls.one(cls.query + " WHERE r.id=%s", (reservation_id,))


class StayRepository(Repository):
    query = """SELECT s.*,r.guest_id,r.room_id,r.check_in,r.check_out,r.status,
                    CONCAT(g.first_name,' ',g.last_name) guest_name,o.number room_number
               FROM stays s JOIN reservations r ON r.id=s.reservation_id
               JOIN guests g ON g.id=r.guest_id JOIN rooms o ON o.id=r.room_id"""

    @classmethod
    def list_for(cls, user):
        where = " WHERE r.guest_id=%s" if user.role == "guest" else ""
        args = (user.guest_id,) if user.role == "guest" else ()
        return cls.all(cls.query + where + " ORDER BY s.checked_in_at DESC LIMIT 1000", args)

    @classmethod
    def detail(cls, stay_id, lock=False):
        return cls.one(cls.query + " WHERE s.id=%s" + (" FOR UPDATE" if lock else ""), (stay_id,))
