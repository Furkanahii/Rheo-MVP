#"Bmw,Mercedes,Opel,Mazda elemanlarina sahip bir liste olusturun"
#Liste kac elemanli?
# Listenin ilk ve son elemanini yazdirin

# Mazda degerini Toyota ile degistirin
#Mercedes listenin bir elemani mi?
#Listenin son 2 elemani yerine "To yota" ve "Renault" degerlerini ekleyin
#Listenin uzerine "Audi" ve "Nissan" degerlerini ekleyin
#Listenin son elemanini silin
#Liste elemanlarini terse cevirin

mylist = ["Bmw", "Mercedes", "Opel", "Mazda"]
print["Liste eleman sayisi: ",]

print("Liste eleman sayisi: ", len(mylist))

print("Ilk eleman: ", mylist[0])
print("Son eleman: ", mylist[-1])

print("Mazda degeri degisti: ",mylist.replace("Mazda","Toyota"))

print("Mercedes listenin bir elemani mi?: ", "Mercedes" in mylist) # in operatörü ile kontrol ediliyor.Listelerde find() metodu kullanilamaz.

mylist[-2:] = ["Toyota", "Renault"]  # Listenin son iki elemanını değiştiriyoruz
print("Son iki eleman degisti: ", mylist)

lastlist = mylist + ["Audi", "Nissan"]  # Listenin üzerine yeni elemanlar ekliyoruz
print("Listeye yeni elemanlar eklendi: ", lastlist)

del lastlist[-1]  # Listenin son elemanını siliyoruz

mylist[::-1]  # Liste elemanlarını ters çeviriyoruz
print("Liste elemanlari ters cevrildi: ", mylist[::-1]) 