# ER diyagramı ve normalizasyon

Tablo adları kodda İngilizce, kullanıcı arayüzünde Türkçedir. GitHub bu Mermaid
diyagramını doğrudan görüntüler.

```mermaid
erDiagram
    ROOM_TYPES ||--o{ ROOMS : siniflandirir
    ROOM_TYPES ||--o{ SEASONAL_PRICES : fiyatlandirir
    GUESTS ||--o| USERS : hesabi
    STAFF ||--o| USERS : hesabi
    GUESTS ||--o{ RESERVATIONS : yapar
    ROOMS ||--o{ RESERVATIONS : ayrilir
    RESERVATIONS ||--|{ RESERVATION_NIGHTS : fiyat_anlik_goruntusu
    RESERVATIONS ||--o{ ROOM_CALENDAR : geceyi_kilitler
    ROOMS ||--o{ ROOM_CALENDAR : takvim
    RESERVATIONS ||--o| STAYS : konaklama
    STAFF ||--o{ STAYS : giris_cikis_yapar
    STAYS ||--o{ STAY_SERVICES : alir
    SERVICES ||--o{ STAY_SERVICES : hizmet
    STAYS ||--o{ PAYMENTS : tahsilat
    ROOMS ||--o{ CLEANING_RECORDS : temizlenir
    STAFF ||--o{ CLEANING_RECORDS : tamamlar
    ROOM_TYPES {
        int id PK
        string name UK
        int capacity
        decimal base_price
        text description
    }
    ROOMS {
        int id PK
        string number UK
        int floor
        int room_type_id FK
        enum status
    }
    SEASONAL_PRICES {
        int id PK
        int room_type_id FK
        date start_date
        date end_date
        decimal nightly_price
    }
    GUESTS {
        int id PK
        string first_name
        string last_name
        string identity_no UK
        string phone
        string email UK
        date birth_date
    }
    USERS {
        int id PK
        string email UK
        string password_hash
        enum role
        int guest_id FK
        int staff_id FK
    }
    STAFF {
        int id PK
        string first_name
        string last_name
        enum position
        date hire_date
    }
    RESERVATIONS {
        int id PK
        int guest_id FK
        int room_id FK
        date check_in
        date check_out
        int guest_count
        enum status
        datetime created_at
    }
    RESERVATION_NIGHTS {
        int id PK
        int reservation_id FK
        date night_date
        decimal nightly_price
    }
    ROOM_CALENDAR {
        int room_id PK,FK
        date night_date PK
        int reservation_id FK
    }
    STAYS {
        int id PK
        int reservation_id FK,UK
        datetime checked_in_at
        datetime checked_out_at
        int check_in_staff_id FK
        int check_out_staff_id FK
    }
    SERVICES {
        int id PK
        string name UK
        decimal unit_price
    }
    STAY_SERVICES {
        int id PK
        int stay_id FK
        int service_id FK
        int quantity
        decimal unit_price
        datetime used_at
    }
    PAYMENTS {
        int id PK
        int stay_id FK
        decimal amount
        enum method
        datetime paid_at
    }
    CLEANING_RECORDS {
        int id PK
        int room_id FK
        int staff_id FK
        datetime cleaned_at
        enum status
    }
    AUDIT_LOGS {
        int id PK
        string table_name
        int record_id
        string operation
        json old_data
        json new_data
        datetime created_at
    }
```

`audit_logs` silinen kayıtları da koruduğu için kaynak tablolara silinmeye bağlı
yabancı anahtar içermez; tablo adı ve kayıt numarası ile değişiklik geçmişini saklar.

## 3NF gerekçesi

1. **1NF:** Alanlar atomiktir; bir hücrede oda listesi veya hizmet listesi tutulmaz.
   Rezervasyonun geceleri ve konaklama hizmetleri ayrı satırlardır.
2. **2NF:** Kimlik tabanlı tablolardaki alanlar kayıt anahtarına bağlıdır. Oda takvimi
   bileşik `(room_id, night_date)` anahtarına sahiptir; rezervasyon bu oda/gece çiftini
   rezerve eden kaydı gösterir.
3. **3NF:** Oda tipi adı/kapasitesi `rooms` içinde tekrarlanmaz; personel adı
   `stays` içinde, hizmet adı `stay_services` içinde, misafir adı `reservations`
   içinde tekrarlanmaz. İlişkiler yabancı anahtarlarla kurulur.

`reservation_nights.nightly_price` rezervasyon yapıldığı andaki **sözleşilen gece
fiyatıdır**; güncel sezon listesinin kopyası anlamında kullanılmaz. Benzer biçimde
`stay_services.unit_price` hizmet verildiği andaki bedeldir. Sonradan fiyat listesi
değiştiğinde geçmiş hesapların değişmemesi için bunlar ayrı tarihsel olgulardır.
Hesap toplamları view/prosedür sorgularıyla üretilir; rezervasyona tekrar yazılmaz.

Oda durumu operasyonel bir durum bilgisidir. Check-in/check-out ve temizlik
tetikleyicileri bu durumu transaction içinde günceller. `room_calendar`, benzersiz
gece anahtarıyla yarış durumunu önleyen, tetikleyiciler tarafından yönetilen teknik
bir tablodur; uygulama bu tabloya doğrudan yazmaz.

## Ödevdeki adlarla eşleme

| Ödev tablosu | Uygulama tablosu |
| --- | --- |
| OdaTipi | room_types |
| Oda | rooms |
| SezonFiyati | seasonal_prices |
| Misafir | guests |
| Kullanici | users |
| Personel | staff |
| Rezervasyon | reservations |
| Konaklama | stays |
| EkHizmet | services |
| KonaklamaHizmeti | stay_services |
| Odeme | payments |
| TemizlikKaydi | cleaning_records |
| IslemLog | audit_logs |
