def sayHello(name):
    print("Hello " + name)

sayHello("Furkan")


def kare(x):
    return x * x

def kare_yaz(x):
    print(x * x)

print(kare(3))       # 9
print(kare_yaz(3))   # 9, sonra None çünkü return yok

'''
🔍 return Ne İşe Yarar?
Fonksiyon sonucunu dışarı verir.

Fonksiyonu orada durdurur (return’den sonraki kodlar çalışmaz).

Değerin türü her şey olabilir: sayı, liste, string, tuple, sözlük, başka bir fonksiyon sonucu, vs.
'''

#Temel Yapi
def topla(a, b):
    return a + b

sonuc = topla(3, 5)
print(sonuc)  # 8


def topla(a,b):
    return a+b
total=topla(10,40)
print(total)


def YasHesapla(dogumyili):
    return 2025-dogumyili

def EmekliligeKacYilKaldi(dogumyili,isim):
    yas = YasHesapla(dogumyili)
    emeklilik = 65-yas
    if emeklilik>0:
        print(f"Emekliliginize {emeklilik} yil kaldi")
    else:
        ("Zaten emekli oldunuz")

EmekliligeKacYilKaldi(1985,"Ali")


help(list.append)#istedigin elemanin nasil kullanilidgini aciklayan kod


def mesajli_islem(x):
    def kare_al(n):
        return n * n

    def kok_al(n):
        return abs(n) ** 0.5

    if x >= 0:
        return kare_al(x)
    else:
        return kok_al(x)

print(mesajli_islem(5))   # Pozitif sayı bulundu. → 25
print(mesajli_islem(-16)) # Negatif sayı bulundu. → 4.0

