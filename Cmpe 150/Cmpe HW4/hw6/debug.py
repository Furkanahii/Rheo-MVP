import Main as Odev

print("--- SORT ROWS BORDER DEBUG MODU ---")

try:
    # 1. Orjinal Lenna'nin ilk satirini oku
    with open("lenna.pgm", "r") as f:
        m_orj = Odev.read_imagefile(f)
        ilk_satir_orj = m_orj[0] # Sadece ilk satir

    # 2. Senin fonksiyonunla bu satiri sirala
    # Fonksiyon matrisi istedigi icin sahte bir matris icinde gonderiyoruz
    m_test = [ilk_satir_orj[:]] # Kopyasini gonder
    m_sonuc = Odev.sort_rows_border(m_test)
    senin_sirali_satirin = m_sonuc[0]

    # 3. Hocanin cevabindaki ilk satiri oku
    with open("lenna_sort_rows_border.pgm", "r") as f:
        m_hoca = Odev.read_imagefile(f)
        hoca_sirali_satir = m_hoca[0]

    # 4. Karsilastir ve Analiz Et
    print(f"\nOrjinal Satir Uzunlugu: {len(ilk_satir_orj)}")
    print(f"Senin Satir Uzunlugun : {len(senin_sirali_satirin)}")
    print(f"Hoca Satir Uzunlugu   : {len(hoca_sirali_satir)}")

    print("\n--- HATALI BOLGE ANALIZI (Indeks 180 civari) ---")
    start, end = 175, 190
    print(f"Senin sonucun [{start}:{end}]: {senin_sirali_satirin[start:end]}")
    print(f"Hoca sonucu   [{start}:{end}]: {hoca_sirali_satir[start:end]}")

    # Kritik Soru: Veri Kumesi Ayni mi?
    senin_sirali_satirin.sort()
    hoca_sirali_satir.sort()
    if senin_sirali_satirin == hoca_sirali_satir:
        print("\n✅ KUMELER AYNI: Sorun sadece 'Border' (0) mantiginda!")
        print("   -> Sifirlarin yerleri veya gruplama mantigi farkli.")
    else:
        print("\n❌ KUMELER FARKLI: Sorun 'read_imagefile' veya veride!")
        print("   -> Senin listende olup hocada olmayan (veya tam tersi) sayilar var.")
        # Farkli olan sayilari bul
        farklar = []
        for x in senin_sirali_satirin:
            if x not in hoca_sirali_satir:
                farklar.append(x)
        print(f"   -> Senin listendeki 'yabanci' sayilar: {farklar[:5]} ...")

except Exception as e:
    print(f"Hata: {e}")
