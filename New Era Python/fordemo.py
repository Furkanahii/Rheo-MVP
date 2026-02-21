sayilar = [1,3,5,7,9,12,19,21]
#Sayilar listesindeki hangi sayilar 3 un katidir
for a in sayilar:
    if a % 3 == 0 :
        print(f"{a} 3 un katlari")


#Sayilar listesindeki sayilarin toplami kactir
sum = 0 
for b in sayilar:
    sum += b
print("toplam: ",sum)
#Sayilar listesindeki tek sayilarin karesini aliniz

for c in sayilar:
    if (c % 2 == 1):
        istenilen= c**2 
    print("kareleri: ",istenilen)


sehirler = ["kocaeli","istanbul","ankara","izmir","rize"]

#Sehirlerden hangileri en fazla bes karakterlidir

for d in sehirler:
    if (len(d) <= 5):
        print(d)

urunler = [
    {"name": "samsung S6", "price": "3000"},
    {"name": "samsung S7", "price": "4000"},
    {"name": "samsung S8", "price": "5000"},
    {"name": "samsung S9", "price": "6000"},
    {"name": "samsung S10", "price": "7000"}
]
#Urunlerin fiyatlari toplami nedir?
toplam = 0
for urun in urunler:
    fiyat = int(urun["price"])
    toplam += fiyat
print("sum: ",toplam)

#Urunlerden fiyati en fazla 5000 olan urunleri gosteriniz

for urun2 in urunler:
    name2 = str(urun2["name"])
    if int(urun2["price"]) <= 5000:
        print(f"{name2} fiyatlari 5000 veya 5000 den azdir")


