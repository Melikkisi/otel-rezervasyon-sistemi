# Test senaryoları ve sonuçlar

Testler gerçek bir MySQL 8.4 sunucusunda çalışır. Her çalıştırmada `mavi_test_<rastgele>`
adlı yeni bir veritabanı oluşturulur, `schema.sql` ve `seed.sql` yüklenir, testler
bittiğinde bu veritabanı silinir. Demo veritabanı (`mavi_otel`) değişmez.

```bash
python -m pytest -v
```

## Veritabanı testleri (`tests/test_database.py`)

Bu testler uygulamayı kullanmadan doğrudan SQL çalıştırır. Böylece kuralların
yalnızca Python kodunda değil, veritabanında uygulandığı gösterilir.

| Test | Senaryo | Beklenen sonuç |
| --- | --- | --- |
| `test_seed_and_required_objects` | Örnek veri sayıları ve veritabanı nesneleri | ≥20 oda, ≥50 misafir, ≥200 rezervasyon; ≥3 trigger, ≥3 prosedür, ≥2 view |
| `test_database_blocks_overlap_and_allows_adjacent_nights` | Aynı odaya çakışan tarihli INSERT | Tetikleyici hata verir; çıkış gününde başlayan rezervasyon kabul edilir |
| `test_update_overlap_is_blocked` | Mevcut rezervasyonun tarihini çakışacak şekilde UPDATE | Reddedilir |
| `test_cancel_releases_room_and_is_audited` | İptal edilen rezervasyonun tarihleri | Oda tekrar rezerve edilebilir; `audit_logs` içinde INSERT ve UPDATE kaydı oluşur |
| `test_nightly_season_price_and_historical_snapshot` | Sezona giren/çıkan 3 gecelik konaklama | 100 + 150 + 150 = 400; sezon fiyatı sonradan değişse de tutar korunur |
| `test_concurrent_bookings_cannot_both_commit` | İki ayrı bağlantı aynı anda aynı odayı ayırmaya çalışır | Yalnızca biri başarılı olur |
| `test_overlapping_seasons_rejected` | Aynı oda tipine çakışan iki sezon | İkincisi reddedilir |
| `test_invalid_reservation_dates_rejected` | Çıkışı girişten önce olan kayıt | Reddedilir |

## API testleri (`tests/test_api.py`)

| Test | Senaryo | Beklenen sonuç |
| --- | --- | --- |
| `test_login_and_roles` | Token olmadan, yanlış parola, yanlış rol | 401 / 403; doğru rolle 200 |
| `test_register_returns_guest_and_duplicate_rejected` | Kayıtta `role=admin` gönderilmesi ve aynı kişinin tekrar kaydı | Hesap misafir olarak açılır; tekrar kayıt reddedilir |
| `test_guest_booking_and_cancel` | Boş oda arama (prosedür), rezervasyon, aynı odaya ikinci istek, iptal | 201, ardından 409, iptal 200 |
| `test_ownership_cannot_cancel_other_guest` | Misafirin başka misafirin rezervasyonunu iptal etmesi | 403 / 404 |
| `test_admin_crud_and_fk_protection` | Oda tipi ekle/güncelle/sil; odası olan tipi silme | CRUD başarılı; bağlı kayıt silinemez (409) |
| `test_procedures_and_views_exposed` | Dashboard view'ları ve aylık rapor prosedürü | Veriler döner; geçersiz ay 400 |
| `test_checkout_failure_rolls_back_then_success_changes_room` | Ödeme adımı bilerek hata verdirilen check-out | Konaklama açık, oda dolu, ödeme sayısı aynı (ROLLBACK). Hata kaldırılınca çıkış tamamlanır, oda temizlikte; temizlik sonrası boş |
| `test_dates_capacity_and_amount_validation` | Hatalı tarih, kapasite aşımı, negatif fiyat | 400 / 409 |
| `test_reservation_confirmation_email` | Misafir rezervasyonu sonrası onay e-postası | Tek e-posta, doğru alıcı, rezervasyon no ve gece sayısı içerir |

## Postman

`docs/Mavi-Otel.postman_collection.json` beş klasörde 60'tan fazla istek içerir:
giriş ve yetki, prosedür/view okumaları, yönetim CRUD'u, rezervasyondan ödemeye
uçtan uca akış ve iptal senaryoları. Her istekte durum kodu ve cevap içeriği için
test betikleri vardır.

```bash
npx newman run docs/Mavi-Otel.postman_collection.json --env-var base_url=http://127.0.0.1:5000
```
