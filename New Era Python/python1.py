#SAYILAR VE STRINGLERE GIRIS
print('hello ai era')
type(9) #int = tam sayi
type(9.4) #float = ondalikli sayi
type('hello ai era') #string = karakter dizisi
type(True) #bool = dogru yanlis degerleri

x, y, z = 1, 2.5, False #birden fazla degisken tanimlama

#STRING
'123'
type('123')

'a' + 'b'
'a' + ' b'
'a '*3

#STRING METHODLARI - LEN (Fonksiyonlar)

fahi = 'gelecegi yazanlar'
gelyaz = ' gelecegi yazanlar '
#del fahi

len(gelyaz)

#STRING METHODLARI - upper() lower()
gelyaz.upper() #tum harfleri buyutur
gelyaz.lower() #tum harfleri kucutur

gelyaz.islower() #buyuk mu kucuk mu oldugunu dogru yanli olarak gosterir 
B = gelyaz.upper()
B.islower()

#STRING METHODLARI - replace()

gelyaz.replace('e','a')

#STRING METHODLARI - strip()
gelyaz = 'gelecegi yazanlar '
gelyaz.strip(' ')
#.strip() metodu, bir Python dizesinin başındaki ve sonundaki boşlukları satır sonu karakterlerini ( boşluk, yıldız ve istemediğimiz hangi karakter var ise ) ve belirtilen diğer karakterleri kaldırır.

#Metodlara genel bakis
dir(gelyaz)
gelyaz.capitalize() #ilk ifadeyi buyuk yapar 
gelyaz.title() #her kelimenin bas harfini buyutur
gelyaz.splitlines() #yan ayraclar koyar 
gelyaz.rstrip() #stringin sagindan yani sonundan silem islemi yapar 

#SUBSTRINGLER 
gelyaz[0]

gelyaz[0:3] #sona istedigin index in 1 fazlasini koyman lazim(-e kadar anlaminda)

#Tip Donusumleri

## input = kullanicidan bilgi almak icin kullanilir 
birincisayi = input()
ikincisayi = input()

birincisayi + ikincisayi
int(birincisayi) + int(ikincisayi)

int(11.0)
float(5) #ondalikli sayilar 
str(12) #herhangi bir dizi tirnak ile gosterilir 
type(str(12))

#print()

print('gelecegi','yazanlar')
print('gelecegi','yazanlar',sep = '_') #fonksiyonlarin genel amacini bicimlendirmek icin kullanilan belirteclere arguman denir

print()


"_Python_".strip('_')



