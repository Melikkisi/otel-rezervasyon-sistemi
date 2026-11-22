from concurrent.futures import ThreadPoolExecutor
from decimal import Decimal
from threading import Barrier

import pymysql
import pytest

from scripts.init_db import connection
from conftest import scalar, insert_reservation


def test_seed_and_required_objects(db):
    for table, minimum in [("rooms",20),("guests",50),("reservations",200)]:
        assert scalar(db,f"SELECT COUNT(*) FROM {table}") >= minimum
    assert scalar(db,"SELECT COUNT(*) FROM information_schema.triggers WHERE trigger_schema=DATABASE()") >= 3
    assert scalar(db,"SELECT COUNT(*) FROM information_schema.routines WHERE routine_schema=DATABASE() AND routine_type='PROCEDURE'") >= 3
    assert scalar(db,"SELECT COUNT(*) FROM information_schema.views WHERE table_schema=DATABASE()") >= 2


def test_database_blocks_overlap_and_allows_adjacent_nights(db):
    insert_reservation(db)
    with pytest.raises(pymysql.MySQLError):
        insert_reservation(db, start="2090-01-02",end="2090-01-04")
    assert insert_reservation(db,start="2090-01-03",end="2090-01-04")


def test_update_overlap_is_blocked(db):
    insert_reservation(db)
    other = insert_reservation(db,start="2090-01-05",end="2090-01-07")
    with db.cursor() as cur, pytest.raises(pymysql.MySQLError):
        cur.execute("UPDATE reservations SET check_in='2090-01-02' WHERE id=%s",(other,))


def test_cancel_releases_room_and_is_audited(db):
    rid = insert_reservation(db)
    with db.cursor() as cur:
        cur.execute("UPDATE reservations SET status='cancelled' WHERE id=%s",(rid,))
    assert insert_reservation(db)
    assert scalar(db,"SELECT COUNT(*) FROM audit_logs WHERE table_name='reservations' AND record_id=%s",(rid,)) >= 2


def test_nightly_season_price_and_historical_snapshot(db):
    with db.cursor() as cur:
        cur.execute("INSERT INTO room_types(name,capacity,description,base_price) VALUES ('Fiyat testi',2,'Test',100)")
        tid=cur.lastrowid
        cur.execute("INSERT INTO rooms(number,floor,room_type_id,status) VALUES ('TESTP',9,%s,'available')",(tid,))
        room=cur.lastrowid
        cur.execute("INSERT INTO seasonal_prices(room_type_id,start_date,end_date,nightly_price) VALUES (%s,'2091-01-02','2091-01-04',150)",(tid,))
        rid=insert_reservation(db,room,"2091-01-01","2091-01-04")
        assert scalar(db,"SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id=%s",(rid,)) == Decimal("400.00")
        cur.execute("UPDATE seasonal_prices SET nightly_price=500 WHERE room_type_id=%s",(tid,))
        assert scalar(db,"SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id=%s",(rid,)) == Decimal("400.00")


def test_concurrent_bookings_cannot_both_commit(database_name):
    barrier=Barrier(2)
    def book(_):
        conn=connection(database_name)
        conn.autocommit(False)
        try:
            barrier.wait(timeout=10)
            insert_reservation(conn,room_id=1,start="2095-01-01",end="2095-01-04")
            conn.commit()
            return "success"
        except pymysql.MySQLError:
            conn.rollback()
            return "rejected"
        finally:
            conn.close()
    with ThreadPoolExecutor(max_workers=2) as pool:
        results=list(pool.map(book,range(2)))
    assert sorted(results)==["rejected","success"]


def test_overlapping_seasons_rejected(db):
    with db.cursor() as cur:
        cur.execute("INSERT INTO seasonal_prices(room_type_id,start_date,end_date,nightly_price) VALUES (1,'2093-01-01','2093-01-10',150)")
        with pytest.raises(pymysql.MySQLError):
            cur.execute("INSERT INTO seasonal_prices(room_type_id,start_date,end_date,nightly_price) VALUES (1,'2093-01-05','2093-01-15',200)")


def test_invalid_reservation_dates_rejected(db):
    with pytest.raises(pymysql.MySQLError):
        insert_reservation(db,start="2090-01-03",end="2090-01-01")
