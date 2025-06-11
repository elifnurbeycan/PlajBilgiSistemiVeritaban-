-- 1. Sorgu
-- Plaj, plajdaki etkinlik, etkinlik türü ve kullanıcı katılımı tablolarını birleştirerek;
-- her plajda düzenlenen etkinliklerin tarih, ücret ve katılımcı sayılarını raporlar.
SELECT
    P.plaj_ad,                            -- Etkinliğin düzenlendiği plajın adı
    E.etk_adi,                            -- Etkinliğin başlığı
    PE.etk_bas_tar,                      -- Etkinliğin başlama zamanı
    PE.etk_ucret,                        -- Etkinliğe katılım ücreti
    COUNT(KEK.kullaniciID) AS katilan_kullanici_sayisi -- Katılan kullanıcı sayısı
FROM
    PLAJ AS P
JOIN
    PLAJ_ETKINLIK AS PE ON P.plajID = PE.plajID
JOIN
    ETKINLIK AS E ON PE.etkinlikID = E.etkinlikID
LEFT JOIN
    KUL_ETK_KATILIM AS KEK ON PE.pl_etkID = KEK.pl_etkID
GROUP BY
    P.plajID, E.etkinlikID, PE.etk_bas_tar
ORDER BY
    P.plaj_ad, PE.etk_bas_tar;

-- 2. Sorgu
-- Personel, maaş geçmişi, görev atamaları ve çalıştıkları plaj bilgilerini birleştirerek;
-- maaş değişim tarihçesini ve görev yerlerini raporlar.
SELECT
    PER.pers_ad,                         -- Personelin adı
    PER.pers_soyad,                      -- Personelin soyadı
    PER.gorev_turu,                      -- Çalıştığı görev türü
    MH.degisiklik_tarihi,               -- Maaş değişikliğinin tarihi
    MH.eski_maas,                        -- Önceki maaş miktarı
    MH.yeni_maas,                        -- Güncel maaş miktarı
    P.plaj_ad AS gorev_aldigi_plaj_adi, -- Görev yaptığı plaj adı
    GA.baslangic_tarihi AS gorev_baslangic_tarihi -- Göreve başlama tarihi
FROM
    PERSONEL AS PER
JOIN
    MAAS_HAREKETLERI AS MH ON PER.personelID = MH.personelID
LEFT JOIN
    GOREV_ATAMALARI AS GA ON PER.personelID = GA.personelID
LEFT JOIN
    PLAJ AS P ON GA.plajID = P.plajID
ORDER BY
    PER.pers_ad, MH.degisiklik_tarihi DESC;

