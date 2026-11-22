"""JWT authentication. Authorization uses the current DB account, not stale claims."""
from datetime import datetime, timedelta, timezone
from functools import wraps
import jwt
from flask import current_app, g, request
from .entities import AppError, User
from .repositories import UserRepository


def issue_token(user):
    now = datetime.now(timezone.utc)
    return jwt.encode({"sub": str(user.id), "iat": now, "exp": now + timedelta(hours=8),
                       "iss": "mavi-otel", "aud": "mavi-otel-web"},
                      current_app.config["JWT_SECRET"], algorithm="HS256")


def authenticated(*roles):
    def decorate(view):
        @wraps(view)
        def wrapped(*args, **kwargs):
            header = request.headers.get("Authorization", "")
            if not header.startswith("Bearer "):
                raise AppError("Bu işlem için giriş yapın.", 401)
            token = header[7:]
            if not token or len(token) > 4096:
                raise AppError("Oturum geçersiz. Yeniden giriş yapın.", 401)
            try:
                payload = jwt.decode(token, current_app.config["JWT_SECRET"], algorithms=["HS256"],
                                     issuer="mavi-otel", audience="mavi-otel-web",
                                     options={"require": ["sub", "iat", "exp", "iss", "aud"]})
                user_id = int(payload["sub"])
            except (jwt.PyJWTError, ValueError, TypeError):
                raise AppError("Oturum süresi dolmuş veya geçersiz. Yeniden giriş yapın.", 401) from None
            row = UserRepository.by_id(user_id)
            if row is None:
                raise AppError("Kullanıcı hesabı artık aktif değil.", 401)
            g.user = User.from_row(row)
            if roles and g.user.role not in roles:
                raise AppError("Bu işlem için yetkiniz yok.", 403)
            return view(*args, **kwargs)
        return wrapped
    return decorate
