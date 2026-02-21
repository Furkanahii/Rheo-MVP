import os

# =========================================================
# 1) SENİN ÖDEV FONKSİYONLARIN (GÜNCELLENMİŞ)
# =========================================================

def read_imagefile(f):
    # Dosyanin tamamini okuyup parcalara ayiriyoruz
    icerik = f.read().split()
    genislik = int(icerik[1])
    yukseklik = int(icerik[2])
    sayilar = icerik[4:]
    matris = []
    sayac = 0
    for i in range(yukseklik):
        satir = []
        for j in range(genislik):
            satir.append(int(sayilar[sayac]))
            sayac += 1
        matris.append(satir)
    return matris

def write_imagefile(f, matris):
    h = len(matris)
    w = len(matris[0])
    # Header: P2, Genislik, Yukseklik, MaxDeger
    f.write(f"P2 {w} {h} 255\n")
    for satir in matris:
        satir_str = ""
        for piksel in satir:
            satir_str += str(piksel) + " "
        # strip() ile sondaki gereksiz boslugu siliyoruz
        f.write(satir_str.strip() + "\n")

def misalign(matris):
    boy = len(matris)
    en = len(matris[0])
    for j in range(en):
        if j % 2 == 1:
            sutun = []
            for i in range(boy):
                sutun.append(matris[i][j])
            sutun.reverse()
            for i in range(boy):
                matris[i][j] = sutun[i]
    return matris

def sort_columns(matris):
    boy = len(matris)
    en = len(matris[0])
    for j in range(en):
        gecici_liste = []
        for i in range(boy):
            gecici_liste.append(matris[i][j])
        gecici_liste.sort()
        for i in range(boy):
            matris[i][j] = gecici_liste[i]
    return matris

def sort_rows_border(matris):
    boy = len(matris)
    for i in range(boy):
        satir = matris[i]
        
        # 1. Adim: Satiri 0 (border) olan yerlerden parcalara ayiralim
        gruplar = []
        gecici_grup = []
        
        for eleman in satir:
            if eleman == 0:
                if len(gecici_grup) > 0:
                    gruplar.append(gecici_grup)
                    gecici_grup = []
                gruplar.append("SINIR") # 0 gordugumuz yere isaret koyuyoruz
            else:
                gecici_grup.append(eleman)
        
        if len(gecici_grup) > 0:
            gruplar.append(gecici_grup)
            
        # 2. Adim: Gruplari sirala ve birlestir
        yeni_satir = []
        for grup in gruplar:
            if grup == "SINIR":
                yeni_satir.append(0)
            else:
                grup.sort()
                yeni_satir.extend(grup)
                
        matris[i] = yeni_satir
        
    return matris

def convolution(matris, kernel):
    boy = len(matris)
    en = len(matris[0])
    yeni_resim = []
    
    for i in range(boy):
        yeni_satir = []
        for j in range(en):
            toplam = 0
            for k_i in range(3):
                for k_j in range(3):
                    bakilan_i = i + (k_i - 1)
                    bakilan_j = j + (k_j - 1)
                    
                    deger = 0
                    if 0 <= bakilan_i < boy and 0 <= bakilan_j < en:
                        deger = matris[bakilan_i][bakilan_j]
                    
                    toplam += deger * kernel[k_i][k_j]
            
            # Clipping (0-255 arasi)
            if toplam < 0: toplam = 0
            elif toplam > 255: toplam = 255
            
            yeni_satir.append(int(toplam))
            
        yeni_resim.append(yeni_satir)
            
    return yeni_resim

# =========================================================
# 2) TEST VE KARSILASTIRMA MOTORU
# =========================================================

def read_pgm_tokens(path):
    with open(path, "r") as f:
        return f.read().split()

def parse_pgm(path):
    # Basit parser: Header kontrolu yapmaz, sadece veriyi okur
    tokens = read_pgm_tokens(path)
    w = int(tokens[1])
    h = int(tokens[2])
    pixel_tokens = tokens[4:]
    
    mat = []
    idx = 0
    for r in range(h):
        row = []
        for c in range(w):
            row.append(int(pixel_tokens[idx]))
            idx += 1
        mat.append(row)
    return w, h, mat

def compare_pgm(expected_path, yours_path):
    print(f"Kiyaslaniyor: {expected_path} <--> {yours_path}")
    
    if not os.path.exists(expected_path):
        print(f"⚠️  {expected_path} bulunamadi (Atlandi)")
        return

    ew, eh, emat = parse_pgm(expected_path)
    yw, yh, ymat = parse_pgm(yours_path)

    if ew != yw or eh != yh:
        print(f"❌ BOYUT FARKI! Beklenen: {ew}x{eh}, Seninki: {yw}x{yh}")
        return

    mismatches = 0
    first_mismatches = []
    
    for r in range(eh):
        for c in range(ew):
            if emat[r][c] != ymat[r][c]:
                mismatches += 1
                if len(first_mismatches) < 5:
                    first_mismatches.append((r, c, emat[r][c], ymat[r][c]))

    if mismatches == 0:
        print("✅ BASARILI (Birebir Ayni)")
    else:
        print(f"❌ HATALI PIKSEL SAYISI: {mismatches}")
        print("   Ilk 5 Hata Ornegi:")
        for (r, c, expv, yourv) in first_mismatches:
            print(f"   -> Satir: {r}, Sutun: {c} | Hoca: {expv} vs Sen: {yourv}")

def test_scenario(base_name):
    print(f"--------------------------------------------------")
    print(f"TEST EDILIYOR: {base_name.upper()}")
    
    # 1. Misalign
    with open(f"{base_name}.pgm", "r") as f: m = read_imagefile(f)
    res = misalign(m)
    with open(f"benim_{base_name}_misalign.pgm", "w") as f: write_imagefile(f, res)
    compare_pgm(f"{base_name}_misalign.pgm", f"benim_{base_name}_misalign.pgm")

    # 2. Sort Columns
    with open(f"{base_name}.pgm", "r") as f: m = read_imagefile(f)
    res = sort_columns(m)
    with open(f"benim_{base_name}_sort_cols.pgm", "w") as f: write_imagefile(f, res)
    compare_pgm(f"{base_name}_sort_columns.pgm", f"benim_{base_name}_sort_cols.pgm")

    # 3. Sort Rows Border
    with open(f"{base_name}.pgm", "r") as f: m = read_imagefile(f)
    res = sort_rows_border(m)
    with open(f"benim_{base_name}_rows.pgm", "w") as f: write_imagefile(f, res)
    compare_pgm(f"{base_name}_sort_rows_border.pgm", f"benim_{base_name}_rows.pgm")

    # 4. Highpass (DUZELTILMIS KERNEL)
    with open(f"{base_name}.pgm", "r") as f: m = read_imagefile(f)
    
    # !!! ISTE BURASI !!! Main.py icindeki GERCEK kernel bu:
    kernel = [
        [-1, -1, -1],
        [-1,  9, -1],
        [-1, -1, -1]
    ]
    
    res = convolution(m, kernel)
    with open(f"benim_{base_name}_highpass.pgm", "w") as f: write_imagefile(f, res)
    compare_pgm(f"{base_name}_highpass.pgm", f"benim_{base_name}_highpass.pgm")

if __name__ == "__main__":
    if os.path.exists("animals.pgm"): test_scenario("animals")
    if os.path.exists("lenna.pgm"): test_scenario("lenna")
    input("\nCikis icin Enter...")
