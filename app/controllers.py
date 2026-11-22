"""HTTP controllers: parse the request, authorize, delegate, serialize."""
from flask import Blueprint, g, jsonify, request
from .auth import authenticated, issue_token
from .entities import AppError
from .repositories import Repository as Repo, ReservationRepository, StayRepository
from .services import AuthService, ReservationService, StayService, DashboardService, AdminService

api = Blueprint("api", __name__, url_prefix="/api")


def body():
    if not request.is_json:
        raise AppError("İstek gövdesi application/json biçiminde olmalıdır.", 415)
    value = request.get_json()
    if not isinstance(value, dict):
        raise AppError("İstek gövdesi bir JSON nesnesi olmalıdır.")
    return value


def ok(value, status=200):
    return jsonify(data=value), status


@api.get("/health")
def health():
    Repo.one("SELECT 1 AS alive")
    return ok({"status": "ok", "database": "connected"})


@api.post("/auth/login")
def login():
    user = AuthService.login(body())
    return ok({"token": issue_token(user), "user": user.public()})


@api.post("/auth/register")
def register():
    user = AuthService.register(body())
    return ok({"token": issue_token(user), "user": user.public()}, 201)


@api.get("/auth/me")
@authenticated()
def me():
    return ok(g.user.public())


@api.get("/room-types")
def room_types():
    return ok(Repo.all("SELECT * FROM room_types ORDER BY base_price,id"))


@api.get("/services")
@authenticated("admin", "reception")
def services():
    return ok(Repo.all("SELECT * FROM services ORDER BY name"))


@api.get("/rooms/available")
def available_rooms():
    return ok(ReservationService.available(request.args))


@api.get("/reservations")
@authenticated()
def reservations():
    return ok(ReservationRepository.list_for(g.user))


@api.post("/reservations")
@authenticated()
def create_reservation():
    return ok(ReservationService.create(body(), g.user), 201)


@api.put("/reservations/<int:reservation_id>/cancel")
@authenticated()
def cancel_reservation(reservation_id):
    return ok(ReservationService.change_status(reservation_id, g.user, "cancelled"))


@api.put("/reservations/<int:reservation_id>/confirm")
@authenticated("admin", "reception")
def confirm_reservation(reservation_id):
    return ok(ReservationService.change_status(reservation_id, g.user, "confirmed"))


@api.get("/stays")
@authenticated()
def stays():
    return ok(StayRepository.list_for(g.user))


@api.post("/reservations/<int:reservation_id>/check-in")
@authenticated("admin", "reception")
def check_in(reservation_id):
    return ok(StayService.check_in(reservation_id, g.user), 201)


@api.get("/stays/<int:stay_id>/bill")
@authenticated()
def stay_bill(stay_id):
    return ok(StayService.bill(stay_id, g.user))


@api.post("/stays/<int:stay_id>/services")
@authenticated("admin", "reception")
def add_service(stay_id):
    return ok(StayService.add_service(stay_id, body()), 201)


@api.post("/stays/<int:stay_id>/check-out")
@authenticated("admin", "reception")
def check_out(stay_id):
    return ok(StayService.check_out(stay_id, body(), g.user))


@api.get("/dashboard")
@authenticated("admin", "reception")
def dashboard():
    return ok(DashboardService.dashboard())


@api.post("/rooms/<int:room_id>/clean")
@authenticated("admin", "reception")
def clean_room(room_id):
    return ok(DashboardService.clean(room_id, g.user))


@api.get("/guests")
@authenticated("admin", "reception")
def guests():
    return ok(Repo.all("SELECT * FROM guests ORDER BY first_name,last_name LIMIT 1000"))


@api.get("/reports/monthly")
@authenticated("admin")
def monthly_report():
    return ok(DashboardService.monthly(request.args))


@api.get("/admin/audit-logs")
@authenticated("admin")
def audit_logs():
    return ok(Repo.all("SELECT * FROM audit_logs ORDER BY id DESC LIMIT 100"))


@api.get("/admin/<resource>")
@authenticated("admin")
def admin_list(resource):
    return ok(AdminService.list(resource))


@api.post("/admin/<resource>")
@authenticated("admin")
def admin_create(resource):
    return ok(AdminService.save(resource, body(), g.user), 201)


@api.put("/admin/<resource>/<int:record_id>")
@authenticated("admin")
def admin_update(resource, record_id):
    return ok(AdminService.save(resource, body(), g.user, record_id))


@api.delete("/admin/<resource>/<int:record_id>")
@authenticated("admin")
def admin_delete(resource, record_id):
    return ok(AdminService.delete(resource, record_id, g.user))
