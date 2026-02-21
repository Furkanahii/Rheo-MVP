#Gonderilen bir kelimeyi belirtilen kez ekranda gosteren fonksiyonu yazin

def yazdir(kelime,adet):
    print(kelime * adet)
yazdir("Merhaba\n" ,10)  #\n bir kaçış karakteridir ve "yeni satır" anlamına gelir.

def yazdir(kelime, adet):
    return kelime * adet

result = yazdir("Merhaba\n", 5)
print(result)

#Kendine gonderilen sinirsiz sayidaki parametreyi bir listeye cevir

def listeyecevir(*params):
    list = []
    
    for param in params:
        list.append(param)
    return list

result=listeyecevir(10,20,30,"Merhaba")
print(result)

#Gonderilen 2 sayi arasindaki tum asal sayilari bulun
sayi1 = int(input("Sayi1 : "))
sayi2 = int(input("Sayi2 : "))

def asalsayilar(sayi1, sayi2):
    for sayi in range(sayi1,sayi2):
        if sayi > 1:
            for i in range(2,sayi):
                if (sayi % i ==0):
                    break
            else:
                print(sayi)

asalsayilar(sayi1,sayi2)
'''
🔥 for-else → döngü kırılmazsa çalışır!

for i in range(...):
    if ...:
        break
else:
    # bu kısım sadece break olmazsa çalışır
Yani:
Eğer for döngüsü normal şekilde sona ererse (break olmadan) → else bloğu çalışır

Eğer break olursa → else çalışmaz
'''
#Kendisine gonderilen bir sayinin tam bolenlerini bir liste olarak yazdirin 

def tambolenleriBul(sayi):
    tambolenleri = []
    
    for i in range(2,sayi):
        if (sayi % i ==0):
            tambolenleri.append(i)
        
    return tambolenleri

print(tambolenleriBul(20))

'''
🧩 Karşılaştırılan Yapılar:
asalsayilar(...) fonksiyonu:

def asalsayilar(sayi1, sayi2):
    for sayi in range(sayi1,sayi2):
        if sayi > 1:
            for i in range(2,sayi):
                if (sayi % i == 0):
                    break
            else:
                print(sayi)

asalsayilar(10, 20)
Bu fonksiyonda:

Asal sayılar fonksiyonun içinde direkt print() ile yazdırılıyor.
Dışarı hiçbir veri dönmüyor (return yok).
Çağrıldığında ekrana yazıyor ama veriyi saklayamıyorsun, işlem yapamıyorsun.

tambolenleriBul(...) fonksiyonu:

def tambolenleriBul(sayi):
    tambolenleri = []
    for i in range(2, sayi):
        if sayi % i == 0:
            tambolenleri.append(i)
    return tambolenleri

print(tambolenleriBul(20))
Bu fonksiyonda:

print() fonksiyonun dışında var.
Fonksiyon içinde sadece veri hazırlanıyor ve return ile dışarı veriliyor.
Kullanıcı isterse yazdırır, ister başka bir yerde kullanır.
'''