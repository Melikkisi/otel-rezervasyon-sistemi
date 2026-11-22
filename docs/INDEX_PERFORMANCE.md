# İndeks performans ölçümü

Gerçek MySQL 8.4.13 üzerinde, 100.000 satırlı geçici tabloda ölçüldü.
Tablo 200 oda ve 500 günlük sentetik kayıt içerir; uygulama verileri değiştirilmez.
Aynı sorgu, aynı veri ve aynı bağlantıda `IGNORE INDEX` / `FORCE INDEX` ile çalıştırılır.
Her seçenek için ilk 3 ısınma çalışması atılır, sonraki 15 çalışmanın medyanı alınır.
Süre, istemcinin sorguyu göndermesi ve sonucu okumasını birlikte kapsar.

| Durum | Medyan (ms) | En düşük (ms) | Eşleşen kayıt |
| --- | ---: | ---: | ---: |
| İndekssiz tarama | 7.7281 | 7.2765 | 31 |
| Bileşik indeks | 0.0478 | 0.0416 | 31 |

Bu koşullarda ölçülen hız oranı: **161.68 kat**. Sonuçlar donanıma,
önbelleğe ve veri dağılımına bağlıdır; küçük 200 kayıtlık demo tablosunda aynı oran beklenmez.

```sql
SELECT COUNT(*) FROM perf_reservations WHERE room_id=42 AND check_in >= '2026-01-01' AND check_in < '2026-02-01';
```

İndeks sırası `(room_id, check_in, check_out)`: oda eşitliği ardından tarih aralığı.

## İndekssiz gerçek yürütme planı

```text
-> Aggregate: count(0)  (cost=10287 rows=1) (actual time=8.92..8.92 rows=1 loops=1)
    -> Filter: ((perf_reservations.room_id = 42) and (perf_reservations.check_in >= DATE'2026-01-01') and (perf_reservations.check_in < DATE'2026-02-01'))  (cost=10287 rows=1) (actual time=6.8..8.92 rows=31 loops=1)
        -> Table scan on perf_reservations  (cost=10287 rows=100623) (actual time=0.477..7.15 rows=100000 loops=1)

```

## İndeksli gerçek yürütme planı

```text
-> Aggregate: count(0)  (cost=19.7 rows=1) (actual time=0.00688..0.00688 rows=1 loops=1)
    -> Filter: ((perf_reservations.room_id = 42) and (perf_reservations.check_in >= DATE'2026-01-01') and (perf_reservations.check_in < DATE'2026-02-01'))  (cost=13.5 rows=62) (actual time=0.00363..0.00629 rows=31 loops=1)
        -> Covering index range scan on perf_reservations using ix_room_dates over (room_id = 42 AND '2026-01-01' <= check_in < '2026-02-01')  (cost=13.5 rows=62) (actual time=0.00321..0.00425 rows=31 loops=1)

```

Tekrar üretme: `python scripts/benchmark_indexes.py`.
Makine tarafından okunabilir ölçüm: [index-performance.json](index-performance.json).
