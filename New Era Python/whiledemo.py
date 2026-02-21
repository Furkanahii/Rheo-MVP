sayilar = [1,3,5,7,9,12,19,21]

#Sayilar listesini while ile ekrana yazdirin

i = 0
while i <len(sayilar):
    print(sayilar[i])
    i += 1

#Baslangic ve bitis degerlerini kullanicidan alip aradaki tum sayilari ekrana yazdirin

baslangic = int(input("Baslangic degeri: "))
bitis = int(input("Bitis degeri: "))

i = baslangic
while i< bitis:
    print([i])
    i +=1


#Kullanicidan alacaginiz 5 sayiyi ekrana sirali bir sekilde yazdirin
numbers = []

i = 0
while i < 5:
    sayi = int(input("Sayı: "))
    numbers.append(sayi)
    i += 1
numbers.sort()

print("Sıralı liste:", numbers)

#Kullanicidan alacaginiz sinirsiz urun bilgisini urunler listesinde
  #urun sayisini kullaniciya sorunuz 
  #dictionary listesi yapisi (name,price), seklinde olsun
  #urun ekleme islemi bittiginde urunleri ekranda while ile 
urunler = []
adet = int(input("Kac tane urun eklemek istiyorsunuz: "))
i = 0
while i < adet:
    name = input("Urun ismi: ")
    price = int(input("Urunun fiyati nedir: "))
    urunler.append({
        "name": name,
        "price": price
    })
    i += 1
for urun in urunler:
    print(f"urun adi: {urun['name']} urun fiyati: {urun['price']}")


