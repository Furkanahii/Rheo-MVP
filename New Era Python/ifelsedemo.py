#Kullanicidan isim,yas ve egitim bilgilerini alip ehliyet alabilir mi kontrolu yapiniz.Ehliyet almak icin yas en az 18 ve egitim en az lise ya da universite olmalidir.

isim = input("Isminizi giriniz: ")
yas = int(input("Yasinizi giriniz: "))
egitim = input("Egitim durumunuzu giriniz (ilkokul/lise/universite): ").lower()
ehliyet_alabilir = (yas >= 18) and (egitim in ["lise", "universite"])
if ehliyet_alabilir:
    print(f"{isim}, ehliyet alabilirsiniz.")
else:
    print(f"{isim}, ehliyet alamazsiniz. Yeterli yas ve egitim seviyeniz yok.")

#Bir ogrencinin 2 yazili bir sozlu notunu alip hesaplanan ortalamaya gore not araligini belirleyiniz.
yazili1 = float(input("Birinci yazili notunu giriniz: "))
yazili2 = float(input("Ikinci yazili notunu giriniz: "))
sozlu = float(input("Sozlu notunu giriniz: "))
ortalama = (yazili1 + yazili2) / 2 * 0.6 + sozlu * 0.4

if ortalama <25:
    not_araligi = "FF"
elif 25 <= ortalama < 45:
    not_araligi = "DD"
elif 45 <= ortalama < 55:
    not_araligi = "CC"
elif 55 <= ortalama < 70:
    not_araligi = "BB"
elif 70 <= ortalama < 85:
    not_araligi = "AA"
else:
    not_araligi = "AA+"
print(f"Ogrenicinin not araligi: {not_araligi} (Ortalama: {ortalama})")

#Trafige cikis tarihi alinan bir aracin servis zamanini hesaplayiniz.
#1.bakim 1 yil sonra
#2.bakim 2 yil sonra
##3.bakim 3 yil sonra
#Sure hesabini alinan gun ay yil bilgisine gore yapiniz.
#** datetime modulu ile tarih hesaplamalari yapilabilir.

days = int(input("Aracin trafiğe çıkış tarihinden itibaren geçen gün sayısını giriniz: "))
if days <= 365:
    print("1. Bakım zamanı geldi.")
elif 365 <= days < 730:
    print("2. Bakım zamanı geldi.")
elif 730 <= days < 1095:
    print("3. Bakım zamanı geldi.")
else:
    print("Aracınızın bakımı 3 yıldan fazla süre geçmiş. Lütfen servise götürün.")
