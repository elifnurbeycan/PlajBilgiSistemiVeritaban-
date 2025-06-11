-- queries.sql dosyasi
-- Bu dosya, plaj bilgi sistemi veritabani icin iki adet veri cekme (SELECT) sorgusu icerir.
-- Her iki sorgu da tablo birlestirme (JOIN) kullanir ve farkli sutunlar uzerinden birlestirme yapar.

-- Sorgu 1: Belirli bir plajda gerceklesen etkinlikleri ve bu etkinliklere katilan kullanici sayisini listeler.
-- Bu sorgu, PLAJ, PLAJ_ETKINLIK, ETKINLIK ve KUL_ETK_KATILIM tablolarini birlestirir.
-- PLAJ_ETKINLIK tablosu uzerinden plajlar ve etkinlikler birlestirilirken,
-- KUL_ETK_KATILIM tablosu uzerinden etkinliklere katilim bilgileri alinir.
SELECT
    P.plaj_ad, -- Plajin adini sec
    E.etk_adi, -- Etkinligin adini sec
    PE.etk_bas_tar, -- Etkinligin baslangic tarihini sec
    PE.etk_ucret, -- Etkinlik ucretini sec
    COUNT(KEK.kullaniciID) AS katilan_kullanici_sayisi -- Bu etkinlige katilan kullanici sayisini say
FROM
    PLAJ AS P -- PLAJ tablosunu P takma adiyla kullan
JOIN
    PLAJ_ETKINLIK AS PE ON P.plajID = PE.plajID -- PLAJ ve PLAJ_ETKINLIK tablolarini plajID uzerinden birlestir
JOIN
    ETKINLIK AS E ON PE.etkinlikID = E.etkinlikID -- PLAJ_ETKINLIK ve ETKINLIK tablolarini etkinlikID uzerinden birlestir
LEFT JOIN -- Opsiyonel: Etkinlige henuz kimse katilmamis olsa bile etkinligi gostermek icin LEFT JOIN
    KUL_ETK_KATILIM AS KEK ON PE.pl_etkID = KEK.pl_etkID -- PLAJ_ETKINLIK ve KUL_ETK_KATILIM tablolarini pl_etkID uzerinden birlestir
GROUP BY
    P.plajID, E.etkinlikID, PE.etk_bas_tar -- Agregasyon icin gruplama
ORDER BY
    P.plaj_ad, PE.etk_bas_tar; -- Sonuclari plaj adina ve etkinlik tarihine gore sirala


-- Sorgu 2: Personel maas hareketlerini, personelin guncel bilgilerini ve gorevlendirildigi plajlari listeler.
-- Bu sorgu, PERSONEL, MAAS_HAREKETLERI, GOREV_ATAMALARI ve PLAJ tablolarini birlestirir.
-- MAAS_HAREKETLERI ve GOREV_ATAMALARI, PERSONEL_ID uzerinden PERSONEL tablosuyla birlesir.
-- GOREV_ATAMALARI ve PLAJ tablolari PLAJ_ID uzerinden birlesir.
SELECT
    PER.pers_ad, -- Personelin adini sec
    PER.pers_soyad, -- Personelin soyadini sec
    PER.gorev_turu, -- Personelin gorev turunu sec
    MH.degisiklik_tarihi, -- Maas degisikliginin tarihini sec
    MH.eski_maas, -- Eski maas miktarini sec
    MH.yeni_maas, -- Yeni maas miktarini sec
    P.plaj_ad AS gorev_aldigi_plaj_adi, -- Gorev aldigi plajin adini sec
    GA.baslangic_tarihi AS gorev_baslangic_tarihi -- Gorevin baslangic tarihini sec
FROM
    PERSONEL AS PER -- PERSONEL tablosunu PER takma adiyla kullan
JOIN
    MAAS_HAREKETLERI AS MH ON PER.personelID = MH.personelID -- PERSONEL ve MAAS_HAREKETLERI tablolarini personelID uzerinden birlestir
LEFT JOIN -- Opsiyonel: Henuz gorev almamis personelleri de gostermek icin LEFT JOIN
    GOREV_ATAMALARI AS GA ON PER.personelID = GA.personelID -- PERSONEL ve GOREV_ATAMALARI tablolarini personelID uzerinden birlestir
LEFT JOIN -- Opsiyonel: Gorev atamasi olmayanlari da gostermek icin LEFT JOIN (eger GA NULL ise P de NULL olur)
    PLAJ AS P ON GA.plajID = P.plajID -- GOREV_ATAMALARI ve PLAJ tablolarini plajID uzerinden birlestir
ORDER BY
    PER.pers_ad, MH.degisiklik_tarihi DESC; -- Sonuclari personel adina ve degisiklik tarihine gore sirala