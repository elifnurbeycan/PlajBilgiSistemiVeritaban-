-- PLAJ: Her bir plajın temel tanımlayıcı bilgilerini içerir.
CREATE TABLE PLAJ (
    plajID INT PRIMARY KEY AUTO_INCREMENT, -- Plaja özgü sistemsel tanımlayıcı
    plaj_ad VARCHAR(255) NOT NULL, -- Plajın adı
    kapasite INT, -- Aynı anda barındırabileceği maksimum kişi sayısı
    konum_koordinat VARCHAR(255), -- Harita üzerindeki koordinat bilgisi
    konum_acikadres VARCHAR(500), -- Açık adres bilgisi
    giris_ucreti DECIMAL(10, 2) -- Genel giriş ücret bilgisi
);

-- ETKINLIK: Sistemde tanımlı etkinlikleri genel hatlarıyla tanımlar.
CREATE TABLE ETKINLIK (
    etkinlikID INT PRIMARY KEY AUTO_INCREMENT, -- Etkinliğe ait benzersiz kimlik
    etk_adi VARCHAR(255) NOT NULL, -- Etkinliğin başlığı
    etk_aciklama TEXT -- Etkinliğin açıklaması veya içeriği
);

-- KULLANICI: Sisteme kayıtlı kullanıcı bilgilerini saklar.
CREATE TABLE KULLANICI (
    kullaniciID INT PRIMARY KEY AUTO_INCREMENT, -- Kullanıcıya ait sistemsel ID
    kul_ad VARCHAR(100) NOT NULL, -- Kullanıcının adı
    kul_soyad VARCHAR(100) NOT NULL, -- Kullanıcının soyadı
    kul_email VARCHAR(255) UNIQUE NOT NULL, -- E-posta adresi (iletişim amaçlı)
    kul_kayit_tar DATE DEFAULT CURRENT_DATE, -- Kayıt tarihi (varsayılan: bugünün tarihi)
    kul_telefon VARCHAR(20), -- İletişim numarası
    kul_dogumtar DATE -- Doğum tarihi
);

-- PERSONEL: Plajlarda çalışan personellere ait kimlik ve görev bilgileri.
CREATE TABLE PERSONEL (
    personelID INT PRIMARY KEY AUTO_INCREMENT, -- Personel için benzersiz ID
    pers_telefon VARCHAR(20), -- İletişim numarası
    is_bas_tarihi DATE NOT NULL, -- İşe başlama tarihi
    gorev_turu VARCHAR(100), -- Görev tipi (ör: cankurtaran, temizlik)
    pers_maas DECIMAL(10, 2), -- Aylık maaş miktarı
    pers_ad VARCHAR(100) NOT NULL, -- Personelin adı
    pers_soyad VARCHAR(100) NOT NULL -- Personelin soyadı
);

-- HIZMETLER: Plajlarda sunulan hizmet türlerini ve fiyatlarını tanımlar.
CREATE TABLE HIZMETLER (
    hizmetID INT PRIMARY KEY AUTO_INCREMENT, -- Hizmet ID’si
    hizmet_ad VARCHAR(255) NOT NULL, -- Hizmetin adı
    hizmet_ucret DECIMAL(10, 2) -- Belirlenen hizmet ücreti
);

-- DENETIM_KAYITLARI: Plajlarda yapılan denetimlerin kayıtları tutulur.
CREATE TABLE DENETIM_KAYITLARI (
    denetimID INT PRIMARY KEY AUTO_INCREMENT, -- Denetim kaydının benzersiz kimliği
    plajID INT NOT NULL, -- Denetim yapılan plajın ID’si
    raporlayan_kurum VARCHAR(255), -- Denetimi gerçekleştiren kurumun adı
    rapor_tarihi DATE NOT NULL, -- Raporun hazırlandığı tarih
    rapor_ad VARCHAR(255), -- Raporun başlığı
    rapor_pdf VARCHAR(500), -- Raporun PDF yolu
    FOREIGN KEY (plajID) REFERENCES PLAJ(plajID)
);

-- MAAS_HAREKETLERI: Personelin maaş değişiklik geçmişi ve gerekçeleri kayıt altına alınır.
CREATE TABLE MAAS_HAREKETLERI (
    hareketID INT PRIMARY KEY AUTO_INCREMENT,
    personelID INT NOT NULL, -- İlgili personelin ID’si
    pers_ad VARCHAR(100),
    pers_soyad VARCHAR(100),
    pers_maas DECIMAL(10, 2), -- Değişiklik öncesi maaş
    degisiklik_nedeni TEXT, -- Açıklama/gerekçe
    degisiklik_tarihi DATE NOT NULL, -- Değişikliğin tarihi
    yeni_maas DECIMAL(10, 2) NOT NULL,
    eski_maas DECIMAL(10, 2),
    FOREIGN KEY (personelID) REFERENCES PERSONEL(personelID)
);

