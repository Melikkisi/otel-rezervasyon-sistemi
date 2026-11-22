-- Otel Rezervasyon ve Konaklama Yönetim Sistemi / MySQL 8.4+
-- Yeni, boş bir veritabanında çalıştırın. DROP DATABASE içermez.
SET NAMES utf8mb4;
SET time_zone = '+03:00';

CREATE TABLE room_types (
 id INT AUTO_INCREMENT PRIMARY KEY,
 name VARCHAR(80) NOT NULL UNIQUE,
 capacity INT NOT NULL CHECK (capacity BETWEEN 1 AND 20),
 description VARCHAR(1000) NOT NULL DEFAULT '',
 base_price DECIMAL(12,2) NOT NULL CHECK (base_price > 0)
) ENGINE=InnoDB;

CREATE TABLE rooms (
 id INT AUTO_INCREMENT PRIMARY KEY,
 number VARCHAR(12) NOT NULL,
 floor INT NOT NULL CHECK (floor BETWEEN -5 AND 200),
 room_type_id INT NOT NULL,
 status ENUM('available','occupied','cleaning','maintenance') NOT NULL DEFAULT 'available',
 UNIQUE KEY uq_rooms_number (number),
 CONSTRAINT fk_rooms_type FOREIGN KEY (room_type_id) REFERENCES room_types(id)
) ENGINE=InnoDB;

CREATE TABLE seasonal_prices (
 id INT AUTO_INCREMENT PRIMARY KEY,
 room_type_id INT NOT NULL,
 start_date DATE NOT NULL,
 end_date DATE NOT NULL,
 nightly_price DECIMAL(12,2) NOT NULL CHECK (nightly_price > 0),
 CONSTRAINT ck_season_dates CHECK (end_date > start_date),
 CONSTRAINT fk_season_type FOREIGN KEY (room_type_id) REFERENCES room_types(id),
 KEY ix_season_type_dates (room_type_id,start_date,end_date)
) ENGINE=InnoDB;

CREATE TABLE guests (
 id INT AUTO_INCREMENT PRIMARY KEY,
 first_name VARCHAR(80) NOT NULL,
 last_name VARCHAR(80) NOT NULL,
 identity_no VARCHAR(30) NOT NULL UNIQUE,
 phone VARCHAR(30) NOT NULL,
 email VARCHAR(254) NOT NULL,
 birth_date DATE NOT NULL,
 UNIQUE KEY uq_guests_email (email)
) ENGINE=InnoDB;

CREATE TABLE staff (
 id INT AUTO_INCREMENT PRIMARY KEY,
 first_name VARCHAR(80) NOT NULL,
 last_name VARCHAR(80) NOT NULL,
 position ENUM('reception','housekeeping','admin') NOT NULL,
 hire_date DATE NOT NULL
) ENGINE=InnoDB;

CREATE TABLE users (
 id INT AUTO_INCREMENT PRIMARY KEY,
 email VARCHAR(254) NOT NULL UNIQUE,
 password_hash VARCHAR(255) NOT NULL,
 role ENUM('guest','reception','admin') NOT NULL,
 guest_id INT NULL UNIQUE,
 staff_id INT NULL UNIQUE,
 CONSTRAINT fk_users_guest FOREIGN KEY (guest_id) REFERENCES guests(id),
 CONSTRAINT fk_users_staff FOREIGN KEY (staff_id) REFERENCES staff(id),
 CONSTRAINT ck_user_profile CHECK (
  (role='guest' AND guest_id IS NOT NULL AND staff_id IS NULL) OR
  (role IN ('reception','admin') AND staff_id IS NOT NULL AND guest_id IS NULL)
 )
) ENGINE=InnoDB;

CREATE TABLE reservations (
 id INT AUTO_INCREMENT PRIMARY KEY,
 guest_id INT NOT NULL,
 room_id INT NOT NULL,
 check_in DATE NOT NULL,
 check_out DATE NOT NULL,
 guest_count INT NOT NULL CHECK (guest_count BETWEEN 1 AND 20),
 status ENUM('pending','confirmed','cancelled','completed') NOT NULL DEFAULT 'confirmed',
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT ck_reservation_dates CHECK (check_out > check_in AND DATEDIFF(check_out,check_in) <= 365),
 CONSTRAINT fk_reservations_guest FOREIGN KEY (guest_id) REFERENCES guests(id),
 CONSTRAINT fk_reservations_room FOREIGN KEY (room_id) REFERENCES rooms(id),
 KEY ix_reservations_room_dates (room_id,check_in,check_out,status),
 KEY ix_reservations_dates (check_in,check_out),
 KEY ix_reservations_guest (guest_id,created_at)
) ENGINE=InnoDB;

