# REST API özeti

Tüm uç noktalar `/api` önekiyle çalışır. Kimlik doğrulama `Authorization: Bearer <token>`
başlığıyla yapılır. Başarılı cevaplar `{"data": ...}`, hatalar `{"error": "Türkçe mesaj"}`
biçimindedir. Tarihler `YYYY-AA-GG`, para tutarları sayı olarak döner.
Roller: `guest` (misafir), `reception` (resepsiyon), `admin` (yönetici).

## Tablo adları

Kodda İngilizce tablo adları kullanılmıştır. Ödevdeki karşılıkları:

| Ödev | Veritabanı | Not |
| --- | --- | --- |
| OdaTipi | `room_types` | ad, kapasite, açıklama, temel fiyat |
| Oda | `rooms` | durum: `available` boş, `occupied` dolu, `cleaning` temizlikte, `maintenance` bakımda |
| SezonFiyati | `seasonal_prices` | bitiş tarihi dahil değildir |
| Misafir | `guests` | |
| Kullanici | `users` | misafir veya personel kaydına bağlı |
| Personel | `staff` | `reception`, `housekeeping`, `admin` |
| Rezervasyon | `reservations` | `pending`, `confirmed`, `cancelled`, `completed` |
| Konaklama | `stays` | gerçek giriş/çıkış zamanı ve işlemi yapan personel |
| EkHizmet | `services` | |
| KonaklamaHizmeti | `stay_services` | hizmetin o anki birim fiyatı saklanır |
| Odeme | `payments` | `cash`, `card` |
| TemizlikKaydi | `cleaning_records` | |
| IslemLog | `audit_logs` | tetikleyiciler doldurur |
| (ek) | `reservation_nights` | her gecenin rezervasyon anındaki fiyatı |
| (ek) | `room_calendar` | oda + gece benzersiz anahtarı, çakışma koruması |

## Uç noktalar

| Yöntem | Yol | Yetki | Açıklama |
| --- | --- | --- | --- |
| GET | `/health` | herkes | Uygulama ve veritabanı bağlantısı |
| POST | `/auth/register` | herkes | Misafir kaydı, token döner |
| POST | `/auth/login` | herkes | Giriş, token döner |
| GET | `/auth/me` | giriş yapmış | Oturum bilgisi |
| GET | `/room-types` | herkes | Oda tipleri |
| GET | `/rooms/available` | herkes | `sp_available_rooms` ile boş oda arama (`check_in`, `check_out`, `room_type_id`, `guest_count`) |
| GET | `/reservations` | giriş yapmış | Misafir kendi kayıtlarını, personel tümünü görür |
| POST | `/reservations` | giriş yapmış | Rezervasyon oluşturma; personel `guest_id` gönderir. Cevaptaki `notification` alanı onay e-postasının durumunu gösterir |
| PUT | `/reservations/:id/cancel` | sahibi / personel | İptal |
| PUT | `/reservations/:id/confirm` | personel | Bekleyen rezervasyonu onaylama, misafire e-posta |
| POST | `/reservations/:id/check-in` | personel | Giriş, oda `occupied` olur |
| GET | `/stays` | giriş yapmış | Konaklama geçmişi |
| GET | `/stays/:id/bill` | sahibi / personel | `sp_stay_total` ile hesap dökümü |
| POST | `/stays/:id/services` | personel | Ek hizmet ekleme |
| POST | `/stays/:id/check-out` | personel | Tek transaction: çıkış + ödeme + oda durumu |
| GET | `/services` | personel | Hizmet listesi |
| GET | `/guests` | personel | Misafir listesi |
| GET | `/dashboard` | personel | `v_room_status` ve `v_today_movements` |
| POST | `/rooms/:id/clean` | personel | Temizlik kaydı, oda tekrar `available` |
| GET | `/reports/monthly` | yönetici | `sp_monthly_report` (`year`, `month`) |
| GET | `/admin/audit-logs` | yönetici | Son 100 işlem kaydı |
| GET/POST | `/admin/:kaynak` | yönetici | Listeleme / ekleme |
| PUT/DELETE | `/admin/:kaynak/:id` | yönetici | Güncelleme / silme |

Yönetim kaynakları: `room-types`, `rooms`, `seasonal-prices`, `services`, `staff`.
Personel eklerken isteğe bağlı `email` ve `password` gönderilirse giriş hesabı da açılır.
Dolu oda elle değiştirilemez; başka kayıtlarda kullanılan kayıt silinmek istendiğinde
409 ve açıklayıcı bir mesaj döner.

Tüm isteklerin örnekleri [Postman koleksiyonunda](Mavi-Otel.postman_collection.json) bulunur.
