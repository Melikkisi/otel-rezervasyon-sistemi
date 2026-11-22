"""Reproducible comparison on an isolated 100,000-row temporary table."""
import json
from pathlib import Path
import statistics
import time

from init_db import connection
import os


def main():
    database = os.getenv("DB_NAME", "mavi_otel")
    with connection(database) as db, db.cursor() as cur:
        cur.execute("CREATE TEMPORARY TABLE perf_reservations (id INT PRIMARY KEY,room_id INT NOT NULL,check_in DATE NOT NULL,check_out DATE NOT NULL,INDEX ix_room_dates(room_id,check_in,check_out)) ENGINE=InnoDB")
        for offset in range(0, 100000, 2000):
            rows=[(i+1, i%200+1, i//200) for i in range(offset,offset+2000)]
            cur.executemany("INSERT INTO perf_reservations VALUES (%s,%s,DATE_ADD('2025-01-01',INTERVAL %s DAY),DATE_ADD('2025-01-01',INTERVAL 3 DAY))",rows)
        cur.execute("UPDATE perf_reservations SET check_out=DATE_ADD(check_in,INTERVAL 3 DAY)")
        cur.execute("SELECT VERSION()")
        version=cur.fetchone()[0]
        results={"rows":100000,"mysql_version":version,"repeats":15,"query":"SELECT COUNT(*) FROM perf_reservations WHERE room_id=42 AND check_in >= '2026-01-01' AND check_in < '2026-02-01'","results":{}}
        for mode,hint in [("without_index","IGNORE INDEX (ix_room_dates)"),("with_index","FORCE INDEX (ix_room_dates)")]:
            query=results["query"].replace("perf_reservations WHERE",f"perf_reservations {hint} WHERE")
            samples=[]
            for run in range(18):
                start=time.perf_counter()
                cur.execute(query)
                count=cur.fetchone()[0]
                elapsed=(time.perf_counter()-start)*1000
                if run>=3:
                    samples.append(elapsed)
            cur.execute("EXPLAIN ANALYZE "+query)
            plan="\n".join(row[0] for row in cur.fetchall())
            results["results"][mode]={"median_ms":round(statistics.median(samples),4),"min_ms":round(min(samples),4),"matched_rows":count,"plan":plan}
        results["speedup"]=round(results["results"]["without_index"]["median_ms"]/results["results"]["with_index"]["median_ms"],2)
    out=Path(__file__).resolve().parents[1]/"docs"
    (out/"index-performance.json").write_text(json.dumps(results,ensure_ascii=False,indent=2)+"\n")
    slow=results['results']['without_index']; fast=results['results']['with_index']
    report=f"""# İndeks performans ölçümü

Gerçek MySQL {version} üzerinde, 100.000 satırlı geçici tabloda ölçüldü.
Tablo 200 oda ve 500 günlük sentetik kayıt içerir; uygulama verileri değiştirilmez.
Aynı sorgu, aynı veri ve aynı bağlantıda `IGNORE INDEX` / `FORCE INDEX` ile çalıştırılır.
Her seçenek için ilk 3 ısınma çalışması atılır, sonraki 15 çalışmanın medyanı alınır.
Süre, istemcinin sorguyu göndermesi ve sonucu okumasını birlikte kapsar.

| Durum | Medyan (ms) | En düşük (ms) | Eşleşen kayıt |
| --- | ---: | ---: | ---: |
| İndekssiz tarama | {slow['median_ms']} | {slow['min_ms']} | {slow['matched_rows']} |
| Bileşik indeks | {fast['median_ms']} | {fast['min_ms']} | {fast['matched_rows']} |

Bu koşullarda ölçülen hız oranı: **{results['speedup']} kat**. Sonuçlar donanıma,
önbelleğe ve veri dağılımına bağlıdır; küçük 200 kayıtlık demo tablosunda aynı oran beklenmez.

```sql
{results['query']};
```

İndeks sırası `(room_id, check_in, check_out)`: oda eşitliği ardından tarih aralığı.

## İndekssiz gerçek yürütme planı

```text
{slow['plan']}
```

## İndeksli gerçek yürütme planı

```text
{fast['plan']}
```

Tekrar üretme: `python scripts/benchmark_indexes.py`.
Makine tarafından okunabilir ölçüm: [index-performance.json](index-performance.json).
"""
    (out/"INDEX_PERFORMANCE.md").write_text(report,encoding="utf-8")
    print(json.dumps({"rows":results['rows'],"without_index_ms":slow['median_ms'],"with_index_ms":fast['median_ms'],"speedup":results['speedup']},ensure_ascii=False))


if __name__=="__main__":
    main()
