-- Veritabani olusturma (opsiyonel, genelde phpMyAdmin'de manuel olusturulur veya direkt secilir)
-- CREATE DATABASE IF NOT EXISTS plaj_bilgi_sistemi;
-- USE plaj_bilgi_sistemi;

-- 1. PLAJ Tablosu
CREATE TABLE PLAJ (
    plajID INT PRIMARY KEY AUTO_INCREMENT, -- Plajin benzersiz kimligi
    plaj_ad VARCHAR(255) NOT NULL, -- Plajin adi
    kapasite INT, -- Plajin kapasitesi
    konum_koordinat VARCHAR(255), -- Plajin cografi koordinatlari
    konum_acikadres VARCHAR(500), -- Plajin acik adresi
    giris_ucreti DECIMAL(10, 2) -- Plaja giris ucreti
);

-- 2. ETKINLIK Tablosu
CREATE TABLE ETKINLIK (
    etkinlikID INT PRIMARY KEY AUTO_INCREMENT, -- Etkinligin benzersiz kimligi
    etk_adi VARCHAR(255) NOT NULL, -- Etkinligin adi
    etk_aciklama TEXT -- Etkinligin aciklamasi
);

-- 3. KULLANICI Tablosu
CREATE TABLE KULLANICI (
    kullaniciID INT PRIMARY KEY AUTO_INCREMENT, -- Kullanicinin benzersiz kimligi
    kul_ad VARCHAR(100) NOT NULL, -- Kullanicinin adi
    kul_soyad VARCHAR(100) NOT NULL, -- Kullanicinin soyadi
    kul_email VARCHAR(255) UNIQUE NOT NULL, -- Kullanicinin e-posta adresi, benzersiz olmali
    kul_kayit_tar DATE DEFAULT (CURRENT_DATE), -- Kayit tarihi (varsayilan olarak bugunun tarihi)
    kul_telefon VARCHAR(20), -- Kullanicinin telefon numarasi
    kul_dogumtar DATE -- Kullanicinin dogum tarihi
);

-- 4. PERSONEL Tablosu
CREATE TABLE PERSONEL (
    personelID INT PRIMARY KEY AUTO_INCREMENT, -- Personelin benzersiz kimligi
    pers_telefon VARCHAR(20), -- Personelin telefon numarasi
    is_bas_tarihi DATE NOT NULL, -- Ise baslama tarihi
    gorev_turu VARCHAR(100), -- Gorev turu (orn: cankurtaran, temizlik, yonetici)
    pers_maas DECIMAL(10, 2), -- Personelin maasi
    pers_ad VARCHAR(100) NOT NULL, -- Personelin adi
    pers_soyad VARCHAR(100) NOT NULL -- Personelin soyadi
);

-- 5. HIZMETLER Tablosu
CREATE TABLE HIZMETLER (
    hizmetID INT PRIMARY KEY AUTO_INCREMENT, -- Hizmetin benzersiz kimligi
    hizmet_ad VARCHAR(255) NOT NULL, -- Hizmetin adi (orn: sezlong, semsiye, dus)
    hizmet_ucret DECIMAL(10, 2) -- Hizmetin ucreti
);

-- 6. DENETIM_KAYITLARI Tablosu
CREATE TABLE DENETIM_KAYITLARI (
    denetimID INT PRIMARY KEY AUTO_INCREMENT, -- Denetimin benzersiz kimligi
    plajID INT NOT NULL, -- Denetimin yapildigi plajin ID'si
    raporlayan_kurum VARCHAR(255), -- Denetimi yapan kurum
    rapor_tarihi DATE NOT NULL, -- Denetim tarihi
    rapor_ad VARCHAR(255), -- Denetim raporunun adi/konusu
    rapor_pdf VARCHAR(500), -- Raporun PDF dosya yolu (istege bagli)
    FOREIGN KEY (plajID) REFERENCES PLAJ(plajID) -- Plaj tablosu ile iliski
);

-- 7. MAAS_HAREKETLERI Tablosu
CREATE TABLE MAAS_HAREKETLERI (
    hareketID INT PRIMARY KEY AUTO_INCREMENT, -- Maas hareketinin benzersiz kimligi
    personelID INT NOT NULL, -- Maas hareketinin ait oldugu personelin ID'si
    pers_ad VARCHAR(100),
    pers_soyad VARCHAR(100),
    pers_maas DECIMAL(10, 2),
    degisiklik_nedeni TEXT, -- Maas degisikliginin nedeni
    degisiklik_tarihi DATE NOT NULL, -- Maas degisikliginin tarihi
    yeni_maas DECIMAL(10, 2) NOT NULL, -- Yeni maas miktari
    eski_maas DECIMAL(10, 2), -- Eski maas miktari
    FOREIGN KEY (personelID) REFERENCES PERSONEL(personelID) -- Personel tablosu ile iliski
);

-- N:N iliskiler icin ara tablolar

-- 8. PLAJ_HIZMETLERI (Plaj - Hizmet)
CREATE TABLE PLAJ_HIZMETLERI (
    plaj_hizID INT PRIMARY KEY AUTO_INCREMENT, -- Ara tablonun benzersiz kimligi
    plajID INT NOT NULL, -- Iliskili plajin ID'si
    hizmetID INT NOT NULL, -- Iliskili hizmetin ID'si
    h_bas_tar DATE, -- Hizmetin plajda sunulmaya baslama tarihi
    h_bit_tar DATE, -- Hizmetin plajda sunulmayi bitirme tarihi
    FOREIGN KEY (plajID) REFERENCES PLAJ(plajID), -- Plaj tablosu ile iliski
    FOREIGN KEY (hizmetID) REFERENCES HIZMETLER(hizmetID), -- Hizmetler tablosu ile iliski
    UNIQUE (plajID, hizmetID) -- Bir plajda ayni hizmetin birden fazla kez tanimlanmasini engeller
);

-- 9. GOREV_ATAMALARI (Plaj - Personel)
CREATE TABLE GOREV_ATAMALARI (
    gorev_atamaID INT PRIMARY KEY AUTO_INCREMENT, -- Gorev atamasinin benzersiz kimligi
    plajID INT NOT NULL, -- Gorevin atandigi plajin ID'si
    personelID INT NOT NULL, -- Gorevin atandigi personelin ID'si
    baslangic_tarihi DATE NOT NULL, -- Gorevin baslangic tarihi
    bitis_tarihi DATE, -- Gorevin bitis tarihi (NULL olabilir)
    FOREIGN KEY (plajID) REFERENCES PLAJ(plajID), -- Plaj tablosu ile iliski
    FOREIGN KEY (personelID) REFERENCES PERSONEL(personelID), -- Personel tablosu ile iliski
    UNIQUE (plajID, personelID, baslangic_tarihi) -- Ayni personel ayni plajda ayni anda birden fazla gorev atamasina sahip olamaz
);

-- 10. PLAJ_ETKINLIK (Plaj - Etkinlik)
CREATE TABLE PLAJ_ETKINLIK (
    pl_etkID INT PRIMARY KEY AUTO_INCREMENT, -- Ara tablonun benzersiz kimligi
    plajID INT NOT NULL, -- Etkinligin gerceklestigi plajin ID'si
    etkinlikID INT NOT NULL, -- Gerceklesen etkinligin ID'si
    etk_ucret DECIMAL(10, 2), -- Etkinlige katilim ucreti
    etk_bas_tar DATETIME NOT NULL, -- Etkinligin baslangic tarihi ve saati
    etk_bit_tar DATETIME, -- Etkinligin bitis tarihi ve saati (NULL olabilir)
    FOREIGN KEY (plajID) REFERENCES PLAJ(plajID), -- Plaj tablosu ile iliski
    FOREIGN KEY (etkinlikID) REFERENCES ETKINLIK(etkinlikID), -- Etkinlik tablosu ile iliski
    UNIQUE (plajID, etkinlikID, etk_bas_tar) -- Bir plajda ayni etkinligin ayni zamanda birden fazla kez tanimlanmasini engeller
);

-- 11. PLAJ_ZIYARET (Kullanici - Plaj)
CREATE TABLE PLAJ_ZIYARET (
    ziyaretID INT PRIMARY KEY AUTO_INCREMENT, -- Ziyaretin benzersiz kimligi
    kullaniciID INT NOT NULL, -- Ziyaret eden kullanicinin ID'si
    plajID INT NOT NULL, -- Ziyaret edilen plajin ID'si
    ziyaret_giris DATETIME NOT NULL, -- Ziyaretin giris tarihi ve saati
    ziyaret_cikis DATETIME, -- Ziyaretin cikis tarihi ve saati (NULL olabilir)
    FOREIGN KEY (kullaniciID) REFERENCES KULLANICI(kullaniciID), -- Kullanici tablosu ile iliski
    FOREIGN KEY (plajID) REFERENCES PLAJ(plajID) -- Plaj tablosu ile iliski
);

-- 12. KUL_HIZMET_KULLANIM (Kullanici - Plaj Hizmet)
CREATE TABLE KUL_HIZMET_KULLANIM (
    kullanimID INT PRIMARY KEY AUTO_INCREMENT, -- Kullanimin benzersiz kimligi
    kullaniciID INT NOT NULL, -- Hizmeti kullanan kullanicinin ID'si
    plaj_hizID INT NOT NULL, -- Kullanilan plaj hizmetinin ID'si (PLAJ_HIZMETLERI tablosundan)
    kullanim_ucret DECIMAL(10, 2), -- Kullanim icin odenen ucret
    kullanim_tar DATETIME DEFAULT CURRENT_TIMESTAMP, -- Hizmetin kullanim tarihi ve saati
    FOREIGN KEY (kullaniciID) REFERENCES KULLANICI(kullaniciID), -- Kullanici tablosu ile iliski
    FOREIGN KEY (plaj_hizID) REFERENCES PLAJ_HIZMETLERI(plaj_hizID) -- PLAJ_HIZMETLERI tablosu ile iliski
);

-- 13. KUL_ETK_KATILIM (Kullanici - Plaj Etkinlik)
CREATE TABLE KUL_ETK_KATILIM (
    katilimID INT PRIMARY KEY AUTO_INCREMENT, -- Katilimin benzersiz kimligi
    kullaniciID INT NOT NULL, -- Katilan kullanicinin ID'si
    pl_etkID INT NOT NULL, -- Katilinan plaj etkinliginin ID'si (PLAJ_ETKINLIK tablosundan)
    kul_etk_giris DATETIME NOT NULL, -- Kullanicinin etkinlige giris saati
    kul_etk_cikis DATETIME, -- Kullanicinin etkinlikten cikis saati (NULL olabilir)
    FOREIGN KEY (kullaniciID) REFERENCES KULLANICI(kullaniciID), -- Kullanici tablosu ile iliski
    FOREIGN KEY (pl_etkID) REFERENCES PLAJ_ETKINLIK(pl_etkID) -- PLAJ_ETKINLIK tablosu ile iliski
);