-- Fiyatın rezervasyon anındaki hali: sonraki sezon fiyatı değişiklikleri eski hesabı değiştirmez.
CREATE TABLE reservation_nights (
 id INT AUTO_INCREMENT PRIMARY KEY,
 reservation_id INT NOT NULL,
 night_date DATE NOT NULL,
 nightly_price DECIMAL(12,2) NOT NULL CHECK (nightly_price > 0),
 CONSTRAINT fk_nights_reservation FOREIGN KEY (reservation_id) REFERENCES reservations(id) ON DELETE CASCADE,
 UNIQUE KEY uq_reservation_night (reservation_id,night_date)
) ENGINE=InnoDB;

-- Yardımcı takvim, trigger tarafından yönetilir. Benzersizlik eşzamanlı yazımlarda da korunur.
CREATE TABLE room_calendar (
 room_id INT NOT NULL,
 night_date DATE NOT NULL,
 reservation_id INT NOT NULL,
 PRIMARY KEY (room_id,night_date),
 CONSTRAINT fk_calendar_room FOREIGN KEY (room_id) REFERENCES rooms(id),
 CONSTRAINT fk_calendar_reservation FOREIGN KEY (reservation_id) REFERENCES reservations(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE stays (
 id INT AUTO_INCREMENT PRIMARY KEY,
 reservation_id INT NOT NULL UNIQUE,
 checked_in_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 checked_out_at DATETIME NULL,
 check_in_staff_id INT NOT NULL,
 check_out_staff_id INT NULL,
 CONSTRAINT fk_stays_reservation FOREIGN KEY (reservation_id) REFERENCES reservations(id),
 CONSTRAINT fk_stays_in_staff FOREIGN KEY (check_in_staff_id) REFERENCES staff(id),
 CONSTRAINT fk_stays_out_staff FOREIGN KEY (check_out_staff_id) REFERENCES staff(id),
 CONSTRAINT ck_stay_times CHECK (checked_out_at IS NULL OR checked_out_at >= checked_in_at),
 CONSTRAINT ck_stay_checkout_staff CHECK ((checked_out_at IS NULL AND check_out_staff_id IS NULL) OR (checked_out_at IS NOT NULL AND check_out_staff_id IS NOT NULL))
) ENGINE=InnoDB;

CREATE TABLE services (
 id INT AUTO_INCREMENT PRIMARY KEY,
 name VARCHAR(100) NOT NULL UNIQUE,
 unit_price DECIMAL(12,2) NOT NULL CHECK (unit_price > 0)
) ENGINE=InnoDB;

CREATE TABLE stay_services (
 id INT AUTO_INCREMENT PRIMARY KEY,
 stay_id INT NOT NULL,
 service_id INT NOT NULL,
 quantity INT NOT NULL CHECK (quantity BETWEEN 1 AND 1000),
 unit_price DECIMAL(12,2) NOT NULL CHECK (unit_price > 0),
 used_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_stayservices_stay FOREIGN KEY (stay_id) REFERENCES stays(id),
 CONSTRAINT fk_stayservices_service FOREIGN KEY (service_id) REFERENCES services(id)
) ENGINE=InnoDB;

CREATE TABLE payments (
 id INT AUTO_INCREMENT PRIMARY KEY,
 stay_id INT NOT NULL,
 amount DECIMAL(12,2) NOT NULL CHECK (amount > 0),
 method ENUM('cash','card') NOT NULL,
 paid_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_payments_stay FOREIGN KEY (stay_id) REFERENCES stays(id),
 KEY ix_payments_date (paid_at)
) ENGINE=InnoDB;

CREATE TABLE cleaning_records (
 id INT AUTO_INCREMENT PRIMARY KEY,
 room_id INT NOT NULL,
 staff_id INT NOT NULL,
 cleaned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 status ENUM('pending','completed') NOT NULL DEFAULT 'completed',
 CONSTRAINT fk_cleaning_room FOREIGN KEY (room_id) REFERENCES rooms(id),
 CONSTRAINT fk_cleaning_staff FOREIGN KEY (staff_id) REFERENCES staff(id),
 KEY ix_cleaning_room_date (room_id,cleaned_at)
) ENGINE=InnoDB;

CREATE TABLE audit_logs (
 id BIGINT AUTO_INCREMENT PRIMARY KEY,
 table_name VARCHAR(64) NOT NULL,
 record_id INT NOT NULL,
 operation ENUM('INSERT','UPDATE','DELETE') NOT NULL,
 old_data JSON NULL,
 new_data JSON NULL,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 KEY ix_audit_table_date (table_name,created_at)
) ENGINE=InnoDB;

DELIMITER $$

CREATE FUNCTION fn_room_price(p_type INT,p_start DATE,p_end DATE)
RETURNS DECIMAL(12,2)
READS SQL DATA
BEGIN
 DECLARE v_day DATE;
 DECLARE v_base DECIMAL(12,2);
 DECLARE v_total DECIMAL(12,2) DEFAULT 0;
 SELECT base_price INTO v_base FROM room_types WHERE id=p_type;
 IF v_base IS NULL OR p_start IS NULL OR p_end IS NULL OR p_end<=p_start OR DATEDIFF(p_end,p_start)>365 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Geçerli bir oda tipi ve 1-365 gecelik tarih aralığı seçin.';
 END IF;
 SET v_day=p_start;
 WHILE v_day<p_end DO
  SET v_total=v_total+COALESCE((SELECT nightly_price FROM seasonal_prices WHERE room_type_id=p_type AND start_date<=v_day AND end_date>v_day LIMIT 1),v_base);
  SET v_day=DATE_ADD(v_day,INTERVAL 1 DAY);
 END WHILE;
 RETURN v_total;
END$$

-- Oda tipi satırı kilitlenir; aynı tipe eşzamanlı sezon eklemeleri sırayla kontrol edilir.
-- Tetikleyici kendi tablosunu FOR UPDATE ile okuyamaz (MySQL 1442), bu yüzden kilit oda tipindedir.
CREATE TRIGGER trg_season_insert BEFORE INSERT ON seasonal_prices FOR EACH ROW
BEGIN
 DECLARE v_lock INT;
 DECLARE v_conflict INT DEFAULT NULL;
 SELECT id INTO v_lock FROM room_types WHERE id=NEW.room_type_id FOR UPDATE;
 SELECT id INTO v_conflict FROM seasonal_prices WHERE room_type_id=NEW.room_type_id AND start_date<NEW.end_date AND end_date>NEW.start_date LIMIT 1;
 IF v_conflict IS NOT NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Bu oda tipi için sezon tarihleri çakışıyor.'; END IF;
END$$

CREATE TRIGGER trg_season_update BEFORE UPDATE ON seasonal_prices FOR EACH ROW
BEGIN
 DECLARE v_lock INT;
 DECLARE v_conflict INT DEFAULT NULL;
 SELECT id INTO v_lock FROM room_types WHERE id=NEW.room_type_id FOR UPDATE;
 SELECT id INTO v_conflict FROM seasonal_prices WHERE room_type_id=NEW.room_type_id AND id<>OLD.id AND start_date<NEW.end_date AND end_date>NEW.start_date LIMIT 1;
 IF v_conflict IS NOT NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Bu oda tipi için sezon tarihleri çakışıyor.'; END IF;
END$$

CREATE TRIGGER trg_reservation_validate_insert BEFORE INSERT ON reservations FOR EACH ROW
BEGIN
 DECLARE v_type INT;
 DECLARE v_capacity INT;
 DECLARE v_status VARCHAR(20);
 DECLARE v_conflict INT DEFAULT NULL;
 SELECT room_type_id,status INTO v_type,v_status FROM rooms WHERE id=NEW.room_id FOR UPDATE;
 SELECT capacity INTO v_capacity FROM room_types WHERE id=v_type;
 IF NEW.check_out<=NEW.check_in OR DATEDIFF(NEW.check_out,NEW.check_in)>365 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Çıkış tarihi girişten sonra ve süre en fazla 365 gece olmalıdır.'; END IF;
 IF NEW.guest_count>v_capacity THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Kişi sayısı oda kapasitesini aşıyor.'; END IF;
 IF v_status='maintenance' AND NEW.status<>'cancelled' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Bakımdaki odaya rezervasyon yapılamaz.'; END IF;
 IF NEW.status<>'cancelled' THEN
  SELECT reservation_id INTO v_conflict FROM room_calendar WHERE room_id=NEW.room_id AND night_date>=NEW.check_in AND night_date<NEW.check_out LIMIT 1 FOR UPDATE;
  IF v_conflict IS NOT NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Oda seçilen tarihlerde zaten rezerve edilmiş.'; END IF;
 END IF;
END$$

CREATE TRIGGER trg_reservation_validate_update BEFORE UPDATE ON reservations FOR EACH ROW
BEGIN
 DECLARE v_type INT;
 DECLARE v_capacity INT;
 DECLARE v_conflict INT DEFAULT NULL;
 DECLARE v_has_stay INT DEFAULT 0;
 SELECT room_type_id INTO v_type FROM rooms WHERE id=NEW.room_id FOR UPDATE;
 SELECT capacity INTO v_capacity FROM room_types WHERE id=v_type;
 IF NEW.check_out<=NEW.check_in OR DATEDIFF(NEW.check_out,NEW.check_in)>365 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Geçersiz rezervasyon tarih aralığı.'; END IF;
 IF NEW.guest_count>v_capacity THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Kişi sayısı oda kapasitesini aşıyor.'; END IF;
 SELECT COUNT(*) INTO v_has_stay FROM stays WHERE reservation_id=OLD.id;
 IF v_has_stay>0 AND (NEW.room_id<>OLD.room_id OR NEW.check_in<>OLD.check_in OR NEW.check_out<>OLD.check_out OR NEW.guest_id<>OLD.guest_id OR NEW.status IN ('pending','cancelled')) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Başlamış konaklamanın rezervasyonu değiştirilemez veya iptal edilemez.';
 END IF;
 IF OLD.status='completed' AND NEW.status<>'completed' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Tamamlanmış rezervasyon yeniden açılamaz.'; END IF;
 IF NEW.status<>'cancelled' THEN
  SELECT reservation_id INTO v_conflict FROM room_calendar WHERE room_id=NEW.room_id AND reservation_id<>OLD.id AND night_date>=NEW.check_in AND night_date<NEW.check_out LIMIT 1 FOR UPDATE;
  IF v_conflict IS NOT NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Oda seçilen tarihlerde zaten rezerve edilmiş.'; END IF;
 END IF;
END$$

CREATE TRIGGER trg_reservation_insert AFTER INSERT ON reservations FOR EACH ROW
BEGIN
 DECLARE v_day DATE;
 DECLARE v_type INT;
 SET v_day=NEW.check_in;
 SELECT room_type_id INTO v_type FROM rooms WHERE id=NEW.room_id;
 WHILE v_day<NEW.check_out DO
  INSERT INTO reservation_nights(reservation_id,night_date,nightly_price) VALUES(NEW.id,v_day,fn_room_price(v_type,v_day,DATE_ADD(v_day,INTERVAL 1 DAY)));
  IF NEW.status<>'cancelled' THEN INSERT INTO room_calendar(room_id,night_date,reservation_id) VALUES(NEW.room_id,v_day,NEW.id); END IF;
  SET v_day=DATE_ADD(v_day,INTERVAL 1 DAY);
 END WHILE;
 INSERT INTO audit_logs(table_name,record_id,operation,new_data) VALUES('reservations',NEW.id,'INSERT',JSON_OBJECT('guest_id',NEW.guest_id,'room_id',NEW.room_id,'check_in',NEW.check_in,'check_out',NEW.check_out,'guest_count',NEW.guest_count,'status',NEW.status));
END$$

CREATE TRIGGER trg_reservation_update AFTER UPDATE ON reservations FOR EACH ROW
BEGIN
 DECLARE v_day DATE;
 DECLARE v_type INT;
 IF NEW.room_id<>OLD.room_id OR NEW.check_in<>OLD.check_in OR NEW.check_out<>OLD.check_out THEN
  DELETE FROM reservation_nights WHERE reservation_id=NEW.id;
  SET v_day=NEW.check_in;
  SELECT room_type_id INTO v_type FROM rooms WHERE id=NEW.room_id;
  WHILE v_day<NEW.check_out DO
   INSERT INTO reservation_nights(reservation_id,night_date,nightly_price) VALUES(NEW.id,v_day,fn_room_price(v_type,v_day,DATE_ADD(v_day,INTERVAL 1 DAY)));
   SET v_day=DATE_ADD(v_day,INTERVAL 1 DAY);
  END WHILE;
 END IF;
 IF NEW.room_id<>OLD.room_id OR NEW.check_in<>OLD.check_in OR NEW.check_out<>OLD.check_out OR (NEW.status='cancelled')<>(OLD.status='cancelled') THEN
  DELETE FROM room_calendar WHERE reservation_id=NEW.id;
  IF NEW.status<>'cancelled' THEN
   SET v_day=NEW.check_in;
   WHILE v_day<NEW.check_out DO
    INSERT INTO room_calendar(room_id,night_date,reservation_id) VALUES(NEW.room_id,v_day,NEW.id);
    SET v_day=DATE_ADD(v_day,INTERVAL 1 DAY);
   END WHILE;
  END IF;
 END IF;
 INSERT INTO audit_logs(table_name,record_id,operation,old_data,new_data) VALUES('reservations',NEW.id,'UPDATE',JSON_OBJECT('guest_id',OLD.guest_id,'room_id',OLD.room_id,'check_in',OLD.check_in,'check_out',OLD.check_out,'guest_count',OLD.guest_count,'status',OLD.status),JSON_OBJECT('guest_id',NEW.guest_id,'room_id',NEW.room_id,'check_in',NEW.check_in,'check_out',NEW.check_out,'guest_count',NEW.guest_count,'status',NEW.status));
END$$

CREATE TRIGGER trg_reservation_delete AFTER DELETE ON reservations FOR EACH ROW
BEGIN
 INSERT INTO audit_logs(table_name,record_id,operation,old_data) VALUES('reservations',OLD.id,'DELETE',JSON_OBJECT('guest_id',OLD.guest_id,'room_id',OLD.room_id,'check_in',OLD.check_in,'check_out',OLD.check_out,'guest_count',OLD.guest_count,'status',OLD.status));
END$$

CREATE TRIGGER trg_stay_validate_insert BEFORE INSERT ON stays FOR EACH ROW
BEGIN
 DECLARE v_room INT;
 DECLARE v_res_status VARCHAR(20);
 DECLARE v_room_status VARCHAR(20);
 SELECT room_id,status INTO v_room,v_res_status FROM reservations WHERE id=NEW.reservation_id FOR UPDATE;
 SELECT status INTO v_room_status FROM rooms WHERE id=v_room FOR UPDATE;
 IF v_res_status<>'confirmed' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Yalnızca onaylı rezervasyona giriş yapılabilir.'; END IF;
 IF v_room_status<>'available' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Giriş için oda boş ve temiz olmalıdır.'; END IF;
 IF NEW.checked_out_at IS NOT NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Konaklama önce giriş, sonra çıkış işlemiyle oluşturulmalıdır.'; END IF;
END$$

CREATE TRIGGER trg_stay_insert AFTER INSERT ON stays FOR EACH ROW
BEGIN
 UPDATE rooms SET status='occupied' WHERE id=(SELECT room_id FROM reservations WHERE id=NEW.reservation_id);
END$$

CREATE TRIGGER trg_stay_validate_update BEFORE UPDATE ON stays FOR EACH ROW
BEGIN
 IF OLD.reservation_id<>NEW.reservation_id OR OLD.checked_in_at<>NEW.checked_in_at OR OLD.check_in_staff_id<>NEW.check_in_staff_id THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Konaklamanın giriş kaydı değiştirilemez.'; END IF;
 IF OLD.checked_out_at IS NOT NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Kapanmış konaklama değiştirilemez.'; END IF;
END$$

CREATE TRIGGER trg_stay_checkout AFTER UPDATE ON stays FOR EACH ROW
BEGIN
 IF OLD.checked_out_at IS NULL AND NEW.checked_out_at IS NOT NULL THEN
  UPDATE rooms SET status='cleaning' WHERE id=(SELECT room_id FROM reservations WHERE id=NEW.reservation_id);
  UPDATE reservations SET status='completed' WHERE id=NEW.reservation_id;
 END IF;
END$$

CREATE TRIGGER trg_service_validate_insert BEFORE INSERT ON stay_services FOR EACH ROW
BEGIN
 DECLARE v_checkout DATETIME;
 DECLARE v_price DECIMAL(12,2);
 SELECT checked_out_at INTO v_checkout FROM stays WHERE id=NEW.stay_id FOR UPDATE;
 IF v_checkout IS NOT NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Kapanmış konaklamaya hizmet eklenemez.'; END IF;
 SELECT unit_price INTO v_price FROM services WHERE id=NEW.service_id;
 SET NEW.unit_price=v_price;
END$$

CREATE TRIGGER trg_payment_insert AFTER INSERT ON payments FOR EACH ROW
BEGIN
 INSERT INTO audit_logs(table_name,record_id,operation,new_data) VALUES('payments',NEW.id,'INSERT',JSON_OBJECT('stay_id',NEW.stay_id,'amount',NEW.amount,'method',NEW.method,'paid_at',NEW.paid_at));
END$$

CREATE TRIGGER trg_payment_update AFTER UPDATE ON payments FOR EACH ROW
BEGIN
 INSERT INTO audit_logs(table_name,record_id,operation,old_data,new_data) VALUES('payments',NEW.id,'UPDATE',JSON_OBJECT('stay_id',OLD.stay_id,'amount',OLD.amount,'method',OLD.method,'paid_at',OLD.paid_at),JSON_OBJECT('stay_id',NEW.stay_id,'amount',NEW.amount,'method',NEW.method,'paid_at',NEW.paid_at));
END$$

CREATE TRIGGER trg_payment_delete AFTER DELETE ON payments FOR EACH ROW
BEGIN
 INSERT INTO audit_logs(table_name,record_id,operation,old_data) VALUES('payments',OLD.id,'DELETE',JSON_OBJECT('stay_id',OLD.stay_id,'amount',OLD.amount,'method',OLD.method,'paid_at',OLD.paid_at));
END$$

CREATE TRIGGER trg_cleaning_insert AFTER INSERT ON cleaning_records FOR EACH ROW
BEGIN
 IF NEW.status='completed' THEN UPDATE rooms SET status='available' WHERE id=NEW.room_id AND status='cleaning'; END IF;
END$$

CREATE TRIGGER trg_cleaning_update AFTER UPDATE ON cleaning_records FOR EACH ROW
BEGIN
 IF OLD.status<>'completed' AND NEW.status='completed' THEN UPDATE rooms SET status='available' WHERE id=NEW.room_id AND status='cleaning'; END IF;
END$$

CREATE PROCEDURE sp_available_rooms(IN p_start DATE,IN p_end DATE,IN p_type INT,IN p_guests INT)
READS SQL DATA
BEGIN
 IF p_start IS NULL OR p_end IS NULL OR p_end<=p_start OR DATEDIFF(p_end,p_start)>365 OR p_guests IS NULL OR p_guests<1 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Geçerli tarih aralığı ve kişi sayısı girin.';
 END IF;
 SELECT r.id,r.number,r.floor,r.room_type_id,r.status,t.name AS type_name,t.capacity,t.description,t.base_price,
        fn_room_price(t.id,p_start,p_end) AS total_price
 FROM rooms r JOIN room_types t ON t.id=r.room_type_id
 WHERE r.status<>'maintenance' AND t.capacity>=p_guests AND (p_type IS NULL OR t.id=p_type)
 AND NOT EXISTS(SELECT 1 FROM room_calendar c WHERE c.room_id=r.id AND c.night_date>=p_start AND c.night_date<p_end)
 ORDER BY total_price,r.number;
END$$

CREATE PROCEDURE sp_stay_total(IN p_stay INT)
READS SQL DATA
BEGIN
 DECLARE v_reservation INT;
 DECLARE v_room DECIMAL(12,2) DEFAULT 0;
 DECLARE v_services DECIMAL(12,2) DEFAULT 0;
 DECLARE v_paid DECIMAL(12,2) DEFAULT 0;
 SELECT reservation_id INTO v_reservation FROM stays WHERE id=p_stay;
 IF v_reservation IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Konaklama bulunamadı.'; END IF;
 SELECT COALESCE(SUM(nightly_price),0) INTO v_room FROM reservation_nights WHERE reservation_id=v_reservation;
 SELECT COALESCE(SUM(quantity*unit_price),0) INTO v_services FROM stay_services WHERE stay_id=p_stay;
 SELECT COALESCE(SUM(amount),0) INTO v_paid FROM payments WHERE stay_id=p_stay;
 SELECT v_room AS room_total,v_services AS services_total,v_room+v_services AS total,v_paid AS paid,v_room+v_services-v_paid AS balance;
END$$

CREATE PROCEDURE sp_monthly_report(IN p_year INT,IN p_month INT)
READS SQL DATA
BEGIN
 DECLARE v_start DATE;
 DECLARE v_end DATE;
 DECLARE v_occupied INT DEFAULT 0;
 DECLARE v_available INT DEFAULT 0;
 DECLARE v_revenue DECIMAL(14,2) DEFAULT 0;
 IF p_year IS NULL OR p_year<2000 OR p_year>2100 OR p_month IS NULL OR p_month<1 OR p_month>12 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Geçerli yıl ve ay girin.'; END IF;
 SET v_start=STR_TO_DATE(CONCAT(p_year,'-',LPAD(p_month,2,'0'),'-01'),'%Y-%m-%d');
 SET v_end=DATE_ADD(v_start,INTERVAL 1 MONTH);
 SELECT COUNT(*)*DATEDIFF(v_end,v_start) INTO v_available FROM rooms;
 SELECT COUNT(*) INTO v_occupied FROM reservation_nights n JOIN stays s ON s.reservation_id=n.reservation_id
 WHERE n.night_date>=v_start AND n.night_date<v_end AND n.night_date>=DATE(s.checked_in_at)
 AND n.night_date<COALESCE(DATE(s.checked_out_at),DATE_ADD(CURRENT_DATE,INTERVAL 1 DAY));
 SELECT COALESCE(SUM(amount),0) INTO v_revenue FROM payments WHERE paid_at>=v_start AND paid_at<v_end;
 SELECT p_year AS `year`,p_month AS `month`,v_occupied AS occupied_nights,v_available AS available_nights,
        ROUND(IF(v_available=0,0,100.0*v_occupied/v_available),2) AS occupancy_rate,v_revenue AS revenue;
END$$

DELIMITER ;

CREATE VIEW v_today_movements AS
 SELECT r.id AS reservation_id,CONCAT(g.first_name,' ',g.last_name) AS guest_name,o.number AS room_number,
 r.check_in,r.check_out,r.status,s.id AS stay_id,'arrival' AS movement
 FROM reservations r JOIN guests g ON g.id=r.guest_id JOIN rooms o ON o.id=r.room_id LEFT JOIN stays s ON s.reservation_id=r.id
 WHERE r.check_in=CURRENT_DATE AND r.status IN ('pending','confirmed')
 UNION ALL
 SELECT r.id,CONCAT(g.first_name,' ',g.last_name),o.number,r.check_in,r.check_out,r.status,s.id,'departure'
 FROM reservations r JOIN guests g ON g.id=r.guest_id JOIN rooms o ON o.id=r.room_id LEFT JOIN stays s ON s.reservation_id=r.id
 WHERE r.check_out=CURRENT_DATE AND r.status IN ('confirmed','completed');

CREATE VIEW v_room_status AS
 SELECT r.id,r.number,r.floor,r.room_type_id,t.name AS type_name,t.capacity,t.base_price,r.status,
 (SELECT MAX(c.cleaned_at) FROM cleaning_records c WHERE c.room_id=r.id AND c.status='completed') AS last_cleaned_at
 FROM rooms r JOIN room_types t ON t.id=r.room_type_id;
