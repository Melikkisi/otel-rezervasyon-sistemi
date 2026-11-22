# Mavi Otel · Proje raporu

## Amaç ve mimari

Otelin rezervasyon, konaklama, ek hizmet, ödeme, oda hazırlığı ve personel yönetimi
tek bir uygulamada toplanır. Sunucu **Flask**, veri erişimi **PyMySQL**, veritabanı
**MySQL 8.4 / InnoDB**, arayüz HTML/CSS/JavaScript'tir. Frontend ve API aynı kaynaktan
sunulur; ilave Node.js derlemesi veya üçüncü taraf CDN gerekmez.

Katman akışı: `Controller → Service → Repository → MySQL`.
`entities.py` alan doğrulama ve kullanıcı/rezervasyon modellerini tanımlar.
Servisler yetki ve iş kurallarını, repository parametreli SQL erişimini, controller
HTTP durum kodlarını ve JSON sözleşmesini yönetir. Parolalar hash'lenir; JWT'nin
imzası ve süresi doğrulanır, her istekte kullanıcı/rol veritabanından yeniden okunur.
Misafir başka misafirin rezervasyonuna veya hesabına erişemez.

## Tarih ve ücret kuralları

- Tarih aralıkları **[giriş, çıkış)** biçimindedir: çıkış günü gece sayılmaz. Aynı
  odada bir rezervasyonun çıkış günü başka rezervasyon başlayabilir.
- Sezon bitiş tarihi de dışlayıcıdır. Örneğin 1–4 Ocak, 1/2/3 Ocak gecelerini kapsar.
- Her gece için geçerli sezon fiyatı, sezon yoksa oda tipinin temel fiyatı uygulanır.
- Gece fiyatları rezervasyon sırasında kaydedilir; sonradan yapılan fiyat
  değişiklikleri geçmiş veya sözleşilmiş hesabı değiştirmez.
- Bekleyen ve onaylı rezervasyonlar geceyi tutar; iptal rezervasyon odayı serbest bırakır.
- Check-in onaylı rezervasyonda, uygun tarihte ve fiziksel olarak boş odada yapılır.
  Bakım/temizlik/dolu odada giriş yapılamaz.
- Konaklama toplamı = rezerve edilen geceler + kullanılan hizmetler. Erken çıkış,
  rezervasyon gecelerini kendiliğinden yeniden fiyatlandırmaz; iade/uzatma bu sürümün
  kapsamı dışındadır. Gerçek giriş/çıkış zamanı ayrıca saklanır.
- Otel tarihi ve SQL oturumu Türkiye saatine (`Europe/Istanbul`, `+03:00`) göre çalışır.

## Veritabanı nesneleri

[ER diyagramı ve 3NF açıklaması](ER_DIAGRAM.md) ilişkileri ve tablo eşlemesini içerir.

Rezervasyon tetikleyicileri giriş/çıkış tarihlerini, kapasiteyi ve oda çakışmasını
kontrol eder. Oda satırındaki kilide ek olarak `room_calendar(room_id,night_date)`
benzersiz anahtarı iki eşzamanlı işlemin aynı geceyi almasını engeller.
Kural sadece uygulama katmanında değildir; doğrudan SQL ile yapılan geçersiz INSERT
ve UPDATE işlemleri de reddedilir.

Konaklama tetikleyicileri check-in sonrası odayı `occupied`, check-out sonrası
`cleaning` yapar. Temizlik kaydı tamamlandığında oda `available` olur. Rezervasyon ve
ödeme INSERT/UPDATE/DELETE işlemlerinin eski/yeni değerleri JSON olarak audit tablosuna
yazılır. Audit kayıtları da aynı transaction'a katılır.

| Nesne | Görev | API erişimi |
| --- | --- | --- |
| `sp_available_rooms` | Tarih/oda tipi/kapasiteye göre müsaitlik ve toplam ücret | `GET /api/rooms/available` |
| `sp_stay_total` | Gece, hizmet, ödenen tutar ve bakiye | `GET /api/stays/:id/bill` |
| `sp_monthly_report` | Aylık doluluk ve tahsil edilen gelir | `GET /api/reports/monthly` |
| `v_today_movements` | Bugünün giriş/çıkış listesi | `GET /api/dashboard` |
| `v_room_status` | Oda durumu ve son tamamlanan temizlik | `GET /api/dashboard` |

Prosedürler repository içinde gerçekten `CALL` ile çağrılır. View'lar API tarafından
SELECT ile okunur; sadece tanımlanıp kullanılmadan bırakılmaz.

## Atomik çıkış

