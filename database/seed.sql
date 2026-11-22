-- Mavi Otel örnek verileri
-- schema.sql dosyasından sonra, aynı boş veritabanında çalıştırılır.
-- Tarihler kurulum gününe göre hesaplanır; böylece günlük giriş/çıkış listesi dolu gelir.
-- Tüm kişiler ve iletişim bilgileri kurgusaldır. Demo hesaplarının parolası: Otel2026!
SET NAMES utf8mb4;
SET time_zone = '+03:00';

INSERT INTO room_types (name, capacity, description, base_price) VALUES
 ('Standart', 2, 'Şehir manzaralı, çift veya iki ayrı yataklı standart oda.', 1800.00),
 ('Deluxe', 3, 'Geniş oturma alanı ve balkonlu deluxe oda.', 2800.00),
 ('Aile', 4, 'Ara kapılı iki bölümlü, aileler için geniş oda.', 3600.00),
 ('Suit', 4, 'Ayrı salonlu, deniz manzaralı suit.', 5200.00);

-- Sezonlar: yaz (1 Haziran - 1 Eylül) ve yılbaşı (20 Aralık - 3 Ocak). Bitiş tarihi dahil değildir.
INSERT INTO seasonal_prices (room_type_id, start_date, end_date, nightly_price)
SELECT t.id, s.start_date, s.end_date, ROUND(t.base_price * s.factor, -1)
FROM room_types t
CROSS JOIN (
  SELECT MAKEDATE(YEAR(CURRENT_DATE) + (-1), 1) + INTERVAL 5 MONTH AS start_date, MAKEDATE(YEAR(CURRENT_DATE) + (-1), 1) + INTERVAL 8 MONTH AS end_date, 1.35 AS factor
  UNION ALL
  SELECT MAKEDATE(YEAR(CURRENT_DATE) + (-1), 1) + INTERVAL 11 MONTH + INTERVAL 19 DAY, MAKEDATE(YEAR(CURRENT_DATE) + (-1) + 1, 1) + INTERVAL 2 DAY, 1.25
  UNION ALL
  SELECT MAKEDATE(YEAR(CURRENT_DATE) + (0), 1) + INTERVAL 5 MONTH AS start_date, MAKEDATE(YEAR(CURRENT_DATE) + (0), 1) + INTERVAL 8 MONTH AS end_date, 1.35 AS factor
  UNION ALL
  SELECT MAKEDATE(YEAR(CURRENT_DATE) + (0), 1) + INTERVAL 11 MONTH + INTERVAL 19 DAY, MAKEDATE(YEAR(CURRENT_DATE) + (0) + 1, 1) + INTERVAL 2 DAY, 1.25
  UNION ALL
  SELECT MAKEDATE(YEAR(CURRENT_DATE) + (1), 1) + INTERVAL 5 MONTH AS start_date, MAKEDATE(YEAR(CURRENT_DATE) + (1), 1) + INTERVAL 8 MONTH AS end_date, 1.35 AS factor
  UNION ALL
  SELECT MAKEDATE(YEAR(CURRENT_DATE) + (1), 1) + INTERVAL 11 MONTH + INTERVAL 19 DAY, MAKEDATE(YEAR(CURRENT_DATE) + (1) + 1, 1) + INTERVAL 2 DAY, 1.25
) s
ORDER BY t.id, s.start_date;

INSERT INTO rooms (number, floor, room_type_id, status) VALUES
 ('101', 1, 1, 'available'),
 ('102', 1, 1, 'available'),
 ('103', 1, 1, 'available'),
 ('104', 1, 2, 'available'),
 ('105', 1, 2, 'available'),
 ('106', 1, 3, 'available'),
 ('201', 2, 1, 'available'),
 ('202', 2, 1, 'available'),
 ('203', 2, 1, 'available'),
 ('204', 2, 2, 'available'),
 ('205', 2, 2, 'available'),
 ('206', 2, 3, 'available'),
 ('301', 3, 1, 'available'),
 ('302', 3, 1, 'available'),
 ('303', 3, 1, 'available'),
 ('304', 3, 2, 'available'),
 ('305', 3, 2, 'available'),
 ('306', 3, 3, 'available'),
 ('401', 4, 1, 'available'),
 ('402', 4, 1, 'available'),
 ('403', 4, 1, 'available'),
 ('404', 4, 2, 'available'),
 ('405', 4, 4, 'available'),
 ('406', 4, 4, 'available');

INSERT INTO services (name, unit_price) VALUES
 ('Açık büfe kahvaltı', 350.00),
 ('Akşam yemeği', 650.00),
 ('Spa ve masaj', 1200.00),
 ('Otopark (günlük)', 200.00),
 ('Oda servisi', 450.00),
 ('Çamaşırhane', 300.00),
 ('Havalimanı transferi', 900.00),
 ('Minibar', 250.00);

INSERT INTO staff (first_name, last_name, position, hire_date) VALUES
 ('Elif', 'Aydın', 'admin', '2019-03-01'),
 ('Mert', 'Kaya', 'reception', '2021-06-15'),
 ('Zeynep', 'Şahin', 'reception', '2022-09-01'),
 ('Can', 'Öztürk', 'reception', '2023-04-10'),
 ('Hatice', 'Demir', 'housekeeping', '2018-05-20'),
 ('Ali', 'Çelik', 'housekeeping', '2020-11-02'),
 ('Selin', 'Arslan', 'housekeeping', '2024-02-12'),
 ('Burak', 'Koç', 'admin', '2017-08-01');

INSERT INTO guests (first_name, last_name, identity_no, phone, email, birth_date) VALUES
 ('Ayşe', 'Yılmaz', '90000000011', '0555 100 10 10', 'misafir@otel.test', '1960-01-01'),
 ('Mehmet', 'Kaya', '90000000148', '0555 101 47 63', 'mehmet.kaya@ornek.test', '1967-06-12'),
 ('Fatma', 'Demir', '90000000285', '0555 102 84 26', 'fatma.demir@ornek.test', '1974-11-23'),
 ('Mustafa', 'Şahin', '90000000422', '0555 103 31 79', 'mustafa.sahin@ornek.test', '1981-04-06'),
 ('Emine', 'Çelik', '90000000559', '0555 104 68 42', 'emine.celik@ornek.test', '1988-09-17'),
 ('Ahmet', 'Yıldız', '90000000696', '0555 105 15 95', 'ahmet.yildiz@ornek.test', '1995-02-28'),
 ('Hülya', 'Yıldırım', '90000000833', '0555 106 52 58', 'hulya.yildirim@ornek.test', '1960-07-11'),
 ('Hüseyin', 'Öztürk', '90000000970', '0555 107 89 21', 'huseyin.ozturk@ornek.test', '1967-12-22'),
 ('Zehra', 'Aydın', '90000001107', '0555 108 36 74', 'zehra.aydin@ornek.test', '1974-05-05'),
 ('İbrahim', 'Özdemir', '90000001244', '0555 109 73 37', 'ibrahim.ozdemir@ornek.test', '1981-10-16'),
 ('Merve', 'Arslan', '90000001381', '0555 110 20 90', 'merve.arslan@ornek.test', '1988-03-27'),
 ('Emre', 'Doğan', '90000001518', '0555 111 57 53', 'emre.dogan@ornek.test', '1995-08-10'),
 ('Esra', 'Kılıç', '90000001655', '0555 112 94 16', 'esra.kilic@ornek.test', '1960-01-21'),
 ('Burcu', 'Aslan', '90000001792', '0555 113 41 69', 'burcu.aslan@ornek.test', '1967-06-04'),
 ('Kerem', 'Çetin', '90000001929', '0555 114 78 32', 'kerem.cetin@ornek.test', '1974-11-15'),
 ('Deniz', 'Kara', '90000002066', '0555 115 25 85', 'deniz.kara@ornek.test', '1981-04-26'),
 ('Gizem', 'Koç', '90000002203', '0555 116 62 48', 'gizem.koc@ornek.test', '1988-09-09'),
 ('Onur', 'Kurt', '90000002340', '0555 117 99 11', 'onur.kurt@ornek.test', '1995-02-20'),
 ('Ece', 'Özkan', '90000002477', '0555 118 46 64', 'ece.ozkan@ornek.test', '1960-07-03'),
 ('Barış', 'Şimşek', '90000002614', '0555 119 83 27', 'baris.simsek@ornek.test', '1967-12-14'),
 ('Sena', 'Polat', '90000002751', '0555 120 30 80', 'sena.polat@ornek.test', '1974-05-25'),
 ('Oğuz', 'Erdoğan', '90000002888', '0555 121 67 43', 'oguz.erdogan@ornek.test', '1981-10-08'),
 ('Derya', 'Güneş', '90000003025', '0555 122 14 96', 'derya.gunes@ornek.test', '1988-03-19'),
 ('Serkan', 'Aksoy', '90000003162', '0555 123 51 59', 'serkan.aksoy@ornek.test', '1995-08-02'),
 ('Tuğba', 'Bulut', '90000003299', '0555 124 88 22', 'tugba.bulut@ornek.test', '1960-01-13'),
 ('Volkan', 'Keskin', '90000003436', '0555 125 35 75', 'volkan.keskin@ornek.test', '1967-06-24'),
 ('Pınar', 'Ünal', '90000003573', '0555 126 72 38', 'pinar.unal@ornek.test', '1974-11-07'),
 ('Kaan', 'Turan', '90000003710', '0555 127 19 91', 'kaan.turan@ornek.test', '1981-04-18'),
 ('Nazlı', 'Güler', '90000003847', '0555 128 56 54', 'nazli.guler@ornek.test', '1988-09-01'),
 ('Umut', 'Tekin', '90000003984', '0555 129 93 17', 'umut.tekin@ornek.test', '1995-02-12'),
 ('Sibel', 'Avcı', '90000004121', '0555 130 40 70', 'sibel.avci@ornek.test', '1960-07-23'),
 ('Tolga', 'Sarı', '90000004258', '0555 131 77 33', 'tolga.sari@ornek.test', '1967-12-06'),
 ('İrem', 'Taş', '90000004395', '0555 132 24 86', 'irem.tas@ornek.test', '1974-05-17'),
 ('Cem', 'Bozkurt', '90000004532', '0555 133 61 49', 'cem.bozkurt@ornek.test', '1981-10-28'),
 ('Yasemin', 'Işık', '90000004669', '0555 134 98 12', 'yasemin.isik@ornek.test', '1988-03-11'),
 ('Berk', 'Karaca', '90000004806', '0555 135 45 65', 'berk.karaca@ornek.test', '1995-08-22'),
 ('Aslı', 'Uçar', '90000004943', '0555 136 82 28', 'asli.ucar@ornek.test', '1960-01-05'),
 ('Gökhan', 'Duman', '90000005080', '0555 137 29 81', 'gokhan.duman@ornek.test', '1967-06-16'),
 ('Melis', 'Erdem', '90000005217', '0555 138 66 44', 'melis.erdem@ornek.test', '1974-11-27'),
 ('Hakan', 'Acar', '90000005354', '0555 139 13 97', 'hakan.acar@ornek.test', '1981-04-10'),
 ('Didem', 'Korkmaz', '90000005491', '0555 140 50 60', 'didem.korkmaz@ornek.test', '1988-09-21'),
 ('Arda', 'Yavuz', '90000005628', '0555 141 87 23', 'arda.yavuz@ornek.test', '1995-02-04'),
 ('Ebru', 'Altun', '90000005765', '0555 142 34 76', 'ebru.altun@ornek.test', '1960-07-15'),
 ('Furkan', 'Kaplan', '90000005902', '0555 143 71 39', 'furkan.kaplan@ornek.test', '1967-12-26'),
 ('Seda', 'Toprak', '90000006039', '0555 144 18 92', 'seda.toprak@ornek.test', '1974-05-09'),
 ('Yusuf', 'Ateş', '90000006176', '0555 145 55 55', 'yusuf.ates@ornek.test', '1981-10-20'),
 ('Buse', 'Coşkun', '90000006313', '0555 146 92 18', 'buse.coskun@ornek.test', '1988-03-03'),
 ('Ozan', 'Önal', '90000006450', '0555 147 39 71', 'ozan.onal@ornek.test', '1995-08-14'),
 ('Dilara', 'Bilgin', '90000006587', '0555 148 76 34', 'dilara.bilgin@ornek.test', '1960-01-25'),
 ('Eren', 'Uysal', '90000006724', '0555 149 23 87', 'eren.uysal@ornek.test', '1967-06-08'),
 ('Anna', 'Schmidt', 'P48213920', '0555 150 60 50', 'anna.schmidt@ornek.test', '1974-11-19'),
 ('Lukas', 'Weber', 'P48213927', '0555 151 97 13', 'lukas.weber@ornek.test', '1981-04-02');

INSERT INTO users (email, password_hash, role, guest_id, staff_id) VALUES
 ('admin@otel.test', 'pbkdf2:sha256:600000$Kp4vR9tXw2LmQz7B$588d40d5f08b6028f18baa549da3407cf466055f6646683930ee6c2452495a3c', 'admin', NULL, 1),
 ('resepsiyon@otel.test', 'pbkdf2:sha256:600000$Kp4vR9tXw2LmQz7B$588d40d5f08b6028f18baa549da3407cf466055f6646683930ee6c2452495a3c', 'reception', NULL, 2),
 ('resepsiyon2@otel.test', 'pbkdf2:sha256:600000$Kp4vR9tXw2LmQz7B$588d40d5f08b6028f18baa549da3407cf466055f6646683930ee6c2452495a3c', 'reception', NULL, 3),
 ('misafir@otel.test', 'pbkdf2:sha256:600000$Kp4vR9tXw2LmQz7B$588d40d5f08b6028f18baa549da3407cf466055f6646683930ee6c2452495a3c', 'guest', 1, NULL),
 ('mehmet.kaya@ornek.test', 'pbkdf2:sha256:600000$Kp4vR9tXw2LmQz7B$588d40d5f08b6028f18baa549da3407cf466055f6646683930ee6c2452495a3c', 'guest', 2, NULL);

