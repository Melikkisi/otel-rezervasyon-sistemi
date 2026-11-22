# Mavi Otel · Rezervasyon ve Konaklama Yönetimi

Veritabanı Yönetim Sistemleri dersi için **Flask + MySQL 8.4** ile geliştirilmiş,
Türkçe arayüzlü otel otomasyonu. Misafir, resepsiyon ve yönetici rollerini kapsar.

## Hızlı başlangıç

### Docker ile

Docker Desktop / Docker Engine ve Compose kurulu olmalıdır.

```bash
cp .env.example .env
# .env içindeki JWT_SECRET değerini rastgele, en az 32 karakterlik bir değerle değiştirin.
docker compose up --build
```

Uygulama: **http://localhost:5000**. İlk açılışta MySQL şeması ve örnek veriler
otomatik yüklenir. Veriler `mysql_data` biriminde saklanır. Normal durdurma:
`docker compose down`. Verileri korumak için `-v` kullanmayın.

> Bu çalışma klasöründe yerel kurulum için bir `.env` zaten varsa Docker'a geçerken
> değerleri `.env.example` ile karşılaştırın: `DB_USER=otel` olmalı; DB_PASSWORD ve
> MYSQL_ROOT_PASSWORD dolu olmalıdır. `.env` GitHub'a dahil edilmez.

### Python ve yerel MySQL ile

Python 3.12+ ve MySQL 8.4 gerekir. Proje için ayrı veritabanı kullanın.

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
```

MySQL'de proje kullanıcısını oluşturun (parolayı `.env` ile eşleştirin):

```sql
CREATE DATABASE mavi_otel CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
CREATE USER 'otel'@'localhost' IDENTIFIED BY 'local-otel-password';
GRANT ALL PRIVILEGES ON mavi_otel.* TO 'otel'@'localhost';
```

```bash
python scripts/init_db.py
python run.py
```

`init_db.py` yalnızca boş veritabanına kurulum yapar; mevcut tabloları silmez.
Windows'ta aktivasyon komutu `.venv\Scripts\activate` olur.

### Bu bilgisayardaki hazır yerel demo

Proje klasöründe kurulan `.venv` ve ayrı `.local/mysql` veritabanını yeniden başlatmak için:

```bash
.venv/bin/python scripts/local_demo.py
```

Bu yardımcı MySQL'i yalnızca proje klasöründeki soket üzerinden başlatır; diğer
veritabanlarına müdahale etmez. Ctrl+C web sunucusunu kapatır; MySQL arka planda kalır.
Projeye ait MySQL'i kapatmak için `mysqladmin --socket="$PWD/.local/mysql.sock" -u root shutdown`.

## Demo hesapları

Tüm demo hesaplarının parolası **`Otel2026!`**. Yalnızca yerel ders demosu içindir.

| Rol | E-posta | İşlemler |
| --- | --- | --- |
| Yönetici | `admin@otel.test` | Tüm işlemler, tanımlar, personel, raporlar, işlem günlüğü |
| Resepsiyon | `resepsiyon@otel.test` | Günlük akış, giriş/çıkış, ek hizmet, ödeme, temizlik |
| Misafir | `misafir@otel.test` | Oda ara, rezervasyon yap/iptal et, kendi konaklamalarını gör |
| Resepsiyon (2) | `resepsiyon2@otel.test` | İkinci resepsiyon görevlisi |
| Misafir (2) | `mehmet.kaya@ornek.test` | Yetki testleri için ikinci misafir |

Örnek veri (`database/seed.sql`): 4 oda tipi, 24 oda (biri bakımda), 52 misafir,
8 personel, 8 ek hizmet, üç yıllık yaz/yılbaşı sezon fiyatları ve yaklaşık 5 ay
geçmiş + 2 ay ileriye uzanan 850'den fazla rezervasyon (tamamlanmış konaklamalar,
ek hizmetler, ödemeler, temizlik kayıtları, iptal ve bekleyen kayıtlar dahil).
Tüm kayıtlar tetikleyicilerden geçerek eklenir; işlem günlüğü de bu sırada dolar.

Örnek veriler ilk kurulum gününe göre üretilir. Günlük akışta gerçek tarih kullanılır;
birkaç gün sonra günlük örnek kayıtların değişmesi normaldir. Tüm kimlik ve iletişim
verileri kurgusaldır, `.test` alan adları kullanılır.

## Temel özellikler

- Gece bazında sezon fiyatı; rezervasyon ve hizmet bedellerinin geçmiş fiyatını koruyan kayıtlar.
- Veritabanı tetikleyicileri ve benzersiz oda/gece anahtarı ile eşzamanlı çifte rezervasyon koruması.
- Check-in sonrası `dolu`, check-out sonrası `temizlikte`; temizlik tamamlanınca `boş` oda.
- Çıkış, ödeme, rezervasyon ve oda güncellemesinin tek transaction içinde tamamlanması.
- Gerçek `CALL` ile çalışan boş oda, hesap ve aylık doluluk/gelir prosedürleri.
- JWT kimlik doğrulama, rol ve kayıt sahipliği kontrolü, hash'lenmiş parolalar.
- Oda, oda tipi, sezon fiyatı, hizmet ve personel CRUD ekranları; grafikle raporlama.
- Rezervasyon onaylandığında misafire e-posta bildirimi (ek puan maddesi).

## E-posta bildirimi

Misafir rezervasyon yaptığında veya resepsiyon bekleyen bir rezervasyonu onayladığında
misafirin kayıtlı adresine onay e-postası gönderilir (oda, tarihler, gece sayısı, tutar).
E-posta, veritabanı işlemi COMMIT edildikten sonra gönderilir; gönderim hatası
rezervasyonu iptal etmez, yalnızca günlüğe yazılır.

- `.env` içinde `SMTP_HOST` boşsa e-postalar `.local/mail/` klasörüne `.eml` dosyası olarak
  kaydedilir. Bu dosyalar Mail/Outlook ile açılabilir; sunumda göstermek için idealdir.
- Gerçek gönderim için SMTP bilgilerini girin. Örneğin Gmail için `SMTP_HOST=smtp.gmail.com`,
  `SMTP_PORT=587`, `SMTP_USER` ve uygulama şifresi (`SMTP_PASSWORD`).
- Arayüz, e-postanın hangi adrese gönderildiğini bildirim olarak gösterir.

## Proje düzeni

```text
app/
  entities.py         Domain modelleri ve veri doğrulama
  repositories.py     Parametreli SQL, prosedür ve view erişimi
  services.py         İş kuralları ve transaction sınırları
  controllers.py      REST API uç noktaları ve yetkilendirme
  notifications.py    Rezervasyon onay e-postası
  db.py               Bağlantı yaşam döngüsü
  templates/          Uygulama sayfası
  static/             Türkçe arayüz, CSS ve JavaScript
