# Cenk ismini listenin sonuna ekleyin
# Sena ismini listenin basina ekleyin
# Deniz ismini listeden siliniz
#Deniz isminin indeksi nedir?
#Ali listenin bir elemani mi?
#listenin elemanlarini ters ceviriniz
# listenin elemanlarini alfabetik siraya gore siralayiniz
#years listesini kucukten buyuge siralayiniz
# str = "Chevrolet,Dacia" karakter dizisini listeye ceviriniz
#years dizisinin en buyuk ve en kucuk degerlerini yazdiriniz
#years dizisinde kac tane 1998 degeri var?
#years dizisinin tum elemanlarini siliniz
#Kullanicidan alacaginiz 3 tane marka bilgisini bir listeye ekleyiniz

names = ["Ali","Yagmur","Hakan","Deniz"]
years = [1998,2000,1998,1987]

print("Cenk ismini ekle: " , names.append("Cenk"))
print(names)

print("Sena ismini basa ekle: " , names.insert(0,"Sena"))
print(names)

names.remove("Deniz")
print(names)

deniz_index = names.index("Deniz")
print(deniz_index)
      
print("ali listenin bir elemani mi?:  ", "Ali" in names)

names.reverse()
print("Elemanlarin tersi: ", names)

names.sort()
years.sort()

stringvalues = "Chevrolet,Dacia"
car_list = stringvalues.split(",")
print("Listeye cevirildi: ", car_list)

min = min(years)
max = max(years)
print(min, max)

result = years.count(1998)
print("1998 degeri sayisi: ", result)

years.clear()

markalar = []
marka = input("Marka: ")
markalar.append(marka)
print(markalar)
 