-- PLAJ_HIZMETLERI: Bir plajda verilen hizmetleri ve hizmet sürelerini ilişkilendirir.
CREATE TABLE PLAJ_HIZMETLERI (
    plaj_hizID INT PRIMARY KEY AUTO_INCREMENT,
    plajID INT NOT NULL,
    hizmetID INT NOT NULL,
    h_bas_tar DATE, -- Başlangıç tarihi
    h_bit_tar DATE, -- Bitiş tarihi
    FOREIGN KEY (plajID) REFERENCES PLAJ(plajID),
    FOREIGN KEY (hizmetID) REFERENCES HIZMETLER(hizmetID),
    UNIQUE (plajID, hizmetID) -- Aynı hizmet bir plaj için yalnızca bir kez tanımlanabilir
);

-- GOREV_ATAMALARI: Personelin görevli olduğu plaj ve tarih aralığı bilgileri tutulur.
CREATE TABLE GOREV_ATAMALARI (
    gorev_atamaID INT PRIMARY KEY AUTO_INCREMENT,
    plajID INT NOT NULL,
    personelID INT NOT NULL,
    baslangic_tarihi DATE NOT NULL,
    bitis_tarihi DATE,
    FOREIGN KEY (plajID) REFERENCES PLAJ(plajID),
    FOREIGN KEY (personelID) REFERENCES PERSONEL(personelID),
    UNIQUE (plajID, personelID, baslangic_tarihi) -- Aynı tarihte aynı plaj için tekrar atama yapılmasını engeller
);

-- PLAJ_ETKINLIK: Etkinliklerin hangi plajda ve ne zaman yapıldığını tanımlar.
CREATE TABLE PLAJ_ETKINLIK (
    pl_etkID INT PRIMARY KEY AUTO_INCREMENT,
    plajID INT NOT NULL,
    etkinlikID INT NOT NULL,
    etk_ucret DECIMAL(10, 2),
    etk_bas_tar DATETIME NOT NULL,
    etk_bit_tar DATETIME,
    FOREIGN KEY (plajID) REFERENCES PLAJ(plajID),
    FOREIGN KEY (etkinlikID) REFERENCES ETKINLIK(etkinlikID),
    UNIQUE (plajID, etkinlikID, etk_bas_tar)
);

-- PLAJ_ZIYARET: Kullanıcıların plaj ziyaret geçmişini içerir.
CREATE TABLE PLAJ_ZIYARET (
    ziyaretID INT PRIMARY KEY AUTO_INCREMENT,
    kullaniciID INT NOT NULL,
    plajID INT NOT NULL,
    ziyaret_giris DATETIME NOT NULL,
    ziyaret_cikis DATETIME,
    FOREIGN KEY (kullaniciID) REFERENCES KULLANICI(kullaniciID),
    FOREIGN KEY (plajID) REFERENCES PLAJ(plajID)
);

-- KUL_HIZMET_KULLANIM: Kullanıcıların hizmet kullanım kayıtlarını içerir.
CREATE TABLE KUL_HIZMET_KULLANIM (
    kullanimID INT PRIMARY KEY AUTO_INCREMENT,
    kullaniciID INT NOT NULL,
    plaj_hizID INT NOT NULL,
    kullanim_ucret DECIMAL(10, 2),
    kullanim_tar DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (kullaniciID) REFERENCES KULLANICI(kullaniciID),
    FOREIGN KEY (plaj_hizID) REFERENCES PLAJ_HIZMETLERI(plaj_hizID)
);

-- KUL_ETK_KATILIM: Kullanıcıların plaj etkinliklerine katılım kayıtlarını tutar.
CREATE TABLE KUL_ETK_KATILIM (
    katilimID INT PRIMARY KEY AUTO_INCREMENT,
    kullaniciID INT NOT NULL,
    pl_etkID INT NOT NULL,
    kul_etk_giris DATETIME NOT NULL,
    kul_etk_cikis DATETIME,
    FOREIGN KEY (kullaniciID) REFERENCES KULLANICI(kullaniciID),
    FOREIGN KEY (pl_etkID) REFERENCES PLAJ_ETKINLIK(pl_etkID)
);