database/
  schema.sql          Tablolar, indeksler, tetikleyiciler, prosedürler, view'lar
  seed.sql            Örnek veri ve demo kullanıcıları
docs/                 Rapor, ER diyagramı, Postman, test ve sunum kılavuzu
scripts/              Kurulum, yerel demo ve indeks ölçümü
tests/                Gerçek MySQL entegrasyon testleri
```

## Test ve ölçüm

```bash
python -m pytest -q
python scripts/benchmark_indexes.py
```

Testler rastgele isimli `mavi_test_*` veritabanını oluşturup sonunda siler;
ana demo veritabanını değiştirmez. Test bağlantısı için CREATE/DROP DATABASE yetkisi
gereklidir. Bu yetkiyi sadece yerel test hesabına verin. Test kullanıcıları ve bilgiler
`.env` üzerinden okunur. Ayrı test hesabı kullanmak için ortam değişkenlerini değiştirin.

Ölçüm, 100.000 kayıt içeren geçici tablo kullanır ve
[gerçek indeks karşılaştırma raporunu](docs/INDEX_PERFORMANCE.md) yeniden üretir.

## Teslim belgeleri

- [Proje raporu ve gereksinim eşlemesi](docs/REPORT.md)
- [ER diyagramı ve 3NF açıklaması](docs/ER_DIAGRAM.md)
- [Test senaryoları ve doğrulama sonuçları](docs/TEST_RESULTS.md)
- [REST API özeti ve tablo eşlemesi](docs/API.md)
- [Postman koleksiyonu](docs/Mavi-Otel.postman_collection.json)
- [Sunum ve video çekim akışı](docs/DEMO.md)

## GitHub'a yükleme

GitHub'da boş bir depo oluşturduktan sonra aşağıdaki komutlar yeterlidir. `.env`, `.local`
ve `.venv` `.gitignore` ile dışarıda bırakılır.

```bash
git init -b main
git add .
git status
git commit -m "Otel rezervasyon ve konaklama yönetim sistemi"
git remote add origin https://github.com/KULLANICI/DEPO.git
git push -u origin main
```

## Ekip ve sunum

| Ad Soyad | Öğrenci no |
| --- | --- |
| | |
| | |

Tanıtım videosu: _YouTube bağlantısı eklenecek_

## Kapsam

Ödeme, kasada nakit/kart tahsilatının **kaydıdır**; bir banka veya kart tahsilat
entegrasyonu değildir.
