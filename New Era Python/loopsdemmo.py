"""
1-100 arasinda rastgele uretilecek bir sayiyi asagi yukari ifadeleri ile buldurmaya calisin
random modulu icin python randoom seklinde arama yapin
100 uzerinden puanlama yapin.Her soru icin 20 puan 
Hak bilgisi kullanicidan alin ve her soru belirtilen can sayisi uzerinden hesaplansin

"""

import random
sayi = random.randint(1,100)
hak = 5
sayac = 0

while hak>5:
    hak -=1
    sayac +=1
    tahmin = int(input("Sayi giriniz: "))

    if sayi == tahmin:
        print(f"Tebrikler {sayac}.defada sayiyi bildiniz.Toplam puaniniz: {100-(20)*(sayac-1)}")
        break
    elif sayi > tahmin:
        print("Yukari")
    else:
        print("Asagi")
    if hak==0: 
        print("Hakkiniz bitti")