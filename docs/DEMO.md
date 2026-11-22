# Sunum / kısa video çekim akışı

Tanıtım videosu için yaklaşık 6–8 dakikalık akış.

1. **Giriş (30 sn):** Proje adı, ekip üyeleri, Flask + MySQL seçimi. README'deki
   mimariyi ve ER diyagramını gösterin.
2. **Misafir (60 sn):** `misafir@otel.test` hesabıyla giriş. İleri bir tarih ve oda
   tipi seçin, oda arayın, fiyat/gece sayısını gösterin, rezervasyon oluşturun.
   Kendi rezervasyonları ve geçmiş konaklamaları gösterin. İkinci bir rezervasyonu
   iptal edin.
3. **Resepsiyon (90 sn):** `resepsiyon@otel.test`. Günlük giriş/çıkış listesi ve oda
   durumları. Bugün başlayan onaylı bir kayda check-in uygulayın, odanın dolu olduğunu
   gösterin. Kahvaltı/spa ekleyin, gece ve hizmet dökümünü açın. Nakit/kart seçip
   check-out tamamlayın. Oda temizlikte olmalı; temizliği tamamlayınca boş olmalı.
4. **Yönetici (60 sn):** `admin@otel.test`. Yeni hizmet ekleyip düzenleyin ve silin.
   Oda, oda tipi, sezon, personel ekranlarını gösterin. Aylık rapordaki doluluk ve
   tahsilatı açıklayın; işlem günlüğündeki INSERT/UPDATE kayıtlarını açın.
5. **Çakışma ve tetikleyiciler (60 sn):** Terminalde aşağıdaki testleri çalıştırın.
   Testin uygulamayı atlayıp doğrudan SQL INSERT/UPDATE yaptığını koddan gösterin.

   ```bash
   python -m pytest -v tests/test_database.py
   ```

   Aynı gecenin çakışması reddedilir, bitiş gününde yeni rezervasyon kabul edilir.
   İki eşzamanlı bağlantının yalnızca biri başarılı olabilir.
6. **ROLLBACK kanıtı (60 sn):** Aşağıdaki testi ve kaynak kodunu gösterin.

   ```bash
   python -m pytest -v tests/test_api.py -k checkout_failure
   ```

   Test ayrı veritabanı kurar; ödeme INSERT'ünü reddeden geçici test tetikleyicisi
   ekler. Check-out hata verir; konaklama açık, oda dolu ve ödeme sayısı aynı kalır.
   Test tetikleyicisi kaldırılınca aynı işlem başarıyla tamamlanır. Demo veritabanı
   değiştirilmez. `app/services.py` transaction sınırını gösterin.
7. **İndeks ve API (60 sn):** `docs/INDEX_PERFORMANCE.md` gerçek ölçüm ve yürütme
   planlarını gösterin. Postman'a koleksiyonu içe aktarın, `base_url` değerini kontrol
   edin ve Collection Runner çalıştırın. Önce giriş isteklerinin token aldığını,
   ardından diğer uç noktaların bu token'ı kullandığını açıklayın.
8. **Kapanış (20 sn):** GitHub klasör düzeni, test sonucu ve kurulum komutunu gösterin.

## Çekim öncesi

- `.env`, parola hash'i veya JWT token'ı ekranda açık tutmayın. Gösterilen demo
  parolası dışında kişisel bilgi kullanmayın.
- Bugünkü günlük örnek akış için seed'in hangi tarihte yüklendiğini dikkate alın.
  Veriyi silmeden bugün için yeni rezervasyon oluşturabilirsiniz.
- YouTube'a kendi hesabınızdan yükledikten sonra bağlantıyı README'ye ekleyin.
- GitHub deposuna ekip üyelerini ve öğrenci numaralarını ekleyin.
