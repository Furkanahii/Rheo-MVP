inp_filename, operation, out_filename = input().split()
# DO_NOT_EDIT_ANYTHING_ABOVE_THIS_LINE

def read_imagefile(f):
    # Dosyanin tamamini okuyup parcalara ayirdik
    icerik = f.read().split()
    
    # Header bilgilerini aliyoruz
    genislik = int(icerik[1])
    yukseklik = int(icerik[2])
    
    # Geri kalanlar piksel verisi (4. indisten itibaren)
    sayilar = icerik[4:]
    
    matris = []
    sayac = 0
    
    # Listeyi matrise cevirdik
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
    
    # Header bilgisini yazdik
    f.write(f"P2 {w} {h} 255\n")
    
    # Pikselleri dosya formatina uygun yazdik
    for satir in matris:
        satir_str = ""
        for piksel in satir:
            satir_str += str(piksel) + " "
        
        # strip() ile sondaki gereksiz boslugu sildik
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
        gruplar = []
        gecici = []
        
        for eleman in satir:
            if eleman == 0:
                if len(gecici) > 0:
                    gruplar.append(gecici)
                    gecici = []
                gruplar.append("SINIR") # 0 gordugumuz yere isaret koyduk
            else:
                gecici.append(eleman)
        
        if len(gecici) > 0:
            gruplar.append(gecici)
            
        # Gruplardan yeni satiri olusturduk
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
                    
            if toplam < 0:
                toplam = 0
            elif toplam > 255:
                toplam = 255
            yeni_satir.append(int(toplam))
            
        yeni_resim.append(yeni_satir)
            
    return yeni_resim

# DO_NOT_EDIT_ANYTHING_BELOW_THIS_LINE
f = open(inp_filename, "r")
img_matrix = read_imagefile(f)
f.close()

if operation == "misalign":
    img_matrix = misalign(img_matrix)

elif operation == "sort_columns":
    img_matrix = sort_columns(img_matrix)

elif operation == "sort_rows_border":
    img_matrix = sort_rows_border(img_matrix)

elif operation == "highpass":
    kernel = [
        [-1, -1, -1],
        [-1, 9, -1],
        [-1, -1, -1]
    ]
    img_matrix = convolution(img_matrix, kernel)

f = open(out_filename, "w")
write_imagefile(f, img_matrix)
f.close()
