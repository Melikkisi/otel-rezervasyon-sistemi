import uuid

from conftest import scalar
from scripts.init_db import connection


def test_login_and_roles(client,headers):
    assert client.get('/api/auth/me').status_code==401
    assert client.get('/api/dashboard',headers=headers['guest']).status_code==403
    assert client.get('/api/admin/rooms',headers=headers['reception']).status_code==403
    assert client.get('/api/dashboard',headers=headers['reception']).status_code==200
    assert client.post('/api/auth/login',json={'email':'admin@otel.test','password':'wrong'}).status_code==401
    assert client.get('/api/auth/me',headers={'Authorization':'Bearer invalid'}).status_code==401


def test_register_returns_guest_and_duplicate_rejected(client):
    token=uuid.uuid4().hex[:8]
    data=dict(first_name='Test',last_name='Misafir',identity_no='P'+token,phone='05551234567',email=f'{token}@test.example',birth_date='1997-01-01',password='StrongPass2026!',role='admin')
    response=client.post('/api/auth/register',json=data)
    assert response.status_code==201,response.json
    assert response.json['data']['user']['role']=='guest'
    assert client.post('/api/auth/register',json=data).status_code in (400,409)


def test_guest_booking_and_cancel(client,headers):
    response=client.get('/api/rooms/available?check_in=2092-01-01&check_out=2092-01-03&guest_count=1')
    assert response.status_code==200,response.json
    room=response.json['data'][0]
    payload=dict(room_id=room['id'],check_in='2092-01-01',check_out='2092-01-03',guest_count=1)
    booked=client.post('/api/reservations',json=payload,headers=headers['guest'])
    assert booked.status_code==201,booked.json
    rid=booked.json['data']['id']
    assert client.post('/api/reservations',json=payload,headers=headers['guest']).status_code in (400,409)
    assert client.put(f'/api/reservations/{rid}/cancel',headers=headers['guest']).status_code==200


def test_ownership_cannot_cancel_other_guest(client,headers,db):
    own=client.get('/api/auth/me',headers=headers['guest']).json['data']['guest_id']
    rid=scalar(db,"SELECT id FROM reservations WHERE guest_id<>%s AND status='confirmed' LIMIT 1",(own,))
    assert client.put(f'/api/reservations/{rid}/cancel',headers=headers['guest']).status_code in (403,404)


def test_admin_crud_and_fk_protection(client,headers):
    h=headers['admin']
    response=client.post('/api/admin/room-types',headers=h,json=dict(name='Test '+uuid.uuid4().hex[:6],capacity=2,description='Test room',base_price=850))
    assert response.status_code==201,response.json
    rid=response.json['data']['id']
    assert client.put(f'/api/admin/room-types/{rid}',headers=h,json=dict(name='Güncel '+uuid.uuid4().hex[:6],capacity=3,description='Güncellendi',base_price=950)).status_code==200
    assert client.delete(f'/api/admin/room-types/{rid}',headers=h).status_code in (200,204)
    assert client.delete('/api/admin/room-types/1',headers=h).status_code in (400,409)


def test_procedures_and_views_exposed(client,headers):
    dashboard=client.get('/api/dashboard',headers=headers['reception'])
    assert dashboard.status_code==200,dashboard.json
    assert len(dashboard.json['data']['rooms'])>=20
    assert 'movements' in dashboard.json['data']
    response=client.get('/api/reports/monthly?year=2026&month=11',headers=headers['admin'])
    assert response.status_code==200,response.json
    assert 'occupancy_rate' in response.json['data']
    assert client.get('/api/reports/monthly?year=2026&month=13',headers=headers['admin']).status_code==400


def test_checkout_failure_rolls_back_then_success_changes_room(client,headers,database_name):
    h=headers['reception']
    with connection(database_name) as db:
        stay=scalar(db,"SELECT id FROM stays WHERE checked_out_at IS NULL LIMIT 1")
        room=scalar(db,"SELECT r.room_id FROM stays s JOIN reservations r ON r.id=s.reservation_id WHERE s.id=%s",(stay,))
        before_payments=scalar(db,'SELECT COUNT(*) FROM payments WHERE stay_id=%s',(stay,))
        with db.cursor() as cur:
            cur.execute(f"CREATE TRIGGER test_payment_failure BEFORE INSERT ON payments FOR EACH ROW BEGIN IF NEW.stay_id={int(stay)} THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Test: payment rejected'; END IF; END")
        try:
            failed=client.post(f'/api/stays/{stay}/check-out',headers=h,json={'method':'card'})
            assert failed.status_code>=400,failed.json
            assert scalar(db,'SELECT checked_out_at FROM stays WHERE id=%s',(stay,)) is None
            assert scalar(db,'SELECT status FROM rooms WHERE id=%s',(room,))=='occupied'
            assert scalar(db,'SELECT COUNT(*) FROM payments WHERE stay_id=%s',(stay,))==before_payments
        finally:
            with db.cursor() as cur:
                cur.execute('DROP TRIGGER test_payment_failure')
    result=client.post(f'/api/stays/{stay}/check-out',headers=h,json={'method':'card'})
    assert result.status_code==200,result.json
    with connection(database_name) as db:
        assert scalar(db,'SELECT checked_out_at FROM stays WHERE id=%s',(stay,)) is not None
        assert scalar(db,'SELECT status FROM rooms WHERE id=%s',(room,))=='cleaning'
        assert scalar(db,'SELECT COUNT(*) FROM payments WHERE stay_id=%s',(stay,))==before_payments+1
    assert client.post(f'/api/stays/{stay}/check-out',headers=h,json={'method':'card'}).status_code in (400,409)
    assert client.post(f'/api/rooms/{room}/clean',headers=h).status_code==200
    with connection(database_name) as db:
        assert scalar(db,'SELECT status FROM rooms WHERE id=%s',(room,))=='available'


def test_dates_capacity_and_amount_validation(client,headers):
    assert client.get('/api/rooms/available?check_in=bad&check_out=2027-01-01').status_code==400
    assert client.get('/api/rooms/available?check_in=2090-01-02&check_out=2090-01-01').status_code==400
    assert client.post('/api/admin/services',headers=headers['admin'],json={'name':'Bad','unit_price':-50}).status_code==400
    assert client.post('/api/reservations',headers=headers['guest'],json={'room_id':1,'check_in':'2090-01-01','check_out':'2090-01-02','guest_count':100}).status_code in (400,409)


def test_reservation_confirmation_email(client,headers,app):
    outbox=app.extensions.setdefault('mail_outbox',[])
    before=len(outbox)
    rooms=client.get('/api/rooms/available?check_in=2093-03-01&check_out=2093-03-04&guest_count=1').json['data']
    payload=dict(room_id=rooms[0]['id'],check_in='2093-03-01',check_out='2093-03-04',guest_count=1)
    booked=client.post('/api/reservations',json=payload,headers=headers['guest'])
    assert booked.status_code==201,booked.json
    data=booked.json['data']
    assert data['notification']['sent'] is True
    assert data['notification']['to']=='misafir@otel.test'
    assert len(outbox)==before+1
    message=outbox[-1]
    assert 'misafir@otel.test' in message['To']
    assert f"#{data['id']}" in message['Subject']
    body=message.get_content()
    assert '3 gece' in body and data['room_number'] in body
    assert client.put(f"/api/reservations/{data['id']}/cancel",headers=headers['guest']).status_code==200