-- Rezervasyon geçmişi. Her kayıt veritabanı tetikleyicilerinden geçer:
-- gece fiyatları, takvim, oda durumları ve işlem günlüğü otomatik oluşur.
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (46, 1, DATE_ADD(CURRENT_DATE, INTERVAL -147 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -151 DAY),'12:36:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -147 DAY), '17:23:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), '18:11:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), '11:01:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (1, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), '14:19:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (1, 1, DATE_ADD(CURRENT_DATE, INTERVAL -141 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -147 DAY),'22:10:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -141 DAY), '14:44:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -141 DAY), '17:54:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), '11:05:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (1, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), '13:33:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (40, 1, DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -133 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -165 DAY),'08:05:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), '17:11:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), '21:59:00')),
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY), '17:15:00')),
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), '21:30:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -133 DAY), '11:26:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (1, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -133 DAY), '15:10:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (5, 1, DATE_ADD(CURRENT_DATE, INTERVAL -133 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -170 DAY),'21:28:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -133 DAY), '18:03:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -132 DAY), '12:28:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -132 DAY), '17:38:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), '11:20:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (1, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), '13:48:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (37, 1, DATE_ADD(CURRENT_DATE, INTERVAL -126 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -123 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -132 DAY),'08:54:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -126 DAY), '16:18:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -124 DAY), '08:11:00')),
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -124 DAY), '09:51:00')),
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY), '20:33:00')),
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY), '22:00:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -123 DAY), '10:06:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (1, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -123 DAY), '12:36:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (26, 1, DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -118 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -132 DAY),'11:28:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY), '14:59:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -118 DAY), '11:54:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (1, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -118 DAY), '15:24:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (2, 1, DATE_ADD(CURRENT_DATE, INTERVAL -118 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -163 DAY),'19:57:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -118 DAY), '19:48:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY), '21:31:00')),
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -118 DAY), '17:47:00')),
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -113 DAY), '15:23:00')),
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), '13:49:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), '11:24:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (1, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), '13:53:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (29, 1, DATE_ADD(CURRENT_DATE, INTERVAL -110 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY),'15:03:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -110 DAY), '16:10:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY), '18:40:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), '10:31:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (1, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), '15:39:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (25, 1, DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY),'18:52:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (9, 1, DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -89 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY),'21:12:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), '19:04:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), '15:30:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -89 DAY), '10:49:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (1, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -89 DAY), '15:54:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (34, 1, DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -107 DAY),'21:22:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (10, 1, DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -75 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -112 DAY),'14:23:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), '14:40:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), '13:36:00')),
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), '15:16:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -75 DAY), '10:28:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (1, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -75 DAY), '13:58:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (39, 1, DATE_ADD(CURRENT_DATE, INTERVAL -74 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -83 DAY),'13:23:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -74 DAY), '19:28:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '19:22:00')),
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '14:38:00')),
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -74 DAY), '09:25:00')),
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -74 DAY), '13:22:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '10:33:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (1, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '13:23:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (52, 1, DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -92 DAY),'08:40:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), '18:35:00'), 3);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), '11:32:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (1, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), '13:15:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (2, 1, DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -58 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY),'12:09:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), '16:58:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -59 DAY), '15:58:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -58 DAY), '10:55:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (1, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -58 DAY), '12:24:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (10, 1, DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -52 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY),'11:31:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), '16:28:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '19:45:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -52 DAY), '11:06:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (1, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -52 DAY), '12:48:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (50, 1, DATE_ADD(CURRENT_DATE, INTERVAL -52 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY),'21:43:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -52 DAY), '17:16:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -52 DAY), '16:24:00')),
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY), '10:01:00')),
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY), '09:20:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), '10:18:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (1, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), '15:02:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (25, 1, DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -43 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY),'15:25:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), '18:43:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), '15:39:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -43 DAY), '10:18:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (1, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -43 DAY), '15:49:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (46, 1, DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY),'13:26:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), '15:14:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -41 DAY), '17:56:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '10:30:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (1, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '15:03:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (24, 1, DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY),'10:16:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), '19:20:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -37 DAY), '11:56:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -36 DAY), '13:28:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), '11:29:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (1, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), '13:35:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (39, 1, DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY),'17:15:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY), '15:16:00'), 3);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), '11:54:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (1, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), '15:29:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (7, 1, DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY),'18:42:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), '15:24:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), '08:54:00')),
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), '08:31:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), '10:56:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (1, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), '12:20:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (9, 1, DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -16 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -22 DAY),'08:53:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (2, 1, DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY),'13:12:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), '17:54:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), '08:03:00')),
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), '16:17:00')),
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), '12:24:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), '10:06:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (1, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), '13:52:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (32, 1, DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 2 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY),'12:50:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY), '14:44:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (48, 1, DATE_ADD(CURRENT_DATE, INTERVAL 8 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 12 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'20:22:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (49, 1, DATE_ADD(CURRENT_DATE, INTERVAL 12 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 18 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY),'13:39:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (38, 1, DATE_ADD(CURRENT_DATE, INTERVAL 22 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 27 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY),'12:51:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (10, 1, DATE_ADD(CURRENT_DATE, INTERVAL 28 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 32 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'18:07:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (39, 1, DATE_ADD(CURRENT_DATE, INTERVAL 38 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 42 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'15:06:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (43, 1, DATE_ADD(CURRENT_DATE, INTERVAL 42 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 46 DAY), 1, 'pending', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'14:04:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (32, 1, DATE_ADD(CURRENT_DATE, INTERVAL 49 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 51 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'11:48:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (24, 1, DATE_ADD(CURRENT_DATE, INTERVAL 55 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 58 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'19:23:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (15, 2, DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -151 DAY),'12:09:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), '16:37:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY), '10:32:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), '11:26:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (2, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), '13:36:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (46, 2, DATE_ADD(CURRENT_DATE, INTERVAL -141 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -135 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -161 DAY),'17:20:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -141 DAY), '20:00:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), '22:22:00')),
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), '09:51:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -135 DAY), '11:47:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (2, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -135 DAY), '14:03:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (42, 2, DATE_ADD(CURRENT_DATE, INTERVAL -135 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -149 DAY),'11:06:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -135 DAY), '15:16:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -135 DAY), '21:25:00')),
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -133 DAY), '15:36:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), '10:30:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (2, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), '14:02:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (42, 2, DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -128 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -157 DAY),'21:22:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), '20:51:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), '11:34:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -128 DAY), '11:15:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (2, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -128 DAY), '13:37:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (30, 2, DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -118 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY),'13:15:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY), '20:43:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -120 DAY), '13:40:00')),
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -120 DAY), '08:14:00')),
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY), '20:17:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -118 DAY), '11:05:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (2, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -118 DAY), '12:53:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (38, 2, DATE_ADD(CURRENT_DATE, INTERVAL -112 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY),'12:00:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -112 DAY), '20:05:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), '16:25:00')),
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), '20:29:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '10:26:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (2, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '12:06:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (1, 2, DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY),'13:43:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), '17:26:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), '11:20:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (2, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), '15:43:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (35, 2, DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -103 DAY),'19:54:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (44, 2, DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -92 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY),'20:22:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY), '20:37:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY), '09:11:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -92 DAY), '10:16:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (2, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -92 DAY), '12:32:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (9, 2, DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -94 DAY),'17:32:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (37, 2, DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -103 DAY),'11:28:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY), '18:11:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY), '14:26:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), '15:55:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), '10:12:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (2, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), '13:19:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (11, 2, DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY),'20:32:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY), '18:10:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), '11:46:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (2, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), '14:04:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (10, 2, DATE_ADD(CURRENT_DATE, INTERVAL -74 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY),'14:14:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -74 DAY), '18:24:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '10:30:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '11:59:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (2, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '12:26:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (12, 2, DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY),'20:05:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY), '16:45:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), '11:19:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (2, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), '15:42:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (25, 2, DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY),'19:36:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), '14:03:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), '20:53:00')),
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -64 DAY), '19:42:00')),
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -64 DAY), '09:25:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), '11:26:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (2, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), '13:02:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (48, 2, DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY),'10:09:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY), '20:11:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), '13:53:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), '12:18:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -58 DAY), '08:25:00')),
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY), '13:09:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '10:46:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (2, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '13:03:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (45, 2, DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -59 DAY),'22:23:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '16:40:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -52 DAY), '19:58:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), '10:04:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (2, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), '13:06:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (39, 2, DATE_ADD(CURRENT_DATE, INTERVAL -41 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -37 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY),'22:41:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -41 DAY), '19:00:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -41 DAY), '11:59:00')),
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), '09:24:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -37 DAY), '11:27:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (2, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -37 DAY), '12:23:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (6, 2, DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY),'22:21:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), '18:29:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), '22:56:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -33 DAY), '15:06:00')),
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY), '09:28:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), '11:10:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (2, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), '15:10:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (3, 2, DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY),'14:12:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), '20:20:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), '10:16:00')),
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY), '17:17:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), '11:50:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (2, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), '12:58:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (7, 2, DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY),'16:38:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), '18:57:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), '09:42:00')),
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), '16:44:00')),
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), '11:53:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), '21:11:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), '11:28:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (2, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), '13:13:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (47, 2, DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -36 DAY),'13:35:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), '15:40:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -25 DAY), '10:26:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -25 DAY), '11:34:00')),
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), '13:34:00')),
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), '14:54:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), '11:43:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (2, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), '14:51:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (48, 2, DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY),'19:38:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (31, 2, DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY),'16:01:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), '15:48:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), '10:24:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (2, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), '14:58:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (10, 2, DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -22 DAY),'10:52:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), '20:56:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY), '12:53:00')),
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY), '19:31:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), '10:06:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (2, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), '15:23:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (36, 2, DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY),'21:04:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), '14:36:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), '18:58:00')),
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY), '08:17:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), '11:08:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (2, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), '15:12:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (19, 2, CURRENT_DATE, DATE_ADD(CURRENT_DATE, INTERVAL 1 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY),'08:47:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (10, 2, DATE_ADD(CURRENT_DATE, INTERVAL 1 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 5 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -41 DAY),'20:34:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (52, 2, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 9 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'11:44:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (31, 2, DATE_ADD(CURRENT_DATE, INTERVAL 9 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 10 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY),'10:40:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (3, 2, DATE_ADD(CURRENT_DATE, INTERVAL 10 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 12 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY),'18:42:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (6, 2, DATE_ADD(CURRENT_DATE, INTERVAL 13 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 19 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY),'21:07:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (2, 2, DATE_ADD(CURRENT_DATE, INTERVAL 25 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 31 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'22:03:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (34, 2, DATE_ADD(CURRENT_DATE, INTERVAL 31 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 38 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY),'20:29:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (34, 2, DATE_ADD(CURRENT_DATE, INTERVAL 38 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 43 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'19:54:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (11, 2, DATE_ADD(CURRENT_DATE, INTERVAL 44 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 47 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'20:58:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (5, 2, DATE_ADD(CURRENT_DATE, INTERVAL 47 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 51 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'13:08:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (41, 2, DATE_ADD(CURRENT_DATE, INTERVAL 52 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 55 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'21:54:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (25, 2, DATE_ADD(CURRENT_DATE, INTERVAL 55 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 60 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'10:28:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (17, 3, DATE_ADD(CURRENT_DATE, INTERVAL -149 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -172 DAY),'19:11:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -149 DAY), '18:44:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), '22:49:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), '13:06:00')),
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -147 DAY), '20:49:00')),
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -147 DAY), '16:45:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY), '10:45:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (3, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY), '15:22:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (32, 3, DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -189 DAY),'19:50:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), '17:34:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), '20:33:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), '11:04:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (3, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), '12:59:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (27, 3, DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -132 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -178 DAY),'12:46:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), '19:30:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -132 DAY), '11:52:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (3, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -132 DAY), '12:00:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (49, 3, DATE_ADD(CURRENT_DATE, INTERVAL -132 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -128 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY),'17:28:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -132 DAY), '17:38:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), '08:23:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -128 DAY), '10:20:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (3, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -128 DAY), '14:09:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (34, 3, DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -149 DAY),'18:47:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY), '15:57:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), '16:36:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY), '11:08:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (3, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY), '15:27:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (26, 3, DATE_ADD(CURRENT_DATE, INTERVAL -117 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -129 DAY),'22:34:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -117 DAY), '18:43:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), '15:01:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY), '11:37:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (3, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY), '12:39:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (51, 3, DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY),'10:43:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), '14:01:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), '12:32:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -104 DAY), '19:39:00')),
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '16:40:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), '12:28:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), '10:03:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (3, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), '15:34:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (24, 3, DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY),'19:46:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (26, 3, DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY),'19:18:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), '16:18:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -89 DAY), '15:01:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), '10:44:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (3, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), '12:01:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (18, 3, DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY),'09:36:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), '19:03:00'), 3);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY), '10:26:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (3, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY), '14:30:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (6, 3, DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -89 DAY),'14:51:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY), '20:06:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY), '11:59:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), '18:03:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY), '11:12:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (3, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY), '15:51:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (4, 3, DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -70 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -76 DAY),'16:58:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (51, 3, DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -104 DAY),'11:25:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), '16:02:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -67 DAY), '22:57:00')),
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), '10:02:00')),
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), '08:18:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), '10:33:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (3, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), '12:49:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (15, 3, DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY),'09:34:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), '15:40:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), '11:21:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (3, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), '15:05:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (1, 3, DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY),'12:20:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '14:36:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '15:43:00')),
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -53 DAY), '22:40:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '11:29:00')),
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '09:59:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY), '10:47:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (3, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY), '13:51:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (38, 3, DATE_ADD(CURRENT_DATE, INTERVAL -45 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -40 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -76 DAY),'11:26:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -45 DAY), '15:21:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -40 DAY), '11:29:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (3, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -40 DAY), '15:48:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (16, 3, DATE_ADD(CURRENT_DATE, INTERVAL -34 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY),'17:14:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -34 DAY), '16:13:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -34 DAY), '10:14:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY), '11:58:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (3, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY), '13:56:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (46, 3, DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -25 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY),'21:55:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), '19:51:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), '13:36:00')),
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY), '22:15:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -25 DAY), '10:21:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (3, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -25 DAY), '12:22:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (1, 3, DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY),'13:38:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), '16:39:00'), 3);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY), '10:43:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (3, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY), '14:24:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (33, 3, DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -16 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY),'15:34:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY), '16:54:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY), '16:30:00')),
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), '08:50:00')),
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), '18:58:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -16 DAY), '11:26:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (3, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -16 DAY), '13:04:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (1, 3, DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY),'12:17:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), '16:17:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), '10:40:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (3, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), '13:04:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (34, 3, DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -22 DAY),'20:41:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), '19:27:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), '19:05:00')),
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), '19:53:00')),
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), '19:58:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY), '11:29:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (3, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY), '12:22:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (42, 3, DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY), CURRENT_DATE, 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -12 DAY),'15:53:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY), '14:02:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY), '20:55:00')),
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY), '16:15:00'));
UPDATE stays SET checked_out_at = LEAST(TIMESTAMP(CURRENT_DATE, '11:17:00'), NOW()), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (10, 3, DATE_ADD(CURRENT_DATE, INTERVAL 2 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 5 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY),'13:15:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (47, 3, DATE_ADD(CURRENT_DATE, INTERVAL 5 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 8 DAY), 1, 'pending', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -37 DAY),'20:33:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (21, 3, DATE_ADD(CURRENT_DATE, INTERVAL 10 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 11 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -22 DAY),'12:46:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (24, 3, DATE_ADD(CURRENT_DATE, INTERVAL 12 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 13 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'19:44:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (47, 3, DATE_ADD(CURRENT_DATE, INTERVAL 19 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 22 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'21:36:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (39, 3, DATE_ADD(CURRENT_DATE, INTERVAL 24 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 25 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY),'22:44:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (6, 3, DATE_ADD(CURRENT_DATE, INTERVAL 25 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 29 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'14:23:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (17, 3, DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 37 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'11:21:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (22, 3, DATE_ADD(CURRENT_DATE, INTERVAL 39 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 43 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'22:47:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (25, 3, DATE_ADD(CURRENT_DATE, INTERVAL 45 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 50 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'10:55:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (6, 3, DATE_ADD(CURRENT_DATE, INTERVAL 51 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 52 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'17:14:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (6, 3, DATE_ADD(CURRENT_DATE, INTERVAL 55 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 57 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'19:51:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (4, 4, DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -141 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -170 DAY),'12:45:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), '17:38:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY), '21:05:00')),
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), '21:08:00')),
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), '08:30:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -141 DAY), '11:00:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (4, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -141 DAY), '12:29:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (10, 4, DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -170 DAY),'16:52:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), '15:10:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), '14:19:00')),
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY), '10:26:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), '11:44:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (4, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), '15:03:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (49, 4, DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -129 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY),'21:50:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), '20:20:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -129 DAY), '11:54:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (4, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -129 DAY), '15:20:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (32, 4, DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY),'14:59:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY), '20:37:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY), '11:24:00')),
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY), '09:13:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -124 DAY), '11:06:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY), '12:41:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), '11:50:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (4, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), '12:22:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (1, 4, DATE_ADD(CURRENT_DATE, INTERVAL -118 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY),'22:03:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -118 DAY), '19:56:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -117 DAY), '18:11:00')),
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -117 DAY), '18:51:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -117 DAY), '22:51:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), '10:03:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (4, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), '15:00:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (30, 4, DATE_ADD(CURRENT_DATE, INTERVAL -113 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -151 DAY),'16:38:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -113 DAY), '17:22:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '22:01:00')),
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -107 DAY), '15:13:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY), '10:56:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (4, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY), '14:19:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (9, 4, DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY),'19:31:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), '15:16:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), '18:51:00')),
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -103 DAY), '09:41:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), '10:37:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (4, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), '15:48:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (41, 4, DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY),'14:42:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY), '14:14:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -94 DAY), '21:57:00')),
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -94 DAY), '13:30:00')),
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -94 DAY), '12:17:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY), '17:22:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), '11:04:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (4, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), '15:53:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (1, 4, DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -117 DAY),'09:32:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), '20:58:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -92 DAY), '16:54:00')),
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), '12:49:00')),
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), '08:39:00')),
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -92 DAY), '11:09:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '10:46:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (4, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '14:26:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (45, 4, DATE_ADD(CURRENT_DATE, INTERVAL -89 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -86 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY),'08:05:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -89 DAY), '18:14:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -87 DAY), '21:39:00')),
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -87 DAY), '08:20:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -86 DAY), '11:11:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (4, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -86 DAY), '14:31:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (37, 4, DATE_ADD(CURRENT_DATE, INTERVAL -83 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY),'20:29:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -83 DAY), '18:02:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -83 DAY), '19:41:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY), '21:48:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), '10:03:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (4, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), '14:15:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (30, 4, DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), 3, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY),'15:22:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (36, 4, DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -67 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY),'11:05:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), '16:24:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), '11:29:00')),
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), '18:24:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -67 DAY), '11:30:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (4, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -67 DAY), '15:19:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (3, 4, DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -92 DAY),'14:53:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), '14:39:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), '10:31:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (4, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), '15:23:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (44, 4, DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -58 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY),'15:31:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), '15:42:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -59 DAY), '20:45:00')),
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), '13:14:00')),
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -59 DAY), '18:19:00')),
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -59 DAY), '13:58:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -58 DAY), '11:00:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (4, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -58 DAY), '15:15:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (1, 4, DATE_ADD(CURRENT_DATE, INTERVAL -58 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -75 DAY),'15:36:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (8, 4, DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY),'15:42:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), '16:46:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), '15:25:00')),
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), '22:37:00')),
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), '13:44:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), '20:02:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), '11:31:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (4, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), '13:48:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (26, 4, DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY),'12:57:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), '20:49:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), '10:33:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (4, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), '15:31:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (41, 4, DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -44 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -75 DAY),'22:22:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), '14:51:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), '18:57:00')),
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -45 DAY), '09:27:00')),
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -45 DAY), '08:17:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -44 DAY), '11:05:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (4, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -44 DAY), '15:50:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (23, 4, DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -37 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -52 DAY),'20:48:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), '15:11:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '20:04:00')),
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -41 DAY), '12:53:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -37 DAY), '11:08:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (4, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -37 DAY), '12:31:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (16, 4, DATE_ADD(CURRENT_DATE, INTERVAL -36 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY),'12:02:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -36 DAY), '16:37:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -34 DAY), '21:46:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY), '11:33:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (4, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY), '14:15:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (49, 4, DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY),'13:24:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY), '17:43:00'), 3);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), '11:40:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (4, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), '13:51:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (52, 4, DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY),'12:24:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), '17:20:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY), '11:30:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), '11:29:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (4, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), '13:19:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (32, 4, DATE_ADD(CURRENT_DATE, INTERVAL -12 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY),'17:19:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -12 DAY), '17:03:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -12 DAY), '09:08:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), '10:21:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (4, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), '15:37:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (19, 4, DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY),'10:57:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), '15:43:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), '21:43:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), '11:15:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (4, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), '13:41:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (19, 4, DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 2 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY),'19:42:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY), '17:19:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY), '09:14:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY), '09:51:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY), '12:52:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (51, 4, DATE_ADD(CURRENT_DATE, INTERVAL 5 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 8 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -34 DAY),'22:10:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (4, 4, DATE_ADD(CURRENT_DATE, INTERVAL 9 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 11 DAY), 1, 'pending', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY),'12:18:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (33, 4, DATE_ADD(CURRENT_DATE, INTERVAL 17 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 20 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY),'22:45:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (18, 4, DATE_ADD(CURRENT_DATE, INTERVAL 24 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'11:19:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (48, 4, DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 33 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'14:52:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (42, 4, DATE_ADD(CURRENT_DATE, INTERVAL 33 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 35 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'22:31:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (40, 4, DATE_ADD(CURRENT_DATE, INTERVAL 39 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 41 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY),'22:47:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (35, 4, DATE_ADD(CURRENT_DATE, INTERVAL 41 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 45 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'17:33:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (10, 4, DATE_ADD(CURRENT_DATE, INTERVAL 45 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 46 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'11:17:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (17, 4, DATE_ADD(CURRENT_DATE, INTERVAL 50 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 51 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'15:07:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (40, 4, DATE_ADD(CURRENT_DATE, INTERVAL 51 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 55 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'18:24:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (48, 5, DATE_ADD(CURRENT_DATE, INTERVAL -147 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -175 DAY),'22:15:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -147 DAY), '14:13:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), '09:22:00')),
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), '22:56:00')),
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), '13:18:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), '10:14:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (5, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), '12:17:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (35, 5, DATE_ADD(CURRENT_DATE, INTERVAL -141 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -174 DAY),'17:03:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -141 DAY), '16:43:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), '12:03:00')),
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -141 DAY), '19:23:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -141 DAY), '16:19:00')),
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), '22:04:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), '10:24:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (5, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), '15:51:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (48, 5, DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -135 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -172 DAY),'09:37:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), '14:58:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), '08:35:00')),
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), '10:48:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -135 DAY), '11:38:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (5, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -135 DAY), '15:09:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (8, 5, DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -151 DAY),'15:14:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY), '19:38:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -133 DAY), '22:48:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), '11:08:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (5, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), '12:10:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (40, 5, DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -164 DAY),'20:26:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), '16:11:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -120 DAY), '22:54:00')),
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -120 DAY), '20:04:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -120 DAY), '20:27:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY), '10:27:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (5, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY), '15:49:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (17, 5, DATE_ADD(CURRENT_DATE, INTERVAL -113 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -133 DAY),'16:08:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -113 DAY), '18:59:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -112 DAY), '11:57:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), '11:31:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (5, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), '14:55:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (28, 5, DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -141 DAY),'15:12:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), '19:06:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), '19:12:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), '16:23:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY), '10:20:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (5, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY), '15:49:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (48, 5, DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -123 DAY),'10:17:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), '17:01:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), '09:32:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -103 DAY), '12:09:00')),
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -103 DAY), '14:28:00')),
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -104 DAY), '17:26:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), '10:31:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (5, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), '15:12:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (13, 5, DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY),'14:09:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), '19:19:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), '09:30:00')),
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), '16:12:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), '10:47:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (5, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), '14:46:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (39, 5, DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY),'15:16:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), '20:06:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), '14:23:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY), '11:52:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (5, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY), '13:34:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (2, 5, DATE_ADD(CURRENT_DATE, INTERVAL -94 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -132 DAY),'21:18:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -94 DAY), '18:59:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), '21:03:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), '11:29:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (5, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), '12:53:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (48, 5, DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -86 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY),'11:42:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '19:08:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), '19:58:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -87 DAY), '19:21:00')),
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '12:48:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -86 DAY), '10:17:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (5, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -86 DAY), '14:21:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (34, 5, DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -83 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY),'08:48:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), '14:09:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), '18:49:00')),
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), '14:58:00')),
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), '21:15:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -83 DAY), '10:28:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (5, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -83 DAY), '15:54:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (31, 5, DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY),'15:29:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), '19:51:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), '14:26:00')),
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), '11:44:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY), '10:16:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (5, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY), '14:04:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (49, 5, DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -74 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY),'09:00:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), '20:52:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), '21:48:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -74 DAY), '10:04:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (5, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -74 DAY), '14:45:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (50, 5, DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY),'16:33:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '14:44:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '19:05:00')),
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '22:42:00')),
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '17:54:00')),
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '15:10:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY), '11:49:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (5, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY), '15:24:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (28, 5, DATE_ADD(CURRENT_DATE, INTERVAL -70 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -86 DAY),'09:14:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -70 DAY), '19:52:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -70 DAY), '12:57:00')),
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), '21:51:00')),
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -70 DAY), '20:06:00')),
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -67 DAY), '14:33:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), '11:03:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (5, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), '13:01:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (28, 5, DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY),'09:58:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), '15:06:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), '13:51:00')),
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), '18:32:00')),
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), '20:33:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), '11:20:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (5, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), '13:59:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (44, 5, DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -53 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY),'19:48:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (9, 5, DATE_ADD(CURRENT_DATE, INTERVAL -53 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -59 DAY),'22:28:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -53 DAY), '18:09:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -53 DAY), '16:40:00')),
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), '08:02:00')),
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY), '19:28:00')),
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), '09:30:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), '10:27:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (5, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), '13:52:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (46, 5, DATE_ADD(CURRENT_DATE, INTERVAL -44 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY),'19:24:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -44 DAY), '15:52:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -44 DAY), '16:23:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), '11:14:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (5, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), '12:34:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (35, 5, DATE_ADD(CURRENT_DATE, INTERVAL -37 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -34 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY),'17:39:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -37 DAY), '19:47:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -37 DAY), '18:22:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -34 DAY), '10:18:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (5, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -34 DAY), '15:49:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (21, 5, DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -40 DAY),'21:59:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), '15:51:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), '20:57:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY), '20:08:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), '11:22:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (5, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), '14:50:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (51, 5, DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -40 DAY),'08:31:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), '16:50:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY), '15:31:00')),
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY), '22:15:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), '11:57:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (5, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), '12:52:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (13, 5, DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY),'13:26:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), '14:39:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), '10:17:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (5, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), '12:17:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (24, 5, DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), 3, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY),'09:25:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (29, 5, DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY),'12:58:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY), '19:28:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY), '21:05:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY), '16:11:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), '10:48:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (5, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), '15:57:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (12, 5, CURRENT_DATE, DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -12 DAY),'10:19:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (36, 5, DATE_ADD(CURRENT_DATE, INTERVAL 6 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 9 DAY), 3, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY),'13:57:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (22, 5, DATE_ADD(CURRENT_DATE, INTERVAL 11 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 14 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY),'11:58:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (44, 5, DATE_ADD(CURRENT_DATE, INTERVAL 15 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 18 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY),'14:34:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (19, 5, DATE_ADD(CURRENT_DATE, INTERVAL 18 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 20 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY),'12:12:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (45, 5, DATE_ADD(CURRENT_DATE, INTERVAL 23 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 24 DAY), 2, 'pending', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY),'18:15:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (46, 5, DATE_ADD(CURRENT_DATE, INTERVAL 28 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 32 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY),'11:49:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (50, 5, DATE_ADD(CURRENT_DATE, INTERVAL 36 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 40 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'21:00:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (14, 5, DATE_ADD(CURRENT_DATE, INTERVAL 41 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 44 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'18:13:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (38, 5, DATE_ADD(CURRENT_DATE, INTERVAL 47 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 50 DAY), 3, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'10:34:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (3, 5, DATE_ADD(CURRENT_DATE, INTERVAL 50 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 51 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'09:37:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (22, 5, DATE_ADD(CURRENT_DATE, INTERVAL 55 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 59 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'14:14:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (49, 6, DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -158 DAY),'21:35:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), '15:33:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY), '08:44:00')),
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), '11:38:00')),
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), '11:21:00')),
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), '08:39:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), '10:32:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (6, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), '15:08:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (29, 6, DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -168 DAY),'17:52:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), '17:35:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), '19:31:00')),
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), '09:59:00')),
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), '15:23:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), '11:35:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (6, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), '12:33:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (11, 6, DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -123 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -159 DAY),'22:34:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), '14:31:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), '16:40:00')),
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), '10:46:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -123 DAY), '10:06:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (6, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -123 DAY), '15:35:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (42, 6, DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY),'10:23:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), '15:34:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY), '11:48:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (6, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY), '15:49:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (6, 6, DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -149 DAY),'14:14:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), '19:08:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -110 DAY), '11:34:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), '10:13:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (6, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), '14:07:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (44, 6, DATE_ADD(CURRENT_DATE, INTERVAL -104 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY),'19:13:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -104 DAY), '20:59:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -104 DAY), '13:09:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), '11:44:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (6, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), '15:03:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (22, 6, DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY),'16:17:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), '19:24:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -100 DAY), '14:00:00')),
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), '17:19:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY), '10:43:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (6, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY), '12:03:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (36, 6, DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -114 DAY),'21:38:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), '18:37:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '13:47:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), '11:37:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (6, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), '12:02:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (21, 6, DATE_ADD(CURRENT_DATE, INTERVAL -86 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -94 DAY),'08:33:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -86 DAY), '18:11:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -86 DAY), '16:59:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), '11:00:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (6, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), '12:18:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (22, 6, DATE_ADD(CURRENT_DATE, INTERVAL -83 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY),'08:39:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -83 DAY), '17:25:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY), '14:30:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), '11:02:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (6, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), '13:52:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (3, 6, DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY),'11:12:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY), '15:37:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY), '09:08:00')),
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY), '09:53:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY), '10:33:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (6, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY), '15:19:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (47, 6, DATE_ADD(CURRENT_DATE, INTERVAL -74 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY),'20:04:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -74 DAY), '18:35:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), '10:07:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (6, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), '13:31:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (26, 6, DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -64 DAY), 3, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY),'20:21:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (16, 6, DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY),'14:29:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), '16:42:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY), '22:50:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), '11:18:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (6, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), '13:36:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (52, 6, DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY),'08:49:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), '17:17:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), '10:32:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), '11:31:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (6, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), '13:58:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (33, 6, DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY),'20:32:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY), '18:38:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY), '11:44:00')),
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), '20:19:00')),
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), '19:20:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), '14:50:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), '11:55:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (6, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), '15:06:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (22, 6, DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -45 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -83 DAY),'14:52:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), '14:42:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), '09:01:00')),
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), '10:36:00')),
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), '11:43:00')),
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), '20:00:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -45 DAY), '10:53:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (6, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -45 DAY), '15:12:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (45, 6, DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY),'17:02:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (40, 6, DATE_ADD(CURRENT_DATE, INTERVAL -37 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY),'10:31:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -37 DAY), '15:07:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -33 DAY), '14:29:00')),
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY), '09:50:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY), '11:24:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (6, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY), '15:36:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (52, 6, DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY),'08:06:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY), '14:05:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY), '13:29:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), '10:12:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (6, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), '14:25:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (7, 6, DATE_ADD(CURRENT_DATE, INTERVAL -22 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -53 DAY),'13:49:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -22 DAY), '19:20:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), '12:49:00')),
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), '08:55:00')),
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), '09:52:00')),
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -22 DAY), '10:02:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), '10:08:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (6, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), '13:02:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (44, 6, DATE_ADD(CURRENT_DATE, INTERVAL -12 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY),'21:36:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -12 DAY), '18:12:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), '15:53:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), '17:01:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY), '11:25:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (6, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY), '13:34:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (46, 6, DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY),'09:10:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY), '20:04:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY), '10:14:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY), '16:07:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), '10:45:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (6, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), '12:52:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (38, 6, DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), 4, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -52 DAY),'11:27:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (22, 6, DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 1 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY),'09:20:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY), '20:17:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY), '12:17:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (38, 6, DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 8 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY),'10:51:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (45, 6, DATE_ADD(CURRENT_DATE, INTERVAL 10 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 15 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY),'17:59:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (32, 6, DATE_ADD(CURRENT_DATE, INTERVAL 21 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 26 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'10:35:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (24, 6, DATE_ADD(CURRENT_DATE, INTERVAL 27 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 32 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'17:47:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (1, 6, DATE_ADD(CURRENT_DATE, INTERVAL 33 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 37 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'19:53:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (13, 6, DATE_ADD(CURRENT_DATE, INTERVAL 41 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 46 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'18:39:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (51, 6, DATE_ADD(CURRENT_DATE, INTERVAL 49 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 52 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'12:25:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (4, 6, DATE_ADD(CURRENT_DATE, INTERVAL 55 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 56 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'11:48:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (6, 6, DATE_ADD(CURRENT_DATE, INTERVAL 56 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 59 DAY), 4, 'pending', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'08:17:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (30, 7, DATE_ADD(CURRENT_DATE, INTERVAL -150 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -148 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -172 DAY),'10:28:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -150 DAY), '18:58:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -150 DAY), '20:03:00')),
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -150 DAY), '15:17:00')),
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -149 DAY), '12:27:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -148 DAY), '11:53:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (7, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -148 DAY), '13:41:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (13, 7, DATE_ADD(CURRENT_DATE, INTERVAL -148 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -163 DAY),'18:07:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (15, 7, DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -155 DAY),'09:14:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY), '17:53:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), '20:07:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), '11:57:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (7, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), '12:20:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (4, 7, DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -182 DAY),'08:39:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), '19:17:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), '10:50:00')),
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), '11:40:00')),
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), '17:23:00')),
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), '22:41:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), '10:17:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (7, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), '15:47:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (28, 7, DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY),'18:48:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), '14:39:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -129 DAY), '08:09:00')),
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -129 DAY), '19:10:00')),
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -128 DAY), '16:13:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), '10:13:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (7, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), '12:17:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (46, 7, DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY),'13:11:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), '17:34:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -120 DAY), '12:27:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -120 DAY), '15:00:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -120 DAY), '10:29:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY), '10:58:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (7, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY), '14:05:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (46, 7, DATE_ADD(CURRENT_DATE, INTERVAL -113 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -126 DAY),'17:55:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -113 DAY), '16:08:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -112 DAY), '09:02:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '11:24:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (7, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '12:34:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (11, 7, DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY),'09:17:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), '18:56:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), '11:31:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (7, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), '13:42:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (31, 7, DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY),'20:46:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), '16:31:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), '17:55:00')),
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY), '22:02:00')),
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), '08:03:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), '10:38:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY), '10:08:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (7, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY), '14:34:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (3, 7, DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -100 DAY),'09:36:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY), '15:45:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), '09:55:00')),
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), '17:07:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '11:46:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (7, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '15:19:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (45, 7, DATE_ADD(CURRENT_DATE, INTERVAL -87 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -129 DAY),'15:30:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -87 DAY), '20:55:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -86 DAY), '14:38:00')),
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -87 DAY), '13:21:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), '11:19:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (7, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), '12:07:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (19, 7, DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY),'17:07:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY), '18:10:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), '16:07:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), '11:10:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (7, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), '13:16:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (20, 7, DATE_ADD(CURRENT_DATE, INTERVAL -75 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -107 DAY),'12:52:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -75 DAY), '17:00:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '14:22:00')),
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -74 DAY), '14:55:00')),
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '19:21:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '10:49:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (7, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '13:49:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (50, 7, DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY),'10:42:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), '18:41:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), '11:45:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (7, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), '15:10:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (49, 7, DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -67 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -83 DAY),'17:40:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), '17:30:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), '17:28:00')),
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), '22:35:00')),
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), '21:06:00')),
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), '20:24:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -67 DAY), '11:17:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (7, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -67 DAY), '12:32:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (37, 7, DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -58 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY),'16:26:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), '15:49:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -58 DAY), '11:53:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (7, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -58 DAY), '12:16:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (43, 7, DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY),'13:37:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), '17:25:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), '10:59:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), '10:45:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (7, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), '12:33:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (11, 7, DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY),'20:47:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (33, 7, DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -43 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY),'11:31:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), '16:28:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -45 DAY), '21:30:00')),
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), '20:17:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -45 DAY), '12:55:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -43 DAY), '10:00:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (7, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -43 DAY), '12:35:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (8, 7, DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -36 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY),'14:40:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '15:15:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '13:51:00')),
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -37 DAY), '14:22:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -36 DAY), '10:17:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (7, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -36 DAY), '12:18:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (14, 7, DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -67 DAY),'13:07:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY), '18:47:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY), '10:25:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), '11:21:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (7, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), '15:23:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (28, 7, DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -36 DAY),'21:18:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), '15:38:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), '11:53:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (7, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), '13:08:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (41, 7, DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -13 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -40 DAY),'21:33:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), '19:15:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), '16:16:00')),
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), '08:13:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -13 DAY), '11:53:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (7, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -13 DAY), '13:43:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (14, 7, DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY),'17:35:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), '16:51:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), '09:34:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY), '11:54:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (7, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY), '14:11:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (24, 7, DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 4 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY),'10:07:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), '18:14:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), '20:46:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (13, 7, DATE_ADD(CURRENT_DATE, INTERVAL 5 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 10 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY),'12:35:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (8, 7, DATE_ADD(CURRENT_DATE, INTERVAL 14 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 17 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'22:03:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (17, 7, DATE_ADD(CURRENT_DATE, INTERVAL 21 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 25 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'10:20:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (48, 7, DATE_ADD(CURRENT_DATE, INTERVAL 28 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 31 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'19:41:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (11, 7, DATE_ADD(CURRENT_DATE, INTERVAL 34 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 39 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'13:50:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (1, 7, DATE_ADD(CURRENT_DATE, INTERVAL 45 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 47 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'14:04:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (31, 7, DATE_ADD(CURRENT_DATE, INTERVAL 47 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 49 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'10:18:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (7, 7, DATE_ADD(CURRENT_DATE, INTERVAL 51 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 53 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'10:23:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (47, 7, DATE_ADD(CURRENT_DATE, INTERVAL 55 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 59 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'10:22:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (38, 8, DATE_ADD(CURRENT_DATE, INTERVAL -147 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -151 DAY),'16:50:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -147 DAY), '17:15:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY), '17:31:00')),
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), '15:10:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), '10:58:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), '12:56:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (21, 8, DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -164 DAY),'22:59:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), '14:18:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), '10:16:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), '12:10:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (8, 8, DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -151 DAY),'17:31:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (38, 8, DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -172 DAY),'21:56:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), '16:32:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), '15:13:00')),
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -135 DAY), '10:28:00')),
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), '22:07:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY), '11:37:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY), '13:34:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (43, 8, DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -163 DAY),'17:22:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), '16:50:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), '10:27:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), '12:02:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (7, 8, DATE_ADD(CURRENT_DATE, INTERVAL -126 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -156 DAY),'09:42:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -126 DAY), '17:51:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -123 DAY), '17:02:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY), '17:33:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY), '11:54:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY), '13:02:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (46, 8, DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -118 DAY),'19:03:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY), '14:44:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), '10:00:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), '15:12:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (23, 8, DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -149 DAY),'21:02:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '18:24:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '19:43:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '15:08:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY), '11:41:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY), '12:56:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (51, 8, DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -100 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY),'12:11:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), '16:21:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), '17:15:00')),
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), '21:31:00')),
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), '20:11:00')),
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), '11:28:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -100 DAY), '11:49:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -100 DAY), '13:07:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (39, 8, DATE_ADD(CURRENT_DATE, INTERVAL -94 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -100 DAY),'11:10:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -94 DAY), '17:26:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), '08:04:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -92 DAY), '19:38:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), '11:40:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), '14:19:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (39, 8, DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -86 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -133 DAY),'11:56:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '17:33:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -89 DAY), '08:54:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -86 DAY), '10:47:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -86 DAY), '14:37:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (24, 8, DATE_ADD(CURRENT_DATE, INTERVAL -86 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY),'08:27:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -86 DAY), '19:55:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -86 DAY), '16:50:00')),
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), '16:07:00')),
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), '13:09:00')),
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), '22:06:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), '11:48:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), '12:51:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (51, 8, DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -75 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY),'13:35:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY), '17:38:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY), '20:19:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -75 DAY), '10:43:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -75 DAY), '14:18:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (42, 8, DATE_ADD(CURRENT_DATE, INTERVAL -75 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -92 DAY),'21:56:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -75 DAY), '15:38:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -75 DAY), '12:51:00')),
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -74 DAY), '21:04:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '14:33:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY), '11:49:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY), '12:41:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (38, 8, DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -113 DAY),'19:21:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (38, 8, DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -104 DAY),'21:50:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), '16:53:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), '11:56:00')),
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -59 DAY), '19:44:00')),
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), '20:16:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), '10:09:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), '12:41:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (49, 8, DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -100 DAY),'09:40:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY), '20:23:00'), 3);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '10:25:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '15:44:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (29, 8, DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -53 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY),'13:21:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '19:10:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '08:47:00')),
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '17:53:00')),
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '18:10:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -53 DAY), '10:51:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -53 DAY), '15:12:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (43, 8, DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -52 DAY),'12:04:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), '20:42:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), '22:03:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), '12:25:00')),
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), '22:22:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), '10:10:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), '15:36:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (46, 8, DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -59 DAY),'08:28:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), '19:00:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -40 DAY), '21:20:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '10:03:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '14:33:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (47, 8, DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -45 DAY),'21:19:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), '17:27:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -34 DAY), '18:04:00')),
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -33 DAY), '09:24:00')),
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -34 DAY), '15:22:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY), '10:26:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY), '14:19:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (31, 8, DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY),'09:57:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), '18:29:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), '22:10:00')),
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), '19:58:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), '10:05:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), '15:44:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (16, 8, DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY),'08:57:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), '17:21:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), '13:25:00')),
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), '15:29:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), '10:57:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), '14:03:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (19, 8, DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -33 DAY),'20:21:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), '16:44:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), '09:17:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), '09:55:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), '10:50:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), '14:27:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (5, 8, DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY),'08:10:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), '17:57:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), '11:11:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), '13:57:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (45, 8, DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -53 DAY),'11:18:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), '16:19:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), '11:42:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), '13:08:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (13, 8, DATE_ADD(CURRENT_DATE, INTERVAL -12 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY),'19:23:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -12 DAY), '20:31:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -12 DAY), '21:02:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), '11:30:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), '13:52:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (27, 8, DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY),'17:55:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY), '18:08:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), '11:26:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), '12:53:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (12, 8, DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -33 DAY),'14:32:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), '15:07:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), '18:32:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), '10:42:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), '15:35:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (35, 8, DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY),'18:19:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), '14:26:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), '17:32:00')),
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), '21:57:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY), '10:50:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (8, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY), '14:10:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (17, 8, DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 4 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -45 DAY),'08:34:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY), '14:48:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (40, 8, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 11 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -13 DAY),'12:33:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (51, 8, DATE_ADD(CURRENT_DATE, INTERVAL 13 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 16 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'19:27:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (42, 8, DATE_ADD(CURRENT_DATE, INTERVAL 16 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 20 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY),'16:35:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (47, 8, DATE_ADD(CURRENT_DATE, INTERVAL 26 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 31 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'18:33:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (12, 8, DATE_ADD(CURRENT_DATE, INTERVAL 34 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 36 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'14:36:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (8, 8, DATE_ADD(CURRENT_DATE, INTERVAL 36 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 40 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'22:25:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (22, 8, DATE_ADD(CURRENT_DATE, INTERVAL 46 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 48 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'10:32:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (33, 8, DATE_ADD(CURRENT_DATE, INTERVAL 49 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 52 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'22:16:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (11, 8, DATE_ADD(CURRENT_DATE, INTERVAL 53 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 56 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'11:35:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (49, 9, DATE_ADD(CURRENT_DATE, INTERVAL -149 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -175 DAY),'18:06:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -149 DAY), '14:59:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -149 DAY), '08:04:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -149 DAY), '22:14:00')),
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -149 DAY), '16:19:00')),
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -147 DAY), '09:43:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), '10:52:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (9, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), '15:11:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (13, 9, DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -173 DAY),'21:09:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), '15:40:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), '18:07:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), '11:51:00')),
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), '15:40:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), '10:17:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (9, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), '15:18:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (30, 9, DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -151 DAY),'14:59:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), '20:01:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), '15:23:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), '11:14:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (9, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), '13:45:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (23, 9, DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -126 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -149 DAY),'12:37:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (9, 9, DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -117 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -148 DAY),'19:21:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY), '15:13:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY), '09:58:00')),
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), '14:29:00')),
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY), '20:31:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY), '13:39:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -117 DAY), '10:03:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (9, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -117 DAY), '14:13:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (7, 9, DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -112 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -157 DAY),'11:30:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), '17:06:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY), '11:58:00')),
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), '15:41:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -112 DAY), '11:42:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (9, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -112 DAY), '12:25:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (8, 9, DATE_ADD(CURRENT_DATE, INTERVAL -112 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -129 DAY),'13:32:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -112 DAY), '14:16:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -112 DAY), '14:30:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), '10:37:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (9, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), '12:39:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (41, 9, DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -104 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY),'13:49:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), '20:09:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), '18:07:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -104 DAY), '10:18:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (9, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -104 DAY), '15:35:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (4, 9, DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -113 DAY),'10:40:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), '15:56:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -100 DAY), '08:34:00')),
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -100 DAY), '22:21:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), '10:58:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (9, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), '13:12:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (50, 9, DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY),'15:06:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (3, 9, DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY),'10:04:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (5, 9, DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY),'09:25:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), '17:19:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), '11:39:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), '10:16:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), '10:07:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (9, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), '15:29:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (52, 9, DATE_ADD(CURRENT_DATE, INTERVAL -76 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY),'09:53:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -76 DAY), '19:38:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '15:23:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), '10:27:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (9, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), '12:08:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (37, 9, DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -64 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -89 DAY),'18:16:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), '19:05:00'), 3);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -64 DAY), '10:15:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (9, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -64 DAY), '14:43:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (25, 9, DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -58 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY),'17:36:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (21, 9, DATE_ADD(CURRENT_DATE, INTERVAL -58 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY),'22:39:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -58 DAY), '14:05:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), '20:17:00')),
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), '21:10:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY), '11:41:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (9, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY), '13:16:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (33, 9, DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY),'16:31:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY), '20:16:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), '11:45:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), '10:40:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (9, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), '12:43:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (43, 9, DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -53 DAY),'20:24:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), '17:41:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), '12:20:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), '14:07:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), '11:41:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (9, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), '12:51:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (2, 9, DATE_ADD(CURRENT_DATE, INTERVAL -44 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -41 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY),'10:47:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -44 DAY), '14:59:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -44 DAY), '14:09:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -41 DAY), '10:48:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (9, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -41 DAY), '14:54:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (28, 9, DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY),'14:26:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '14:34:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), '11:31:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (9, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), '12:56:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (25, 9, DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY),'11:43:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (32, 9, DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -70 DAY),'10:11:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), '14:39:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), '21:09:00')),
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -25 DAY), '15:47:00')),
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), '22:58:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), '22:23:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), '11:54:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (9, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), '13:43:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (1, 9, DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -12 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY),'14:46:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), '14:52:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), '21:53:00')),
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -16 DAY), '16:43:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -12 DAY), '11:22:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (9, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -12 DAY), '12:07:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (49, 9, DATE_ADD(CURRENT_DATE, INTERVAL -12 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -41 DAY),'19:12:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -12 DAY), '17:47:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), '10:47:00')),
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), '22:05:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), '11:58:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (9, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), '13:21:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (35, 9, DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -34 DAY),'19:50:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), '17:33:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), '20:17:00')),
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), '20:42:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), '10:16:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (9, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), '15:08:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (17, 9, DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -22 DAY),'17:24:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), '20:07:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY), '08:58:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY), '10:11:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (9, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY), '13:32:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (2, 9, DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 5 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY),'21:43:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY), '20:39:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY), '13:14:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (19, 9, DATE_ADD(CURRENT_DATE, INTERVAL 6 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 9 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY),'11:53:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (46, 9, DATE_ADD(CURRENT_DATE, INTERVAL 10 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 12 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY),'18:04:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (11, 9, DATE_ADD(CURRENT_DATE, INTERVAL 13 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 17 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY),'11:15:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (50, 9, DATE_ADD(CURRENT_DATE, INTERVAL 18 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 23 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY),'10:17:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (8, 9, DATE_ADD(CURRENT_DATE, INTERVAL 23 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 25 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'15:28:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (38, 9, DATE_ADD(CURRENT_DATE, INTERVAL 25 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 28 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'22:57:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (52, 9, DATE_ADD(CURRENT_DATE, INTERVAL 34 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 37 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'12:07:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (25, 9, DATE_ADD(CURRENT_DATE, INTERVAL 39 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 42 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'22:54:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (13, 9, DATE_ADD(CURRENT_DATE, INTERVAL 42 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 43 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'08:17:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (13, 9, DATE_ADD(CURRENT_DATE, INTERVAL 49 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 55 DAY), 1, 'pending', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'19:00:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (3, 10, DATE_ADD(CURRENT_DATE, INTERVAL -148 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -158 DAY),'18:33:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -148 DAY), '19:55:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), '19:19:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -147 DAY), '11:42:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), '10:44:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (10, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), '14:08:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (40, 10, DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -151 DAY),'12:02:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), '15:23:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), '21:24:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), '11:24:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (10, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), '13:07:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (47, 10, DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -132 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -151 DAY),'22:59:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY), '17:09:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -133 DAY), '21:26:00')),
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY), '11:17:00')),
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY), '09:12:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -132 DAY), '11:08:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (10, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -132 DAY), '13:37:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (34, 10, DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -128 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -166 DAY),'08:20:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), '19:01:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), '18:45:00')),
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), '19:29:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -128 DAY), '11:33:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (10, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -128 DAY), '14:43:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (21, 10, DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY),'08:32:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), '18:07:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -126 DAY), '09:15:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY), '10:22:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (10, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY), '13:22:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (22, 10, DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY),'14:47:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY), '16:11:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY), '08:25:00')),
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -118 DAY), '22:33:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), '10:49:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (10, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), '14:19:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (48, 10, DATE_ADD(CURRENT_DATE, INTERVAL -113 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -141 DAY),'17:13:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (45, 10, DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -107 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY),'21:43:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), '14:51:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '13:17:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -107 DAY), '10:35:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (10, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -107 DAY), '12:05:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (44, 10, DATE_ADD(CURRENT_DATE, INTERVAL -107 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -128 DAY),'17:24:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -107 DAY), '15:13:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -107 DAY), '09:01:00')),
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -107 DAY), '13:09:00')),
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -107 DAY), '19:30:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), '10:18:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (10, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), '15:52:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (11, 10, DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY),'12:15:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), '16:16:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -100 DAY), '12:09:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -100 DAY), '20:55:00')),
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), '20:11:00')),
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), '22:07:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), '10:46:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (10, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), '15:36:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (33, 10, DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY),'19:01:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (15, 10, DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY),'18:01:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), '20:56:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -92 DAY), '15:28:00')),
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -92 DAY), '14:03:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), '11:08:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (10, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), '13:18:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (10, 10, DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -87 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -124 DAY),'20:15:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), '14:27:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '20:56:00')),
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), '20:56:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -89 DAY), '22:44:00')),
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), '12:48:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -87 DAY), '11:13:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (10, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -87 DAY), '14:38:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (11, 10, DATE_ADD(CURRENT_DATE, INTERVAL -87 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -120 DAY),'21:01:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (8, 10, DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -103 DAY),'19:46:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), '15:51:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), '20:13:00')),
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), '09:31:00')),
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), '19:41:00')),
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), '20:49:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), '11:58:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (10, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), '15:26:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (27, 10, DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -70 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -107 DAY),'14:32:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), '18:37:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '08:40:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -70 DAY), '11:12:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (10, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -70 DAY), '12:54:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (33, 10, DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY),'18:20:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), '15:51:00'), 3);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), '10:43:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (10, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), '13:00:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (6, 10, DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -58 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY),'22:04:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY), '20:35:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY), '20:40:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -58 DAY), '11:31:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (10, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -58 DAY), '12:02:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (35, 10, DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -53 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY),'19:10:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), '16:47:00'), 3);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -53 DAY), '10:48:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (10, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -53 DAY), '12:55:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (14, 10, DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY),'10:18:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), '15:35:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), '17:06:00')),
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), '09:27:00')),
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), '08:49:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), '17:44:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), '11:59:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (10, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), '15:53:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (5, 10, DATE_ADD(CURRENT_DATE, INTERVAL -40 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -37 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -53 DAY),'16:09:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -40 DAY), '16:17:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), '18:45:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -40 DAY), '16:59:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '16:49:00')),
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), '21:54:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -37 DAY), '10:28:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (10, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -37 DAY), '13:29:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (7, 10, DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -75 DAY),'14:34:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY), '20:28:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY), '11:46:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY), '10:03:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (10, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY), '14:54:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (44, 10, DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -34 DAY),'18:54:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), '15:13:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), '16:12:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), '11:12:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), '11:41:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (10, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), '15:54:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (49, 10, DATE_ADD(CURRENT_DATE, INTERVAL -22 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY),'09:16:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -22 DAY), '15:31:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY), '14:18:00')),
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY), '11:26:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), '11:35:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (10, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), '13:59:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (43, 10, DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -13 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -40 DAY),'18:58:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), '15:22:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), '13:57:00')),
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -16 DAY), '14:56:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -13 DAY), '11:17:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (10, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -13 DAY), '14:18:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (39, 10, DATE_ADD(CURRENT_DATE, INTERVAL -13 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -33 DAY),'17:06:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -13 DAY), '14:01:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -13 DAY), '08:27:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -13 DAY), '17:06:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), '10:41:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (10, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), '12:53:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (30, 10, DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY),'20:43:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), '17:15:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), '08:53:00')),
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY), '13:45:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), '10:59:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (10, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), '14:23:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (22, 10, DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY),'13:02:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), '14:12:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY), '10:17:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (10, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY), '14:52:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (40, 10, CURRENT_DATE, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -45 DAY),'08:55:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (47, 10, DATE_ADD(CURRENT_DATE, INTERVAL 13 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 16 DAY), 3, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'18:26:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (33, 10, DATE_ADD(CURRENT_DATE, INTERVAL 22 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 26 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY),'19:14:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (12, 10, DATE_ADD(CURRENT_DATE, INTERVAL 32 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 39 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'14:56:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (14, 10, DATE_ADD(CURRENT_DATE, INTERVAL 40 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 42 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'16:56:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (46, 10, DATE_ADD(CURRENT_DATE, INTERVAL 48 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 54 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'22:55:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (48, 10, DATE_ADD(CURRENT_DATE, INTERVAL 54 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 56 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'10:40:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (32, 11, DATE_ADD(CURRENT_DATE, INTERVAL -148 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -190 DAY),'08:37:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -148 DAY), '17:33:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), '10:59:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (11, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), '13:21:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (36, 11, DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -161 DAY),'20:49:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), '17:19:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), '09:19:00')),
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), '18:07:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), '15:07:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -141 DAY), '09:15:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), '11:27:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (11, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), '13:34:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (24, 11, DATE_ADD(CURRENT_DATE, INTERVAL -133 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -128 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -151 DAY),'14:39:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -133 DAY), '17:58:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), '22:56:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -128 DAY), '10:40:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (11, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -128 DAY), '13:37:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (36, 11, DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -156 DAY),'19:06:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY), '18:37:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -117 DAY), '19:22:00')),
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY), '16:10:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), '11:19:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (11, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), '12:59:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (51, 11, DATE_ADD(CURRENT_DATE, INTERVAL -110 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -107 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -113 DAY),'09:04:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -110 DAY), '18:06:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '14:10:00')),
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '13:47:00')),
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), '20:40:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -107 DAY), '10:47:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (11, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -107 DAY), '15:11:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (51, 11, DATE_ADD(CURRENT_DATE, INTERVAL -107 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -104 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -110 DAY),'10:53:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -107 DAY), '14:46:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), '13:48:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -104 DAY), '10:08:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (11, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -104 DAY), '12:42:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (26, 11, DATE_ADD(CURRENT_DATE, INTERVAL -100 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), 3, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY),'13:41:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (24, 11, DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY),'08:32:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), '20:14:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), '15:28:00')),
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), '13:11:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY), '10:28:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (11, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY), '13:19:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (37, 11, DATE_ADD(CURRENT_DATE, INTERVAL -89 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY),'09:04:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -89 DAY), '16:41:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -86 DAY), '13:35:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -89 DAY), '18:32:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -86 DAY), '10:52:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), '11:02:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (11, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), '15:40:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (39, 11, DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -128 DAY),'22:45:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (49, 11, DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY),'10:31:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), '17:50:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), '16:31:00')),
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), '13:59:00')),
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), '21:29:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY), '10:32:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (11, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY), '14:28:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (16, 11, DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -118 DAY),'09:35:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY), '18:26:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY), '18:58:00')),
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY), '17:56:00')),
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY), '21:25:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), '10:03:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (11, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), '12:08:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (40, 11, DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -74 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -120 DAY),'10:56:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), '15:07:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -75 DAY), '17:07:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -74 DAY), '10:48:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (11, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -74 DAY), '14:14:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (41, 11, DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -70 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -83 DAY),'14:58:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '17:32:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '11:22:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '16:23:00')),
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '11:45:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '18:09:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -70 DAY), '11:14:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (11, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -70 DAY), '13:17:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (45, 11, DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY),'18:01:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), '19:51:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), '11:12:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (11, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), '12:07:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (19, 11, DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -92 DAY),'08:34:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY), '20:55:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -59 DAY), '19:55:00')),
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -59 DAY), '17:54:00')),
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -59 DAY), '16:29:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), '10:54:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (11, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), '13:22:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (35, 11, DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -67 DAY),'12:37:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), '14:49:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY), '14:20:00')),
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), '17:06:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '10:45:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (11, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '12:56:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (20, 11, DATE_ADD(CURRENT_DATE, INTERVAL -52 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY),'13:40:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -52 DAY), '16:51:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY), '21:18:00')),
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY), '13:45:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), '10:49:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (11, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), '13:20:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (46, 11, DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -94 DAY),'18:53:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), '14:16:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), '10:49:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (11, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), '15:52:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (34, 11, DATE_ADD(CURRENT_DATE, INTERVAL -44 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -67 DAY),'22:45:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -44 DAY), '16:07:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '12:32:00')),
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -40 DAY), '22:34:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '20:50:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), '10:50:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (11, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), '12:37:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (39, 11, DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY),'16:49:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), '19:02:00'), 3);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), '10:49:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (11, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), '13:54:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (22, 11, DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY),'10:31:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), '15:47:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), '10:52:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (11, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), '15:46:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (41, 11, DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -25 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -44 DAY),'20:17:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), '20:54:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), '19:15:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -25 DAY), '10:12:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (11, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -25 DAY), '12:09:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (51, 11, DATE_ADD(CURRENT_DATE, INTERVAL -25 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -64 DAY),'21:43:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -25 DAY), '20:25:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), '21:15:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), '18:19:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), '13:50:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY), '11:29:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (11, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY), '13:07:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (12, 11, DATE_ADD(CURRENT_DATE, INTERVAL -16 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY),'11:15:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -16 DAY), '14:33:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), '16:18:00')),
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), '19:26:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), '11:45:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (11, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), '12:28:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (29, 11, DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY),'16:58:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), '17:15:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), '15:04:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), '11:52:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (11, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), '13:41:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (17, 11, DATE_ADD(CURRENT_DATE, INTERVAL 1 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 4 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -37 DAY),'18:17:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (39, 11, DATE_ADD(CURRENT_DATE, INTERVAL 8 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 10 DAY), 3, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY),'14:58:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (6, 11, DATE_ADD(CURRENT_DATE, INTERVAL 10 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 13 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY),'20:47:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (27, 11, DATE_ADD(CURRENT_DATE, INTERVAL 17 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 19 DAY), 2, 'pending', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'22:12:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (46, 11, DATE_ADD(CURRENT_DATE, INTERVAL 23 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 27 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -12 DAY),'13:10:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (14, 11, DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 36 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY),'15:52:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (25, 11, DATE_ADD(CURRENT_DATE, INTERVAL 36 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 39 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'17:16:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (1, 11, DATE_ADD(CURRENT_DATE, INTERVAL 40 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 42 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'17:23:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (44, 11, DATE_ADD(CURRENT_DATE, INTERVAL 43 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 46 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'13:39:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (19, 11, DATE_ADD(CURRENT_DATE, INTERVAL 50 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 52 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'17:05:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (34, 11, DATE_ADD(CURRENT_DATE, INTERVAL 52 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 56 DAY), 3, 'pending', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'13:04:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (46, 12, DATE_ADD(CURRENT_DATE, INTERVAL -147 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -175 DAY),'12:40:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -147 DAY), '19:46:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -147 DAY), '13:40:00')),
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -147 DAY), '12:27:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY), '11:08:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (12, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY), '13:23:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (43, 12, DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -141 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -186 DAY),'10:01:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), '15:35:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), '19:10:00')),
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), '16:46:00')),
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), '20:37:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -141 DAY), '10:20:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (12, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -141 DAY), '13:57:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (26, 12, DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -169 DAY),'18:32:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), '18:25:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), '11:32:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (12, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), '13:21:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (38, 12, DATE_ADD(CURRENT_DATE, INTERVAL -132 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -129 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -159 DAY),'22:53:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -132 DAY), '20:20:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -132 DAY), '20:55:00')),
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), '08:19:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -129 DAY), '11:14:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (12, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -129 DAY), '13:45:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (11, 12, DATE_ADD(CURRENT_DATE, INTERVAL -126 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -124 DAY), 3, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -157 DAY),'08:49:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (2, 12, DATE_ADD(CURRENT_DATE, INTERVAL -123 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -120 DAY), 4, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY),'12:32:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (44, 12, DATE_ADD(CURRENT_DATE, INTERVAL -114 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY),'14:22:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -114 DAY), '16:41:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -113 DAY), '10:52:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -114 DAY), '08:16:00')),
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -112 DAY), '19:36:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), '10:47:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (12, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), '14:16:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (18, 12, DATE_ADD(CURRENT_DATE, INTERVAL -110 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -103 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -117 DAY),'19:39:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -110 DAY), '15:22:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '18:03:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -103 DAY), '11:54:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (12, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -103 DAY), '14:19:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (10, 12, DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -132 DAY),'15:04:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), '17:49:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), '21:43:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), '16:16:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY), '11:06:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (12, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY), '13:02:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (51, 12, DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -103 DAY),'15:33:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), '14:30:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '19:59:00')),
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '21:49:00')),
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -89 DAY), '16:28:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), '11:11:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (12, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), '14:08:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (39, 12, DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -129 DAY),'12:56:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), '17:02:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), '09:26:00')),
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), '14:36:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), '11:18:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (12, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), '13:13:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (34, 12, DATE_ADD(CURRENT_DATE, INTERVAL -76 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY),'20:27:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -76 DAY), '17:03:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -76 DAY), '10:29:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '11:02:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (12, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '14:06:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (2, 12, DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY),'08:20:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '17:34:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '09:32:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '11:49:00')),
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '10:24:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY), '11:53:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (12, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY), '15:19:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (10, 12, DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY),'18:20:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), '19:22:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -67 DAY), '20:09:00')),
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), '09:01:00')),
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), '11:40:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), '11:53:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (12, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), '12:55:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (29, 12, DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY),'09:31:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), '14:29:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -59 DAY), '14:55:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), '11:28:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (12, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), '12:08:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (12, 12, DATE_ADD(CURRENT_DATE, INTERVAL -53 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY),'22:22:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -53 DAY), '20:11:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -53 DAY), '21:19:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -53 DAY), '15:42:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY), '10:21:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (12, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY), '14:53:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (39, 12, DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY),'12:50:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), '20:30:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), '17:51:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), '22:45:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), '11:23:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (12, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), '13:11:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (18, 12, DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY),'21:24:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), '17:11:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -43 DAY), '17:39:00')),
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -43 DAY), '16:17:00')),
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -43 DAY), '09:47:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -44 DAY), '08:37:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), '10:34:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (12, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), '14:28:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (7, 12, DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY),'20:05:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), '14:55:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), '16:37:00')),
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -36 DAY), '09:04:00')),
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '08:19:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), '11:00:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (12, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), '12:06:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (29, 12, DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -45 DAY),'14:28:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY), '14:49:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), '13:55:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY), '17:20:00')),
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), '09:56:00')),
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), '12:39:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), '10:30:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (12, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), '12:55:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (26, 12, DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY),'21:11:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), '14:06:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), '11:51:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), '20:23:00')),
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -13 DAY), '14:14:00')),
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), '16:11:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), '10:07:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (12, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), '14:36:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (52, 12, DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY),'21:18:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), '19:53:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), '09:35:00')),
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), '08:24:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), '11:58:00')),
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), '08:08:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY), '11:47:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (12, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY), '15:25:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (38, 12, DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -13 DAY),'21:02:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), '17:05:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), '22:15:00')),
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), '11:22:00')),
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), '08:33:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), '22:27:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY), '10:29:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (12, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY), '14:34:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (46, 12, DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 2 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY),'12:30:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY), '19:28:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (8, 12, DATE_ADD(CURRENT_DATE, INTERVAL 4 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 8 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'22:55:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (18, 12, DATE_ADD(CURRENT_DATE, INTERVAL 8 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 12 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -36 DAY),'08:19:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (39, 12, DATE_ADD(CURRENT_DATE, INTERVAL 15 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 20 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY),'10:56:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (9, 12, DATE_ADD(CURRENT_DATE, INTERVAL 24 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 27 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'08:16:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (34, 12, DATE_ADD(CURRENT_DATE, INTERVAL 28 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 31 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'11:40:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (48, 12, DATE_ADD(CURRENT_DATE, INTERVAL 31 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 34 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'20:57:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (3, 12, DATE_ADD(CURRENT_DATE, INTERVAL 38 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 40 DAY), 4, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'13:00:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (52, 12, DATE_ADD(CURRENT_DATE, INTERVAL 40 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 44 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'14:48:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (51, 12, DATE_ADD(CURRENT_DATE, INTERVAL 50 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 52 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'10:05:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (46, 12, DATE_ADD(CURRENT_DATE, INTERVAL 56 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 59 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'11:11:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (7, 13, DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -188 DAY),'11:25:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY), '16:36:00'), 3);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), '11:58:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), '12:39:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (16, 13, DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -171 DAY),'21:05:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (28, 13, DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -150 DAY),'08:15:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY), '14:12:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -133 DAY), '19:32:00')),
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -133 DAY), '13:51:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), '10:00:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), '14:43:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (38, 13, DATE_ADD(CURRENT_DATE, INTERVAL -129 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY),'20:32:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -129 DAY), '15:35:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY), '10:02:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY), '13:59:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (16, 13, DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -168 DAY),'09:23:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY), '20:41:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY), '11:46:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY), '15:49:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (1, 13, DATE_ADD(CURRENT_DATE, INTERVAL -113 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -107 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY),'16:10:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -113 DAY), '16:37:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '21:21:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -110 DAY), '09:15:00')),
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), '17:27:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -107 DAY), '11:08:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -107 DAY), '15:04:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (14, 13, DATE_ADD(CURRENT_DATE, INTERVAL -104 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY),'20:22:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -104 DAY), '16:37:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), '10:22:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), '13:46:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (6, 13, DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -94 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY),'19:29:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), '19:42:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY), '13:49:00')),
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY), '16:00:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -94 DAY), '10:42:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -94 DAY), '14:18:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (40, 13, DATE_ADD(CURRENT_DATE, INTERVAL -94 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -92 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY),'15:44:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -94 DAY), '19:36:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), '18:07:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), '13:05:00')),
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), '09:07:00')),
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -94 DAY), '09:41:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -92 DAY), '10:56:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -92 DAY), '13:13:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (2, 13, DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY),'08:45:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), '14:11:00'), 3);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '11:29:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '14:43:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (42, 13, DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -103 DAY),'21:20:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '15:47:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -87 DAY), '19:51:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), '10:39:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), '14:05:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (16, 13, DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY),'10:42:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), '14:22:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY), '13:56:00')),
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY), '21:41:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY), '10:18:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY), '14:33:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (6, 13, DATE_ADD(CURRENT_DATE, INTERVAL -74 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY),'22:47:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -74 DAY), '20:01:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '11:42:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '13:05:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (31, 13, DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -75 DAY),'13:48:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY), '14:13:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), '14:24:00')),
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), '21:55:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), '10:41:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), '14:09:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (16, 13, DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -64 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -92 DAY),'18:50:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), '18:12:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY), '12:28:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -64 DAY), '11:38:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -64 DAY), '14:49:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (35, 13, DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY),'11:09:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), '16:37:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY), '22:58:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), '11:46:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), '14:17:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (45, 13, DATE_ADD(CURRENT_DATE, INTERVAL -59 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY),'14:18:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -59 DAY), '16:28:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -59 DAY), '14:08:00')),
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -59 DAY), '20:13:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), '10:45:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), '15:03:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (6, 13, DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY),'08:47:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), '19:42:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY), '19:35:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '10:30:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '15:06:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (10, 13, DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -52 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -76 DAY),'09:09:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '20:25:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '17:50:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -53 DAY), '17:59:00')),
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '16:33:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -52 DAY), '11:06:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -52 DAY), '15:07:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (42, 13, DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY),'12:15:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY), '19:25:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), '18:31:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), '10:24:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), '13:52:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (2, 13, DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY),'22:40:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), '14:42:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), '09:04:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), '11:30:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), '15:14:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (29, 13, DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -37 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -52 DAY),'21:46:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), '14:37:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), '17:22:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -37 DAY), '11:34:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -37 DAY), '14:50:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (34, 13, DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -33 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY),'17:23:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), '14:21:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -34 DAY), '09:29:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -33 DAY), '10:32:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -33 DAY), '15:43:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (49, 13, DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY),'09:41:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY), '18:41:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), '10:22:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY), '09:52:00')),
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), '15:38:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), '11:16:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), '14:05:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (10, 13, DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY),'22:46:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), '20:33:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), '16:51:00')),
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), '10:53:00')),
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), '12:15:00')),
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), '19:59:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), '10:21:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), '15:38:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (50, 13, DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY),'16:50:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), '17:40:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), '09:36:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY), '10:22:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY), '14:44:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (6, 13, DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY),'13:28:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY), '15:06:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), '10:55:00')),
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), '15:20:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), '11:58:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), '14:32:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (44, 13, DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -12 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY),'13:57:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), '16:11:00'), 3);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -12 DAY), '10:36:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -12 DAY), '12:18:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (12, 13, DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -36 DAY),'16:00:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), '14:33:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY), '18:42:00')),
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY), '09:41:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), '11:32:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), '12:31:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (14, 13, DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -37 DAY),'10:33:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), '17:51:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), '19:21:00')),
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), '17:49:00')),
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), '09:35:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), '11:42:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (13, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), '12:50:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (22, 13, DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 4 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY),'10:06:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), '20:46:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (24, 13, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 10 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -13 DAY),'10:09:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (5, 13, DATE_ADD(CURRENT_DATE, INTERVAL 11 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 15 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY),'21:33:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (7, 13, DATE_ADD(CURRENT_DATE, INTERVAL 15 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 18 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY),'21:27:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (15, 13, DATE_ADD(CURRENT_DATE, INTERVAL 19 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 20 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -22 DAY),'10:58:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (17, 13, DATE_ADD(CURRENT_DATE, INTERVAL 21 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 25 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY),'12:15:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (8, 13, DATE_ADD(CURRENT_DATE, INTERVAL 31 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 33 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'20:12:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (38, 13, DATE_ADD(CURRENT_DATE, INTERVAL 36 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 40 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'10:08:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (35, 13, DATE_ADD(CURRENT_DATE, INTERVAL 46 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 53 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'08:57:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (14, 14, DATE_ADD(CURRENT_DATE, INTERVAL -149 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -157 DAY),'14:52:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -149 DAY), '17:07:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -149 DAY), '09:24:00')),
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -148 DAY), '16:20:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -147 DAY), '22:32:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), '10:23:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (14, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), '12:36:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (10, 14, DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -157 DAY),'19:57:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), '18:03:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), '10:08:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), '11:59:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (14, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), '13:29:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (45, 14, DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -132 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY),'11:56:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), '20:14:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY), '10:49:00')),
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY), '22:16:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -132 DAY), '11:44:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (14, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -132 DAY), '14:22:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (1, 14, DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -149 DAY),'22:28:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), '19:23:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -128 DAY), '17:58:00')),
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -129 DAY), '20:43:00')),
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), '16:53:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), '11:52:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (14, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), '14:11:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (25, 14, DATE_ADD(CURRENT_DATE, INTERVAL -124 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -120 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -149 DAY),'19:33:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -124 DAY), '18:59:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), '20:34:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -120 DAY), '10:41:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (14, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -120 DAY), '15:44:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (50, 14, DATE_ADD(CURRENT_DATE, INTERVAL -120 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -113 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -163 DAY),'20:55:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -120 DAY), '17:15:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), '11:57:00')),
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -114 DAY), '22:29:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -113 DAY), '11:01:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (14, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -113 DAY), '12:10:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (6, 14, DATE_ADD(CURRENT_DATE, INTERVAL -112 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -135 DAY),'22:55:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -112 DAY), '17:49:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), '16:00:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '11:12:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (14, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '15:40:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (1, 14, DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY),'10:41:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), '17:24:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -104 DAY), '20:04:00')),
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), '09:18:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -104 DAY), '11:03:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -104 DAY), '15:34:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), '10:07:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (14, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), '12:16:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (12, 14, DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -126 DAY),'18:18:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), '17:47:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), '10:26:00')),
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -100 DAY), '12:14:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), '11:37:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (14, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), '12:03:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (21, 14, DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -135 DAY),'14:40:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), '17:19:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), '09:48:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY), '10:43:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (14, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY), '15:31:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (37, 14, DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY),'21:38:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY), '17:56:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY), '21:31:00')),
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY), '22:38:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY), '10:50:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (14, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY), '15:23:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (19, 14, DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY),'13:18:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (17, 14, DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY),'22:48:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), '15:26:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY), '21:07:00')),
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY), '10:10:00')),
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY), '18:12:00')),
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), '16:34:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY), '10:43:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (14, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY), '14:41:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (51, 14, DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY),'09:31:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '15:06:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -70 DAY), '18:26:00')),
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY), '18:31:00')),
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), '22:55:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -67 DAY), '19:23:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY), '10:33:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (14, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY), '13:40:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (27, 14, DATE_ADD(CURRENT_DATE, INTERVAL -64 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY),'14:54:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -64 DAY), '14:59:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -64 DAY), '08:39:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY), '11:57:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (14, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY), '15:56:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (30, 14, DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY),'09:51:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY), '19:57:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY), '12:20:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY), '20:01:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), '11:30:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (14, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), '12:46:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (46, 14, DATE_ADD(CURRENT_DATE, INTERVAL -52 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY),'12:49:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -52 DAY), '15:53:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), '11:46:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (14, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), '15:32:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (12, 14, DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -41 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY),'16:40:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), '15:21:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), '10:26:00')),
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), '11:08:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -41 DAY), '10:56:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (14, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -41 DAY), '12:25:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (14, 14, DATE_ADD(CURRENT_DATE, INTERVAL -37 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY),'10:51:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (42, 14, DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -36 DAY),'17:12:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY), '14:26:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY), '13:38:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), '11:58:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (14, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), '15:14:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (50, 14, DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY),'12:47:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), '19:40:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -25 DAY), '10:17:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), '08:29:00')),
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), '12:10:00')),
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), '15:22:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), '11:35:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (14, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), '15:18:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (7, 14, DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY),'09:30:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY), '20:22:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY), '12:58:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY), '12:21:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), '10:12:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (14, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), '13:32:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (3, 14, DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY),'14:09:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), '14:36:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), '11:59:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), '11:33:00')),
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), '12:06:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), '11:50:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (14, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), '13:23:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (18, 14, DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY),'19:37:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), '17:47:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), '16:52:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), '10:14:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (14, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), '15:38:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (42, 14, DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY),'14:02:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), '16:48:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), '21:46:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), '10:00:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (14, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), '12:52:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (29, 14, DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 10 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'18:13:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (18, 14, DATE_ADD(CURRENT_DATE, INTERVAL 11 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 14 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'18:02:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (8, 14, DATE_ADD(CURRENT_DATE, INTERVAL 18 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 21 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY),'14:17:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (12, 14, DATE_ADD(CURRENT_DATE, INTERVAL 23 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 24 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'19:12:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (11, 14, DATE_ADD(CURRENT_DATE, INTERVAL 28 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 31 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'16:42:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (17, 14, DATE_ADD(CURRENT_DATE, INTERVAL 31 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 32 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'16:56:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (48, 14, DATE_ADD(CURRENT_DATE, INTERVAL 36 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 39 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY),'15:26:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (45, 14, DATE_ADD(CURRENT_DATE, INTERVAL 43 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 46 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'09:39:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (16, 14, DATE_ADD(CURRENT_DATE, INTERVAL 46 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 48 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'15:33:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (9, 14, DATE_ADD(CURRENT_DATE, INTERVAL 49 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 51 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'14:30:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (50, 14, DATE_ADD(CURRENT_DATE, INTERVAL 53 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 59 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'21:01:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (16, 15, DATE_ADD(CURRENT_DATE, INTERVAL -150 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -147 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -154 DAY),'18:59:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -150 DAY), '15:52:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -148 DAY), '20:30:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -147 DAY), '10:26:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (15, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -147 DAY), '13:49:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (52, 15, DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -191 DAY),'14:12:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (7, 15, DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -182 DAY),'19:32:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), '19:56:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), '08:45:00')),
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), '18:25:00')),
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), '15:25:00')),
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), '13:36:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), '10:01:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (15, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), '12:26:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (27, 15, DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -182 DAY),'10:36:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), '15:41:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), '16:30:00')),
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), '10:51:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), '10:03:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (15, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), '12:51:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (20, 15, DATE_ADD(CURRENT_DATE, INTERVAL -135 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -129 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -163 DAY),'13:57:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -135 DAY), '20:30:00'), 3);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -129 DAY), '11:31:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (15, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -129 DAY), '15:35:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (51, 15, DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -123 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -152 DAY),'08:34:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY), '20:55:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -124 DAY), '13:16:00')),
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY), '21:54:00')),
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -124 DAY), '09:59:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -123 DAY), '10:11:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (15, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -123 DAY), '12:44:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (49, 15, DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -147 DAY),'14:30:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (39, 15, DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -110 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -159 DAY),'21:22:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY), '19:44:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -114 DAY), '17:30:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -113 DAY), '19:01:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -110 DAY), '10:50:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (15, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -110 DAY), '12:13:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (6, 15, DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY),'18:51:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), '17:27:00'), 3);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), '10:39:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (15, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), '15:02:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (44, 15, DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY),'20:06:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), '15:20:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY), '21:48:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY), '14:11:00')),
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY), '12:32:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY), '10:05:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (15, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY), '13:41:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (29, 15, DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -132 DAY),'11:48:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '19:53:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '17:33:00')),
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '18:11:00')),
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '20:14:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), '11:54:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (15, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), '15:34:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (30, 15, DATE_ADD(CURRENT_DATE, INTERVAL -87 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -112 DAY),'15:55:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -87 DAY), '14:37:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), '11:09:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (15, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), '14:18:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (8, 15, DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY),'09:40:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), '14:24:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), '15:35:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), '13:50:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY), '11:31:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (15, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY), '14:33:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (40, 15, DATE_ADD(CURRENT_DATE, INTERVAL -76 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY),'15:45:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -76 DAY), '16:56:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -75 DAY), '09:39:00')),
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -76 DAY), '10:02:00')),
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -74 DAY), '16:38:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '10:07:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (15, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '14:10:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (28, 15, DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY),'12:47:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '20:09:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '21:26:00')),
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '15:25:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '16:11:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), '10:06:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (15, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), '14:47:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (47, 15, DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY),'10:14:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY), '14:59:00'), 3);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), '10:12:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (15, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), '12:56:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (15, 15, DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY),'13:41:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY), '17:59:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -58 DAY), '20:57:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '10:17:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (15, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '12:09:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (46, 15, DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY),'14:50:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY), '14:49:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY), '10:21:00')),
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY), '11:39:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), '11:25:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (15, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), '15:21:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (17, 15, DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY),'21:42:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), '14:06:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -43 DAY), '19:48:00')),
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), '12:31:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), '11:15:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (15, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), '12:01:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (50, 15, DATE_ADD(CURRENT_DATE, INTERVAL -40 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY),'13:06:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -40 DAY), '18:57:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '21:51:00')),
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '13:13:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -40 DAY), '19:44:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -40 DAY), '15:26:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), '11:13:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (15, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), '13:12:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (48, 15, DATE_ADD(CURRENT_DATE, INTERVAL -37 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY),'21:16:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -37 DAY), '15:51:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -36 DAY), '10:45:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), '11:49:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (15, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), '15:44:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (41, 15, DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -25 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY),'17:19:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY), '18:27:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY), '20:53:00')),
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), '17:36:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -25 DAY), '11:41:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (15, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -25 DAY), '13:40:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (51, 15, DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY),'12:12:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (43, 15, DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY),'22:43:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), '20:55:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), '18:36:00')),
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), '20:06:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY), '11:45:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (15, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY), '12:47:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (38, 15, DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY),'13:19:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), '14:34:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), '16:56:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), '11:34:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (15, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), '12:39:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (31, 15, DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -40 DAY),'14:05:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), '19:29:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -13 DAY), '11:27:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), '11:12:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (15, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), '15:19:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (5, 15, DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY),'15:50:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), '16:25:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), '11:02:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), '10:13:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (15, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), '14:31:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (38, 15, DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY),'10:04:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), '17:20:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY), '19:59:00')),
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY), '17:20:00')),
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), '22:13:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (48, 15, DATE_ADD(CURRENT_DATE, INTERVAL 4 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 6 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY),'21:14:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (14, 15, DATE_ADD(CURRENT_DATE, INTERVAL 10 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 14 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'17:08:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (7, 15, DATE_ADD(CURRENT_DATE, INTERVAL 18 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 21 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY),'20:29:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (5, 15, DATE_ADD(CURRENT_DATE, INTERVAL 24 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 28 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY),'09:43:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (3, 15, DATE_ADD(CURRENT_DATE, INTERVAL 32 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 35 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'10:53:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (40, 15, DATE_ADD(CURRENT_DATE, INTERVAL 41 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 43 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'14:31:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (7, 15, DATE_ADD(CURRENT_DATE, INTERVAL 43 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 49 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'09:50:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (48, 15, DATE_ADD(CURRENT_DATE, INTERVAL 52 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 54 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'21:52:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (41, 16, DATE_ADD(CURRENT_DATE, INTERVAL -149 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -147 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -159 DAY),'08:03:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -149 DAY), '17:22:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -148 DAY), '10:23:00')),
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -149 DAY), '10:32:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -148 DAY), '17:16:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -147 DAY), '11:13:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (16, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -147 DAY), '12:25:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (16, 16, DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -152 DAY),'08:24:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), '18:08:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), '22:32:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), '11:21:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (16, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), '12:47:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (16, 16, DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY),'10:34:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), '19:58:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), '10:41:00')),
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), '16:22:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), '10:35:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (16, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), '13:28:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (41, 16, DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -126 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY),'19:15:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), '17:14:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), '18:21:00')),
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), '16:55:00')),
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), '14:19:00')),
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -128 DAY), '17:52:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -126 DAY), '11:54:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (16, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -126 DAY), '13:25:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (19, 16, DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -149 DAY),'09:09:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY), '20:35:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -120 DAY), '10:48:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY), '11:42:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (16, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY), '12:10:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (34, 16, DATE_ADD(CURRENT_DATE, INTERVAL -113 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY),'17:41:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (3, 16, DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -151 DAY),'15:28:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '20:03:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '09:12:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '22:00:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), '11:03:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (16, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), '13:23:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (41, 16, DATE_ADD(CURRENT_DATE, INTERVAL -104 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY),'15:13:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -104 DAY), '17:54:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -103 DAY), '22:49:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), '11:45:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (16, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), '13:44:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (4, 16, DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -129 DAY),'13:20:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), '17:47:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -100 DAY), '15:06:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY), '10:53:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (16, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY), '13:09:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (23, 16, DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY),'17:16:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (34, 16, DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), 3, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -126 DAY),'18:41:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (9, 16, DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -89 DAY),'15:09:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), '20:56:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY), '08:30:00')),
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), '22:52:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), '10:31:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (16, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), '13:07:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (9, 16, DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY),'21:01:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), '15:18:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY), '17:52:00')),
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), '21:08:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), '11:46:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (16, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), '13:17:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (51, 16, DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -112 DAY),'17:40:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), '18:31:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -76 DAY), '17:20:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY), '11:13:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (16, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY), '15:03:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (51, 16, DATE_ADD(CURRENT_DATE, INTERVAL -70 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY),'20:36:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -70 DAY), '17:10:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY), '10:15:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (16, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY), '14:09:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (6, 16, DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -59 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY),'16:40:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY), '18:37:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), '17:03:00')),
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), '22:47:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -59 DAY), '10:14:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (16, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -59 DAY), '15:03:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (19, 16, DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY),'19:48:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), '18:43:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), '12:17:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '10:19:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (16, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '15:54:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (21, 16, DATE_ADD(CURRENT_DATE, INTERVAL -52 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY),'11:05:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -52 DAY), '17:42:00'), 3);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), '11:31:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (16, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), '14:57:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (35, 16, DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -43 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -86 DAY),'12:05:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), '15:35:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), '11:15:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -43 DAY), '10:25:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (16, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -43 DAY), '12:05:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (19, 16, DATE_ADD(CURRENT_DATE, INTERVAL -41 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY),'12:04:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -41 DAY), '15:41:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '11:15:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (16, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '12:43:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (49, 16, DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -70 DAY),'16:42:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '14:23:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), '17:13:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), '10:37:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (16, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), '14:39:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (7, 16, DATE_ADD(CURRENT_DATE, INTERVAL -33 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY),'19:56:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -33 DAY), '17:39:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY), '17:38:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), '10:52:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (16, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), '13:06:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (6, 16, DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -22 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -33 DAY),'21:05:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), '20:04:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), '16:29:00')),
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), '13:35:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -22 DAY), '10:17:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (16, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -22 DAY), '13:46:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (51, 16, DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -25 DAY),'18:08:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), '19:04:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), '12:49:00')),
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), '19:18:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), '10:59:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (16, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), '13:14:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (39, 16, DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY),'11:06:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), '20:14:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), '09:04:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), '18:27:00')),
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), '08:30:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), '10:45:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (16, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), '13:50:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (10, 16, DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY),'14:13:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), '17:48:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), '16:16:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), '21:27:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), '11:27:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (16, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), '12:20:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (16, 16, DATE_ADD(CURRENT_DATE, INTERVAL 2 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 6 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY),'22:15:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (8, 16, DATE_ADD(CURRENT_DATE, INTERVAL 9 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 14 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY),'13:06:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (21, 16, DATE_ADD(CURRENT_DATE, INTERVAL 20 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 23 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY),'16:53:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (5, 16, DATE_ADD(CURRENT_DATE, INTERVAL 26 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'10:17:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (46, 16, DATE_ADD(CURRENT_DATE, INTERVAL 34 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 36 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'20:44:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (16, 16, DATE_ADD(CURRENT_DATE, INTERVAL 37 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 38 DAY), 3, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'16:02:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (27, 16, DATE_ADD(CURRENT_DATE, INTERVAL 42 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 46 DAY), 3, 'pending', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'15:30:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (19, 16, DATE_ADD(CURRENT_DATE, INTERVAL 46 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 49 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'18:09:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (35, 16, DATE_ADD(CURRENT_DATE, INTERVAL 52 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 55 DAY), 1, 'pending', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'19:40:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (4, 17, DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -171 DAY),'20:36:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY), '17:34:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), '12:22:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), '10:26:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (17, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), '14:47:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (33, 17, DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -170 DAY),'12:01:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), '20:10:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), '14:00:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), '10:38:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (17, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), '13:08:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (23, 17, DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -128 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -152 DAY),'10:18:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY), '18:06:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY), '12:47:00')),
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY), '12:27:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -128 DAY), '11:59:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (17, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -128 DAY), '15:10:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (46, 17, DATE_ADD(CURRENT_DATE, INTERVAL -126 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -123 DAY), 3, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -161 DAY),'08:15:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (17, 17, DATE_ADD(CURRENT_DATE, INTERVAL -117 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY),'18:33:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -117 DAY), '16:25:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), '21:30:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY), '10:49:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (17, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY), '15:18:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (44, 17, DATE_ADD(CURRENT_DATE, INTERVAL -113 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY),'09:17:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -113 DAY), '15:13:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), '19:44:00')),
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), '17:08:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), '10:56:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (17, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), '15:02:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (17, 17, DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -114 DAY),'21:29:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '19:46:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '16:11:00')),
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '09:25:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY), '11:06:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (17, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY), '15:45:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (37, 17, DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY),'19:39:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), '17:28:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), '17:09:00')),
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), '15:28:00')),
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), '13:52:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY), '11:33:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (17, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY), '15:33:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (34, 17, DATE_ADD(CURRENT_DATE, INTERVAL -92 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY),'22:06:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -92 DAY), '20:34:00'), 3);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '11:05:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (17, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '12:48:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (23, 17, DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -110 DAY),'09:02:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '15:08:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '08:56:00')),
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -89 DAY), '11:14:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), '10:10:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (17, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), '14:34:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (2, 17, DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY),'13:53:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), '14:31:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -86 DAY), '14:40:00')),
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -86 DAY), '13:44:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), '11:28:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (17, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), '14:59:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (12, 17, DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -124 DAY),'12:32:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), '14:23:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), '19:15:00')),
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), '18:56:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY), '10:54:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (17, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY), '12:30:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (9, 17, DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -76 DAY),'11:37:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '14:30:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY), '08:43:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), '10:51:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (17, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), '12:02:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (41, 17, DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY),'11:10:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), '16:02:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), '12:46:00')),
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), '19:05:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), '10:16:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (17, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), '12:54:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (45, 17, DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY),'16:48:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), '14:50:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -59 DAY), '19:10:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), '10:42:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (17, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), '15:27:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (50, 17, DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -45 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -87 DAY),'08:19:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), '18:16:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -45 DAY), '10:06:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (17, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -45 DAY), '12:07:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (37, 17, DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -37 DAY), 3, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -58 DAY),'13:05:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (19, 17, DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY),'19:42:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY), '17:55:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), '20:54:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY), '10:01:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (17, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY), '14:33:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (41, 17, DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY),'14:00:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), '17:34:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), '14:59:00')),
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), '13:34:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY), '11:16:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (17, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY), '14:42:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (2, 17, DATE_ADD(CURRENT_DATE, INTERVAL -16 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -13 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -58 DAY),'22:30:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -16 DAY), '19:29:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), '21:17:00')),
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), '15:24:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -16 DAY), '14:50:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -13 DAY), '11:48:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (17, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -13 DAY), '14:53:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (32, 17, DATE_ADD(CURRENT_DATE, INTERVAL -12 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY),'13:07:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -12 DAY), '18:17:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), '17:42:00')),
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY), '19:01:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), '11:28:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (17, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), '15:51:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (14, 17, DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY),'22:10:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (37, 17, DATE_ADD(CURRENT_DATE, INTERVAL 2 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 6 DAY), 3, 'pending', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY),'14:57:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (34, 17, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 9 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY),'18:52:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (35, 17, DATE_ADD(CURRENT_DATE, INTERVAL 9 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 12 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'09:32:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (29, 17, DATE_ADD(CURRENT_DATE, INTERVAL 13 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 14 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY),'17:00:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (30, 17, DATE_ADD(CURRENT_DATE, INTERVAL 15 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 20 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY),'11:05:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (2, 17, DATE_ADD(CURRENT_DATE, INTERVAL 20 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 25 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY),'11:16:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (18, 17, DATE_ADD(CURRENT_DATE, INTERVAL 25 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 27 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'08:31:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (50, 17, DATE_ADD(CURRENT_DATE, INTERVAL 27 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY), 3, 'pending', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'08:58:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (49, 17, DATE_ADD(CURRENT_DATE, INTERVAL 31 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 35 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'13:09:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (34, 17, DATE_ADD(CURRENT_DATE, INTERVAL 37 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 44 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'16:16:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (15, 17, DATE_ADD(CURRENT_DATE, INTERVAL 46 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 47 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'20:25:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (22, 17, DATE_ADD(CURRENT_DATE, INTERVAL 51 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 58 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'20:32:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (18, 18, DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -154 DAY),'19:27:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), '14:59:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), '13:53:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), '10:24:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (18, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), '13:12:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (43, 18, DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -150 DAY),'08:02:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), '17:01:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), '10:06:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (18, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), '13:12:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (13, 18, DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -182 DAY),'08:31:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), '16:30:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), '10:02:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), '10:37:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (18, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), '13:22:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (32, 18, DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY),'20:05:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (39, 18, DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -126 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -148 DAY),'21:38:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), '19:29:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -128 DAY), '12:50:00')),
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -129 DAY), '20:42:00')),
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), '20:53:00')),
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -129 DAY), '14:47:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -126 DAY), '10:15:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (18, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -126 DAY), '14:31:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (26, 18, DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY),'13:54:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY), '14:40:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY), '13:26:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -124 DAY), '18:54:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -123 DAY), '10:47:00')),
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY), '17:23:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY), '10:15:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (18, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY), '14:06:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (22, 18, DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -114 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY),'12:20:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), '15:33:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -118 DAY), '17:01:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -118 DAY), '22:05:00')),
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), '21:23:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -114 DAY), '11:34:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (18, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -114 DAY), '14:01:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (38, 18, DATE_ADD(CURRENT_DATE, INTERVAL -113 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -154 DAY),'17:43:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -113 DAY), '19:37:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -112 DAY), '15:42:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), '11:59:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (18, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), '14:04:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (20, 18, DATE_ADD(CURRENT_DATE, INTERVAL -110 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -103 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -123 DAY),'19:18:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -110 DAY), '17:21:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -107 DAY), '16:56:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -103 DAY), '10:55:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (18, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -103 DAY), '12:57:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (32, 18, DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -133 DAY),'12:41:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), '17:09:00'), 3);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), '10:37:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (18, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), '15:55:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (21, 18, DATE_ADD(CURRENT_DATE, INTERVAL -94 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY),'16:43:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -94 DAY), '15:40:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), '19:16:00')),
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), '09:25:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '11:35:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (18, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '14:57:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (20, 18, DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -83 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY),'13:02:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), '16:21:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -86 DAY), '13:24:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -83 DAY), '10:43:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (18, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -83 DAY), '14:52:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (40, 18, DATE_ADD(CURRENT_DATE, INTERVAL -83 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -103 DAY),'17:55:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (33, 18, DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY),'17:16:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '14:47:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '15:50:00')),
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '20:25:00')),
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '16:24:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '21:30:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY), '10:03:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (18, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY), '12:05:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (23, 18, DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -103 DAY),'11:15:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY), '19:44:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), '12:13:00')),
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY), '20:08:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), '11:33:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (18, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), '12:14:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (18, 18, DATE_ADD(CURRENT_DATE, INTERVAL -59 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY),'13:33:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -59 DAY), '17:20:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -58 DAY), '18:11:00')),
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -58 DAY), '18:43:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), '11:58:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (18, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), '15:26:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (41, 18, DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -74 DAY),'13:00:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), '17:08:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), '11:02:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), '16:37:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY), '10:40:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (18, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY), '15:00:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (20, 18, DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -67 DAY),'16:26:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY), '19:14:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY), '16:42:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY), '11:47:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '11:30:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (18, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '15:36:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (25, 18, DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY),'19:47:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY), '17:13:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), '11:52:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (18, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), '14:08:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (2, 18, DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY),'21:56:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), '15:22:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -43 DAY), '10:57:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), '10:23:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (18, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), '12:06:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (46, 18, DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -36 DAY), 4, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY),'11:17:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (25, 18, DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -33 DAY),'15:04:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), '16:21:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), '18:37:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), '11:57:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (18, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), '14:33:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (23, 18, DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -58 DAY),'12:36:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), '17:57:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY), '18:02:00')),
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY), '16:26:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), '11:50:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (18, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), '12:56:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (40, 18, DATE_ADD(CURRENT_DATE, INTERVAL -16 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -12 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY),'10:39:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -16 DAY), '20:57:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -16 DAY), '08:26:00')),
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), '08:06:00')),
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), '11:52:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -12 DAY), '10:23:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (18, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -12 DAY), '14:49:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (26, 18, DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY),'13:38:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (7, 18, DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 2 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -36 DAY),'13:36:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), '18:14:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY), '08:11:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), '13:13:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (2, 18, DATE_ADD(CURRENT_DATE, INTERVAL 4 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 11 DAY), 2, 'pending', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'11:51:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (30, 18, DATE_ADD(CURRENT_DATE, INTERVAL 11 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 13 DAY), 4, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'13:44:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (29, 18, DATE_ADD(CURRENT_DATE, INTERVAL 13 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 15 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'17:47:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (19, 18, DATE_ADD(CURRENT_DATE, INTERVAL 16 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 18 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'11:21:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (9, 18, DATE_ADD(CURRENT_DATE, INTERVAL 20 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 23 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY),'13:36:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (38, 18, DATE_ADD(CURRENT_DATE, INTERVAL 24 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 31 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'15:38:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (34, 18, DATE_ADD(CURRENT_DATE, INTERVAL 31 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 33 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY),'21:16:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (19, 18, DATE_ADD(CURRENT_DATE, INTERVAL 39 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 42 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'15:56:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (41, 18, DATE_ADD(CURRENT_DATE, INTERVAL 45 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 46 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'09:57:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (10, 18, DATE_ADD(CURRENT_DATE, INTERVAL 46 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 50 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'19:42:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (48, 18, DATE_ADD(CURRENT_DATE, INTERVAL 53 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 54 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'17:19:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (41, 19, DATE_ADD(CURRENT_DATE, INTERVAL -149 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -159 DAY),'14:48:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -149 DAY), '16:39:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY), '19:06:00')),
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), '14:10:00')),
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -147 DAY), '14:57:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), '10:44:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (19, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), '12:36:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (4, 19, DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -184 DAY),'19:38:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), '19:08:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), '22:24:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), '11:07:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (19, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), '14:32:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (2, 19, DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -158 DAY),'22:03:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), '20:57:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), '17:33:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), '11:28:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (19, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), '15:41:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (4, 19, DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -126 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -169 DAY),'20:46:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), '17:25:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), '18:15:00')),
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), '13:19:00')),
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), '15:11:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), '13:19:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -126 DAY), '10:43:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (19, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -126 DAY), '12:30:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (37, 19, DATE_ADD(CURRENT_DATE, INTERVAL -126 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -155 DAY),'21:21:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -126 DAY), '19:37:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY), '22:00:00')),
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -124 DAY), '14:30:00')),
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY), '13:27:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), '10:17:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (19, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), '14:03:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (48, 19, DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -151 DAY),'15:31:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY), '15:58:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY), '22:48:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), '11:34:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (19, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), '12:46:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (17, 19, DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY),'08:09:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (49, 19, DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -103 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY),'21:23:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY), '14:13:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -104 DAY), '11:41:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -104 DAY), '15:12:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -104 DAY), '21:41:00')),
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY), '08:16:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -103 DAY), '11:15:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (19, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -103 DAY), '14:58:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (31, 19, DATE_ADD(CURRENT_DATE, INTERVAL -103 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -133 DAY),'21:31:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -103 DAY), '16:29:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), '20:20:00')),
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -100 DAY), '16:01:00')),
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -100 DAY), '17:02:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), '11:47:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (19, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), '12:45:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (51, 19, DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY),'18:44:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY), '16:18:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), '14:23:00')),
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -94 DAY), '20:22:00')),
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), '14:00:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), '11:55:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (19, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), '14:25:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (1, 19, DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY),'16:06:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), '15:37:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), '11:24:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (19, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), '13:16:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (46, 19, DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -124 DAY),'10:43:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), '14:30:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), '16:10:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY), '08:01:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY), '10:45:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (19, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY), '13:21:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (44, 19, DATE_ADD(CURRENT_DATE, INTERVAL -76 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -74 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -114 DAY),'22:13:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -76 DAY), '20:44:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -75 DAY), '19:52:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -75 DAY), '17:38:00')),
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -76 DAY), '14:24:00')),
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -75 DAY), '12:42:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -74 DAY), '11:51:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (19, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -74 DAY), '12:55:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (36, 19, DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY),'15:38:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '19:42:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '10:56:00')),
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '09:04:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '10:24:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (19, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '13:24:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (46, 19, DATE_ADD(CURRENT_DATE, INTERVAL -70 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY),'18:25:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -70 DAY), '17:07:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), '10:03:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (19, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), '15:21:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (44, 19, DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY),'09:57:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY), '15:28:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY), '17:04:00')),
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -64 DAY), '13:08:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), '11:38:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (19, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), '15:37:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (39, 19, DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -80 DAY),'16:14:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), '20:26:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), '11:18:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (19, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), '12:32:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (5, 19, DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY),'15:30:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), '14:20:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), '21:50:00')),
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), '17:46:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), '10:09:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (19, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), '14:37:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (40, 19, DATE_ADD(CURRENT_DATE, INTERVAL -44 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -59 DAY),'22:38:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -44 DAY), '16:27:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), '10:15:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (19, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), '15:15:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (29, 19, DATE_ADD(CURRENT_DATE, INTERVAL -41 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -40 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY),'14:00:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -41 DAY), '15:53:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -41 DAY), '22:05:00')),
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -41 DAY), '12:05:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -40 DAY), '11:42:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (19, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -40 DAY), '13:29:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (24, 19, DATE_ADD(CURRENT_DATE, INTERVAL -34 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY),'17:40:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -34 DAY), '20:55:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -34 DAY), '12:34:00')),
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY), '17:52:00')),
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -34 DAY), '17:30:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), '11:24:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (19, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), '15:18:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (13, 19, DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -22 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -36 DAY),'14:53:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (19, 19, DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY),'08:49:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (9, 19, DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY),'13:07:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), '18:07:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), '22:01:00')),
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), '20:35:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), '10:08:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (19, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), '13:28:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (38, 19, DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -22 DAY),'20:08:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), '19:13:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY), '10:10:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (19, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY), '12:25:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (39, 19, DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 1 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY),'08:37:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), '20:30:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (45, 19, DATE_ADD(CURRENT_DATE, INTERVAL 2 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 4 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY),'12:44:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (37, 19, DATE_ADD(CURRENT_DATE, INTERVAL 6 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY),'22:47:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (28, 19, DATE_ADD(CURRENT_DATE, INTERVAL 11 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 13 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY),'08:05:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (11, 19, DATE_ADD(CURRENT_DATE, INTERVAL 16 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 17 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -13 DAY),'22:41:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (43, 19, DATE_ADD(CURRENT_DATE, INTERVAL 18 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 20 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY),'08:58:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (35, 19, DATE_ADD(CURRENT_DATE, INTERVAL 26 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 31 DAY), 1, 'pending', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY),'20:52:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (18, 19, DATE_ADD(CURRENT_DATE, INTERVAL 35 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 38 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY),'12:42:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (8, 19, DATE_ADD(CURRENT_DATE, INTERVAL 42 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 48 DAY), 2, 'pending', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'15:48:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (4, 19, DATE_ADD(CURRENT_DATE, INTERVAL 49 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 53 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'18:43:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (21, 19, DATE_ADD(CURRENT_DATE, INTERVAL 55 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 58 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'12:28:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (28, 20, DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -167 DAY),'12:49:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY), '18:49:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY), '21:28:00')),
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), '17:33:00')),
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY), '15:59:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), '10:09:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (20, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), '15:22:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (25, 20, DATE_ADD(CURRENT_DATE, INTERVAL -141 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -135 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -173 DAY),'18:05:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -141 DAY), '18:28:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -135 DAY), '11:22:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (20, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -135 DAY), '15:56:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (11, 20, DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -164 DAY),'15:53:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY), '18:09:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), '22:38:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), '10:03:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (20, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), '15:49:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (52, 20, DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -120 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -155 DAY),'09:48:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), '14:04:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), '08:40:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -120 DAY), '10:07:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (20, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -120 DAY), '14:31:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (43, 20, DATE_ADD(CURRENT_DATE, INTERVAL -118 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -112 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -123 DAY),'22:43:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -118 DAY), '20:07:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -114 DAY), '22:35:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -112 DAY), '11:55:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (20, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -112 DAY), '12:39:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (49, 20, DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -147 DAY),'09:20:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), '14:18:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -107 DAY), '16:49:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY), '11:15:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (20, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY), '12:01:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (48, 20, DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -148 DAY),'11:53:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY), '16:59:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY), '13:52:00')),
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), '18:46:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), '10:29:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (20, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), '15:11:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (4, 20, DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY),'16:35:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), '16:26:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -100 DAY), '11:55:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY), '11:30:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (20, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY), '15:40:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (50, 20, DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY),'16:10:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), '15:53:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -92 DAY), '12:25:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -92 DAY), '18:20:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '10:08:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (20, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '13:02:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (31, 20, DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY),'08:05:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '18:32:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -87 DAY), '15:12:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), '11:58:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (20, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), '12:41:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (14, 20, DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -76 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY),'17:52:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY), '17:47:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), '10:25:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -76 DAY), '11:35:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (20, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -76 DAY), '15:14:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (21, 20, DATE_ADD(CURRENT_DATE, INTERVAL -75 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY),'18:52:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -75 DAY), '19:04:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '11:40:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (20, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '12:35:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (42, 20, DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY),'14:57:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), '17:57:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), '11:08:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (20, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), '14:27:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (33, 20, DATE_ADD(CURRENT_DATE, INTERVAL -67 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY),'11:43:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -67 DAY), '20:43:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -67 DAY), '20:07:00')),
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -67 DAY), '12:42:00')),
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -67 DAY), '21:41:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY), '10:37:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (20, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY), '13:55:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (22, 20, DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -59 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -83 DAY),'20:45:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY), '17:00:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -64 DAY), '19:37:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -59 DAY), '11:55:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (20, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -59 DAY), '14:24:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (10, 20, DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY),'16:11:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY), '16:51:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '13:59:00')),
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -52 DAY), '16:02:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY), '10:42:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (20, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY), '15:24:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (10, 20, DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY),'15:57:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), '18:28:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), '14:56:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), '11:00:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (20, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), '14:31:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (7, 20, DATE_ADD(CURRENT_DATE, INTERVAL -44 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY),'10:10:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -44 DAY), '20:54:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -41 DAY), '13:18:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), '22:02:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -43 DAY), '17:51:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '11:30:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (20, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '13:31:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (19, 20, DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -44 DAY),'17:55:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '14:26:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '15:00:00')),
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '08:45:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), '11:50:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (20, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), '12:15:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (51, 20, DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY),'11:59:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), '14:42:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -34 DAY), '17:54:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -33 DAY), '13:35:00')),
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY), '10:43:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY), '11:59:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (20, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY), '12:47:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (43, 20, DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY),'10:32:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (7, 20, DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY),'10:47:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -21 DAY), '20:08:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY), '10:20:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (20, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY), '12:27:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (46, 20, DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY),'22:22:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY), '15:24:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), '15:51:00')),
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), '22:06:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), '11:02:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (20, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), '15:02:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (15, 20, DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY),'13:11:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), '16:08:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), '11:42:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (20, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), '14:29:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (8, 20, DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -22 DAY),'22:03:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), '19:23:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY), '08:53:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), '09:23:00')),
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), '18:46:00')),
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), '19:30:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY), '10:39:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (20, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY), '13:18:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (51, 20, CURRENT_DATE, DATE_ADD(CURRENT_DATE, INTERVAL 1 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY),'12:05:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (33, 20, DATE_ADD(CURRENT_DATE, INTERVAL 5 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 8 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY),'12:34:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (6, 20, DATE_ADD(CURRENT_DATE, INTERVAL 8 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 11 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -22 DAY),'10:40:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (10, 20, DATE_ADD(CURRENT_DATE, INTERVAL 17 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 18 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY),'14:36:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (26, 20, DATE_ADD(CURRENT_DATE, INTERVAL 18 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 20 DAY), 1, 'pending', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY),'13:33:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (35, 20, DATE_ADD(CURRENT_DATE, INTERVAL 20 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 26 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY),'22:01:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (21, 20, DATE_ADD(CURRENT_DATE, INTERVAL 29 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY),'12:07:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (50, 20, DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 34 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY),'12:42:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (52, 20, DATE_ADD(CURRENT_DATE, INTERVAL 36 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 42 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY),'12:23:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (20, 20, DATE_ADD(CURRENT_DATE, INTERVAL 46 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 52 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'13:21:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (26, 20, DATE_ADD(CURRENT_DATE, INTERVAL 58 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 60 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'22:56:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (39, 21, DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -160 DAY),'11:12:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), '20:07:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), '21:54:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), '10:38:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (21, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), '13:00:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (52, 21, DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -168 DAY),'21:34:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), '14:58:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), '11:04:00')),
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), '21:26:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), '11:13:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (21, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), '14:43:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (44, 21, DATE_ADD(CURRENT_DATE, INTERVAL -141 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -154 DAY),'08:13:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -141 DAY), '15:00:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), '11:37:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (21, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), '15:26:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (3, 21, DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -161 DAY),'22:36:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (43, 21, DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -141 DAY),'12:13:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), '18:07:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), '08:30:00')),
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), '21:37:00')),
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), '20:05:00')),
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), '17:19:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), '11:00:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (21, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), '12:55:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (23, 21, DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -128 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -162 DAY),'09:56:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), '17:00:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -128 DAY), '11:21:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (21, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -128 DAY), '13:41:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (30, 21, DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -169 DAY),'17:11:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (40, 21, DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -159 DAY),'18:42:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY), '17:30:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), '11:33:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (21, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), '15:03:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (42, 21, DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -156 DAY),'17:16:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY), '19:31:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), '21:56:00')),
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -114 DAY), '19:48:00')),
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -112 DAY), '14:40:00')),
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), '09:06:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), '11:07:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (21, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), '14:45:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (18, 21, DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -150 DAY),'22:58:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '14:18:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -103 DAY), '19:01:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), '10:34:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (21, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), '13:35:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (8, 21, DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY),'11:36:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), '20:43:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), '09:49:00')),
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), '08:30:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), '11:25:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (21, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY), '15:29:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (31, 21, DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -141 DAY),'14:47:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY), '20:45:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -94 DAY), '19:17:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), '10:37:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (21, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), '13:12:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (39, 21, DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY),'13:10:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY), '20:53:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), '08:40:00')),
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '17:24:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), '11:07:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (21, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), '14:28:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (38, 21, DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -123 DAY),'13:08:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (7, 21, DATE_ADD(CURRENT_DATE, INTERVAL -75 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -86 DAY),'14:50:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -75 DAY), '15:33:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -75 DAY), '11:12:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '11:28:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (21, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '14:17:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (42, 21, DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY),'21:29:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), '19:43:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY), '10:25:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (21, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY), '15:21:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (34, 21, DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -83 DAY),'18:40:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY), '17:59:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -58 DAY), '20:56:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), '10:01:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (21, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), '14:54:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (44, 21, DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -70 DAY),'14:48:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '20:42:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -52 DAY), '08:50:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -51 DAY), '17:21:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), '10:03:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (21, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), '14:15:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (32, 21, DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -64 DAY),'15:23:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -49 DAY), '16:01:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), '08:41:00')),
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), '22:07:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), '10:54:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (21, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), '12:34:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (36, 21, DATE_ADD(CURRENT_DATE, INTERVAL -45 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY),'19:31:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -45 DAY), '15:30:00'), 3);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), '10:04:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (21, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), '14:11:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (23, 21, DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -34 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -44 DAY),'09:24:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '17:57:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '08:43:00')),
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -36 DAY), '16:17:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), '20:10:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -34 DAY), '10:35:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (21, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -34 DAY), '14:27:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (43, 21, DATE_ADD(CURRENT_DATE, INTERVAL -33 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -58 DAY),'15:43:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -33 DAY), '15:53:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -33 DAY), '09:28:00')),
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -33 DAY), '13:55:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -33 DAY), '16:00:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY), '10:20:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (21, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY), '15:04:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (28, 21, DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY),'17:34:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY), '19:42:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -32 DAY), '18:03:00')),
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), '13:35:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), '14:03:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), '10:34:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (21, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), '12:07:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (45, 21, DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY),'13:49:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (42, 21, DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY),'17:47:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), '15:53:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), '09:32:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -16 DAY), '13:28:00')),
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -12 DAY), '11:06:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), '10:15:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (21, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY), '13:33:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (2, 21, DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY),'12:02:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), '16:12:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), '14:27:00')),
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), '10:31:00')),
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), '08:57:00')),
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), '08:30:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), '11:20:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (21, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), '12:42:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (23, 21, DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY),'18:56:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (2, 21, CURRENT_DATE, DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -25 DAY),'10:01:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (33, 21, DATE_ADD(CURRENT_DATE, INTERVAL 4 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -37 DAY),'22:13:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (21, 21, DATE_ADD(CURRENT_DATE, INTERVAL 8 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 12 DAY), 2, 'pending', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY),'08:22:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (13, 21, DATE_ADD(CURRENT_DATE, INTERVAL 15 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 18 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -22 DAY),'11:23:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (51, 21, DATE_ADD(CURRENT_DATE, INTERVAL 22 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 29 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'11:34:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (45, 21, DATE_ADD(CURRENT_DATE, INTERVAL 29 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 34 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'09:32:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (15, 21, DATE_ADD(CURRENT_DATE, INTERVAL 35 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 36 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'17:29:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (49, 21, DATE_ADD(CURRENT_DATE, INTERVAL 37 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 41 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY),'12:05:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (26, 21, DATE_ADD(CURRENT_DATE, INTERVAL 47 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 48 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'08:46:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (4, 21, DATE_ADD(CURRENT_DATE, INTERVAL 49 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 55 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'17:10:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (26, 22, DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -188 DAY),'22:35:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY), '18:10:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), '21:18:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY), '08:31:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), '10:55:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (22, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), '14:12:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (47, 22, DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -161 DAY),'11:16:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), '14:12:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -137 DAY), '13:32:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), '11:25:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (22, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), '15:52:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (24, 22, DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -172 DAY),'11:17:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), '15:26:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), '17:24:00')),
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -129 DAY), '18:50:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY), '10:53:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (22, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY), '13:19:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (36, 22, DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -118 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY),'19:02:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), '20:09:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -120 DAY), '12:59:00')),
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), '18:01:00')),
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), '11:33:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -118 DAY), '10:38:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (22, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -118 DAY), '14:08:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (10, 22, DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -114 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY),'16:49:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), '18:09:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), '14:36:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), '16:11:00')),
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), '22:00:00')),
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), '13:23:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -114 DAY), '11:16:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (22, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -114 DAY), '12:13:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (48, 22, DATE_ADD(CURRENT_DATE, INTERVAL -112 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY),'12:36:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -112 DAY), '18:05:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), '08:04:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), '11:40:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (22, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), '12:03:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (27, 22, DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY),'22:12:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '16:25:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -107 DAY), '14:04:00')),
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -107 DAY), '20:37:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), '10:13:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (22, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), '14:26:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (13, 22, DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY),'13:52:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), '18:16:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY), '10:28:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (22, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY), '15:57:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (11, 22, DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY),'16:40:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY), '19:45:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -93 DAY), '16:02:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '11:43:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (22, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '13:57:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (25, 22, DATE_ADD(CURRENT_DATE, INTERVAL -87 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY),'11:37:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -87 DAY), '18:35:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), '08:10:00')),
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -87 DAY), '08:55:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -86 DAY), '15:32:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY), '11:31:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), '11:00:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (22, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), '15:30:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (51, 22, DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY),'19:11:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY), '20:53:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -75 DAY), '19:10:00')),
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -76 DAY), '18:29:00')),
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '19:14:00')),
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '15:45:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '10:56:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (22, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '14:06:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (47, 22, DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -83 DAY),'10:22:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), '20:31:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), '12:09:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), '10:11:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (22, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), '15:55:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (3, 22, DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY),'08:24:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -62 DAY), '18:54:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -56 DAY), '09:50:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY), '10:40:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (22, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY), '15:09:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (5, 22, DATE_ADD(CURRENT_DATE, INTERVAL -52 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY),'22:08:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -52 DAY), '16:07:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), '18:28:00')),
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY), '17:49:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), '11:09:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (22, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), '15:06:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (28, 22, DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -79 DAY),'14:27:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (11, 22, DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -43 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY),'13:42:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), '18:15:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), '15:08:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -43 DAY), '11:26:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (22, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -43 DAY), '14:12:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (4, 22, DATE_ADD(CURRENT_DATE, INTERVAL -43 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -41 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -85 DAY),'08:40:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -43 DAY), '15:55:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), '17:30:00')),
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), '15:35:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), '14:43:00')),
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -43 DAY), '22:49:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -41 DAY), '11:56:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (22, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -41 DAY), '14:11:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (28, 22, DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -36 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -75 DAY),'15:43:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '15:37:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '12:41:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -36 DAY), '10:33:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (22, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -36 DAY), '12:58:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (23, 22, DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY),'19:12:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), '20:17:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), '09:49:00')),
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), '22:57:00')),
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), '22:22:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY), '11:04:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (22, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY), '12:55:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (43, 22, DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY),'12:52:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), '17:30:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY), '18:56:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), '10:40:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (22, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), '15:25:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (46, 22, DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY),'08:27:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), '17:33:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -25 DAY), '21:03:00')),
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), '21:39:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), '12:38:00')),
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -25 DAY), '16:32:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), '10:16:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (22, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), '12:47:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (6, 22, DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY),'16:41:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -24 DAY), '18:40:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY), '10:50:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (22, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY), '14:22:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (12, 22, DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -16 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY),'13:16:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY), '15:11:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), '21:44:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), '10:18:00')),
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -17 DAY), '19:39:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), '20:30:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -16 DAY), '11:45:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (22, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -16 DAY), '13:43:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (6, 22, DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -41 DAY),'18:16:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), '15:48:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -15 DAY), '13:32:00')),
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -12 DAY), '16:12:00')),
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -13 DAY), '15:32:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY), '11:54:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (22, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY), '13:22:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (37, 22, DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), 3, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY),'11:12:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (34, 22, DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY),'17:30:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), '18:39:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), '14:49:00')),
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY), '17:44:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), '10:08:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (22, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), '13:38:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (10, 22, CURRENT_DATE, DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY),'20:21:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (22, 22, DATE_ADD(CURRENT_DATE, INTERVAL 9 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 12 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY),'13:37:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (10, 22, DATE_ADD(CURRENT_DATE, INTERVAL 18 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 25 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY),'21:47:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (31, 22, DATE_ADD(CURRENT_DATE, INTERVAL 31 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 33 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'17:16:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (48, 22, DATE_ADD(CURRENT_DATE, INTERVAL 34 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 37 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'11:32:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (32, 22, DATE_ADD(CURRENT_DATE, INTERVAL 40 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 46 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'17:45:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (10, 22, DATE_ADD(CURRENT_DATE, INTERVAL 52 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 58 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'17:33:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (43, 22, DATE_ADD(CURRENT_DATE, INTERVAL 59 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 60 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'10:25:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (34, 23, DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -160 DAY),'15:03:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -146 DAY), '18:36:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -143 DAY), '21:31:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), '10:10:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (23, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY), '15:50:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (41, 23, DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -156 DAY),'13:30:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), '18:49:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY), '21:38:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), '10:29:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (23, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -136 DAY), '13:03:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (37, 23, DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -147 DAY),'16:49:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY), '18:08:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -133 DAY), '21:19:00')),
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -132 DAY), '17:25:00')),
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -132 DAY), '20:26:00')),
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), '12:21:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), '10:56:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (23, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), '15:40:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (26, 23, DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -126 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -139 DAY),'22:19:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), '19:06:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -126 DAY), '11:12:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (23, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -126 DAY), '14:53:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (9, 23, DATE_ADD(CURRENT_DATE, INTERVAL -124 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -164 DAY),'10:57:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -124 DAY), '18:55:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -124 DAY), '08:55:00')),
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -124 DAY), '11:27:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), '10:16:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (23, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), '13:44:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (4, 23, DATE_ADD(CURRENT_DATE, INTERVAL -117 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -114 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -158 DAY),'12:18:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -117 DAY), '17:56:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY), '18:56:00')),
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), '16:50:00')),
 (@s, 2, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY), '08:15:00')),
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY), '12:40:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -114 DAY), '11:04:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (23, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -114 DAY), '14:18:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (52, 23, DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -135 DAY),'10:49:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), '14:19:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), '12:49:00')),
 (@s, 8, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), '12:25:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), '10:38:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (23, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), '14:15:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (45, 23, DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -122 DAY),'19:33:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '20:17:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY), '10:21:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '20:10:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), '10:37:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (23, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -105 DAY), '13:11:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (43, 23, DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -92 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -110 DAY),'12:03:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -99 DAY), '16:00:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -94 DAY), '17:53:00')),
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -94 DAY), '19:57:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -92 DAY), '11:43:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (23, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -92 DAY), '12:49:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (2, 23, DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -103 DAY),'08:33:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), '15:15:00'), 2);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), '10:07:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (23, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), '14:03:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (9, 23, DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY),'10:39:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), '16:49:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -83 DAY), '17:28:00')),
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY), '20:22:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY), '14:48:00')),
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY), '19:31:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), '11:55:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (23, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), '15:45:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (39, 23, DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -91 DAY),'20:18:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY), '16:13:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY), '22:05:00')),
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY), '10:08:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY), '16:09:00')),
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY), '11:55:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), '11:02:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (23, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -77 DAY), '13:29:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (36, 23, DATE_ADD(CURRENT_DATE, INTERVAL -76 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -92 DAY),'09:27:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (33, 23, DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -70 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -104 DAY),'17:46:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '18:34:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -72 DAY), '21:19:00')),
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY), '15:23:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '12:40:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -70 DAY), '10:24:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (23, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -70 DAY), '14:04:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (41, 23, DATE_ADD(CURRENT_DATE, INTERVAL -70 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -98 DAY),'14:52:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -70 DAY), '14:21:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -70 DAY), '18:18:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), '10:34:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (23, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -69 DAY), '12:39:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (35, 23, DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -64 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -107 DAY),'16:35:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -68 DAY), '18:07:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY), '13:37:00')),
 (@s, 7, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -67 DAY), '08:22:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -64 DAY), '10:15:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (23, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -64 DAY), '15:40:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (4, 23, DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), 1, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY),'09:32:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (17, 23, DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -52 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -61 DAY),'10:02:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY), '16:36:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -53 DAY), '09:27:00')),
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -53 DAY), '10:34:00')),
 (@s, 5, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -53 DAY), '19:22:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -52 DAY), '11:13:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (23, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -52 DAY), '13:41:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (4, 23, DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -66 DAY),'22:04:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY), '17:03:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), '08:33:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), '11:32:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (23, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -46 DAY), '12:16:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (44, 23, DATE_ADD(CURRENT_DATE, INTERVAL -45 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -40 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -50 DAY),'20:30:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -45 DAY), '16:28:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY), '15:29:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -41 DAY), '19:26:00')),
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -43 DAY), '12:43:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -41 DAY), '22:21:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -40 DAY), '11:58:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (23, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -40 DAY), '14:56:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (18, 23, DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -42 DAY),'10:51:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '20:20:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -38 DAY), '17:19:00')),
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '11:19:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), '11:34:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (23, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -35 DAY), '15:23:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (18, 23, DATE_ADD(CURRENT_DATE, INTERVAL -34 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -43 DAY),'15:00:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -34 DAY), '14:55:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY), '16:56:00')),
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -34 DAY), '15:02:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -33 DAY), '15:17:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY), '12:56:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), '11:43:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (23, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), '12:46:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (40, 23, DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -25 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY),'20:48:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -29 DAY), '17:35:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -26 DAY), '21:58:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -25 DAY), '10:13:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (23, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -25 DAY), '13:29:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (28, 23, DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -40 DAY),'16:49:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), '15:53:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY), '12:06:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), '10:42:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (23, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), '13:48:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (27, 23, DATE_ADD(CURRENT_DATE, INTERVAL -14 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY),'17:04:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (6, 23, DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -28 DAY),'15:10:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), '14:46:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY), '14:43:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), '11:13:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (23, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), '13:59:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (36, 23, DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY),'17:59:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), '20:09:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), '19:51:00')),
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -8 DAY), '13:23:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), '11:33:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (23, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY), '12:44:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (9, 23, DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY),'20:51:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), '18:42:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -6 DAY), '11:48:00')),
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -5 DAY), '08:51:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), '10:12:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (23, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY), '14:30:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (5, 23, DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 1 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -11 DAY),'21:38:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY), '18:02:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY), '21:04:00')),
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -2 DAY), '21:24:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (2, 23, DATE_ADD(CURRENT_DATE, INTERVAL 2 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 6 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -16 DAY),'21:14:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (37, 23, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 10 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY),'20:35:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (34, 23, DATE_ADD(CURRENT_DATE, INTERVAL 13 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 16 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY),'13:20:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (35, 23, DATE_ADD(CURRENT_DATE, INTERVAL 17 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 24 DAY), 4, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'15:58:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (14, 23, DATE_ADD(CURRENT_DATE, INTERVAL 27 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 31 DAY), 1, 'pending', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'14:13:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (22, 23, DATE_ADD(CURRENT_DATE, INTERVAL 33 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 36 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -4 DAY),'15:11:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (5, 23, DATE_ADD(CURRENT_DATE, INTERVAL 38 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 40 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'15:14:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (14, 23, DATE_ADD(CURRENT_DATE, INTERVAL 40 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 45 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'21:38:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (40, 23, DATE_ADD(CURRENT_DATE, INTERVAL 46 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 49 DAY), 1, 'pending', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'22:38:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (12, 23, DATE_ADD(CURRENT_DATE, INTERVAL 50 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 53 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'19:01:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (12, 23, DATE_ADD(CURRENT_DATE, INTERVAL 54 DAY), DATE_ADD(CURRENT_DATE, INTERVAL 57 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY),'20:51:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (40, 24, DATE_ADD(CURRENT_DATE, INTERVAL -148 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -172 DAY),'15:55:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -148 DAY), '19:23:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -148 DAY), '18:16:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY), '11:22:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (24, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -145 DAY), '12:33:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (7, 24, DATE_ADD(CURRENT_DATE, INTERVAL -144 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -140 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -184 DAY),'14:34:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (51, 24, DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -135 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -157 DAY),'10:42:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), '20:23:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 3, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -138 DAY), '11:56:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -135 DAY), '11:42:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (24, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -135 DAY), '12:38:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (1, 24, DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -154 DAY),'16:32:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY), '15:56:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -134 DAY), '16:48:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), '10:16:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (24, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), '12:10:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (27, 24, DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -152 DAY),'20:26:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), '19:24:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -131 DAY), '09:36:00')),
 (@s, 7, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY), '20:27:00')),
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -127 DAY), '17:38:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY), '11:23:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (24, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -125 DAY), '12:18:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (26, 24, DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -114 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -133 DAY),'12:05:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -121 DAY), '20:12:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -115 DAY), '12:32:00')),
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -119 DAY), '09:00:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -114 DAY), '10:01:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (24, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -114 DAY), '15:03:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (16, 24, DATE_ADD(CURRENT_DATE, INTERVAL -113 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -130 DAY),'11:41:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -113 DAY), '17:21:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -111 DAY), '08:41:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -109 DAY), '11:24:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '10:38:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (24, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -108 DAY), '12:58:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (52, 24, DATE_ADD(CURRENT_DATE, INTERVAL -107 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -124 DAY),'19:07:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (51, 24, DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -142 DAY),'13:34:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -106 DAY), '20:47:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 4, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -102 DAY), '22:12:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), '10:12:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (24, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY), '15:27:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (19, 24, DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -117 DAY),'21:47:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY), '17:44:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY), '09:10:00')),
 (@s, 6, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY), '19:03:00')),
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY), '20:05:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -97 DAY), '09:42:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY), '10:09:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (24, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -95 DAY), '15:48:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (28, 24, DATE_ADD(CURRENT_DATE, INTERVAL -92 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -101 DAY),'15:13:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -92 DAY), '19:42:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -92 DAY), '13:02:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -90 DAY), '20:17:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), '10:09:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (24, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -88 DAY), '13:16:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (30, 24, DATE_ADD(CURRENT_DATE, INTERVAL -87 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -82 DAY), 2, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -116 DAY),'22:09:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (40, 24, DATE_ADD(CURRENT_DATE, INTERVAL -81 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -74 DAY), 4, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -84 DAY),'20:08:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (30, 24, DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -67 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -114 DAY),'17:02:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -73 DAY), '17:37:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 1, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -71 DAY), '18:03:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -67 DAY), '11:03:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (24, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -67 DAY), '13:27:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (45, 24, DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -87 DAY),'14:27:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY), '18:58:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY), '15:40:00')),
 (@s, 2, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -64 DAY), '08:08:00')),
 (@s, 7, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -65 DAY), '15:32:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), '10:45:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (24, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -63 DAY), '15:16:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (19, 24, DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -96 DAY),'13:51:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), '17:55:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -60 DAY), '10:25:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), '10:58:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (24, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -57 DAY), '15:07:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (31, 24, DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), 4, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -58 DAY),'10:37:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY), '14:42:00'), 4);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), '11:21:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (24, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), '12:00:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (49, 24, DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -43 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -78 DAY),'15:54:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), '17:52:00'), 2);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), '14:00:00')),
 (@s, 6, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), '18:22:00')),
 (@s, 4, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -47 DAY), '19:39:00')),
 (@s, 4, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -44 DAY), '17:36:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -43 DAY), '11:54:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (24, 5, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -43 DAY), '12:53:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (47, 24, DATE_ADD(CURRENT_DATE, INTERVAL -40 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), 3, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY),'17:55:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -40 DAY), '18:21:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -40 DAY), '15:41:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '11:11:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (24, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -39 DAY), '12:58:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (5, 24, DATE_ADD(CURRENT_DATE, INTERVAL -36 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY),'12:16:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -36 DAY), '16:10:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -34 DAY), '09:56:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY), '11:34:00'), check_out_staff_id = 2 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (24, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -31 DAY), '15:18:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (47, 24, DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), 4, 'cancelled', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -54 DAY),'22:44:00'));
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (4, 24, DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY), 2, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -55 DAY),'22:20:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -27 DAY), '14:41:00'), 3);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -23 DAY), '12:46:00')),
 (@s, 1, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -22 DAY), '12:19:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY), '11:43:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (24, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -20 DAY), '12:01:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (21, 24, DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -13 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -48 DAY),'10:33:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -19 DAY), '20:20:00'), 4);