1. Konaklama satırı `FOR UPDATE` ile kilitlenir, açık olduğu doğrulanır.
2. Prosedürle toplam ve bakiye hesaplanır.
3. Gerçek çıkış/personel kaydedilir; tetikleyici rezervasyonu ve oda durumunu günceller.
4. Bakiye için ödeme kaydı oluşturulur.
5. Tüm adımlar başarılıysa `COMMIT`; herhangi bir hata varsa `ROLLBACK`.

Test, ödeme INSERT'ünü bilerek reddeden **yalnızca test veritabanında** bir tetikleyici
oluşturur. Böylece son adım hata verdiğinde konaklama açık, oda dolu, ödeme ve işlem
günlüğü eski halinde kalmalıdır. Uygulamada hata üretmek için açık bırakılmış bir API
veya test arka kapısı yoktur.

## E-posta bildirimi

Rezervasyon oluşturulduğunda (onaylı) veya bekleyen rezervasyon onaylandığında misafire
onay e-postası gönderilir. Gönderim `transaction()` bloğundan **sonra** yapılır; böylece
geri alınan bir işlem için e-posta çıkmaz, e-posta sunucusundaki bir hata da kaydedilmiş
rezervasyonu bozmaz. SMTP ayarı yoksa mesaj `.eml` dosyası olarak saklanır.

## Raporların anlamı

Gelir, ilgili ayda `payments.paid_at` üzerinden kaydedilen tahsilattır; rezervasyon
bedeliyle veya ileride alınacak gelirle karıştırılmaz. Doluluk metriğinin kesin
hesabı SQL prosedüründe tanımlıdır; payda oda sayısı × aydaki gün sayısıdır.
Oda stokunun geçmiş değişimleri ayrıca modellenmediği için geçmiş ayların paydası da
mevcut oda envanterini kullanır. Bu ders demosunda tek otel vardır.

## İndeksleme ve test

Oda numarası ve e-posta benzersiz indeksleri, oda/tarih ve durum/tarih indeksleri ile
JOIN yabancı anahtar indeksleri tanımlıdır. [Ölçüm raporu](INDEX_PERFORMANCE.md), aynı
sorgunun 100.000 kayıt üzerinde indeksli/indekssiz gerçek sürelerini ve
`EXPLAIN ANALYZE` çıktısını içerir. [Test sonuçları](TEST_RESULTS.md) doğrulanan
işlemleri, [Postman koleksiyonu](Mavi-Otel.postman_collection.json) API isteklerini sunar.

## Gereksinim kontrolü

| PDF gereksinimi | Teslim bileşeni |
| --- | --- |
| En az 13 temel tablo, 3NF, ER | `schema.sql`, ER_DIAGRAM.md |
| En az 20 oda / 50 misafir / 200 rezervasyon | `seed.sql`, veri sayısı testi |
| Çakışma, oda durumu, işlem günlüğü tetikleyicileri | `schema.sql`, doğrudan SQL ve yarış testi |
| En az 3 stored procedure ve 2 view | `schema.sql`, repository, API testleri |
| Atomik check-out ve rollback | `services.py`, ödeme hatası entegrasyon testi |
| İndeksli/indekssiz süre karşılaştırması | benchmark_indexes.py, INDEX_PERFORMANCE.md |
| REST CRUD, katmanlar, JWT, üç rol | Flask uygulaması ve yetkilendirme testleri |
| Üç role ait ekranlar | templates/index.html, static/app.js, static/style.css |
| API koleksiyonu, test ve rapor | docs/API.md, Postman koleksiyonu, TEST_RESULTS.md, tests/ |
| Kısa video ve YouTube | DEMO.md çekim akışı; bağlantı README'de |
| GitHub deposu | README, `.gitignore`, GitHub Actions test iş akışı |
| Ek puan: e-posta bildirimi | `notifications.py`, onay sonrası gönderim, e-posta testi |
| Ek puan: raporların grafikle gösterimi | Yönetici rapor ekranındaki aylık doluluk/gelir grafikleri |

## Kaynaklar

- [MySQL 8.4 Stored Programs](https://dev.mysql.com/doc/refman/8.4/en/stored-objects.html)
- [MySQL CREATE TRIGGER](https://dev.mysql.com/doc/refman/8.4/en/create-trigger.html)
- [MySQL CREATE PROCEDURE](https://dev.mysql.com/doc/refman/8.4/en/create-procedure.html)
- [Flask Application Factories](https://flask.palletsprojects.com/en/stable/patterns/appfactories/)
- [Flask Testing](https://flask.palletsprojects.com/en/stable/testing/)

Ödev yönergesi: Veritabanı Yönetim Sistemleri dersi, Otel Rezervasyon ve Konaklama Yönetim Sistemi proje dokümanı (2026-2027).