SET @s = LAST_INSERT_ID();
INSERT INTO stay_services (stay_id, service_id, quantity, unit_price, used_at) VALUES
 (@s, 8, 1, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), '12:09:00')),
 (@s, 2, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -18 DAY), '20:18:00')),
 (@s, 6, 2, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -16 DAY), '18:41:00')),
 (@s, 5, 3, 1, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -16 DAY), '09:31:00'));
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -13 DAY), '11:32:00'), check_out_staff_id = 4 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'card', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (24, 7, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -13 DAY), '12:19:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');
INSERT INTO reservations (guest_id, room_id, check_in, check_out, guest_count, status, created_at) VALUES (20, 24, DATE_ADD(CURRENT_DATE, INTERVAL -13 DAY), DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY), 1, 'confirmed', TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -22 DAY),'21:03:00'));
SET @r = LAST_INSERT_ID();
INSERT INTO stays (reservation_id, checked_in_at, check_in_staff_id) VALUES (@r, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -13 DAY), '18:44:00'), 3);
SET @s = LAST_INSERT_ID();
UPDATE stays SET checked_out_at = TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY), '11:52:00'), check_out_staff_id = 3 WHERE id = @s;
INSERT INTO payments (stay_id, amount, method, paid_at)
SELECT @s, (SELECT SUM(nightly_price) FROM reservation_nights WHERE reservation_id = @r) + (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM stay_services WHERE stay_id = @s), 'cash', checked_out_at FROM stays WHERE id = @s;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES (24, 6, GREATEST(TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY), '15:37:00'), (SELECT checked_out_at FROM stays WHERE id = @s)), 'completed');

-- Bir oda bakımda: gelecek rezervasyonu yoktur.
UPDATE rooms SET status = 'maintenance' WHERE id = 24;
INSERT INTO cleaning_records (room_id, staff_id, cleaned_at, status) VALUES
 (24, 6, TIMESTAMP(DATE_ADD(CURRENT_DATE, INTERVAL -1 DAY), '09:30:00'), 'pending');
