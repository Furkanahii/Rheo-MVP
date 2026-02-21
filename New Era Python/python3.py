#Fonksiyonlara giris ve fonksiyon okuryazarligi

print('a','b', sep = '_', end = '-')
#?print
 
len('a')

#Matematiksel Islemler
# =============================================================================
4*4
3**2
# =============================================================================

#Fonksiyon Nasil Yazilir?

def kare_al(x):
    print(x**2)

kare_al(5)

#Bilgi notuyla cikti uretmek

def kare_al(x):
    print('Girilen Sayinin Karesi:' + str(x**2))
        
kare_al(5)

#string ifade ile sadece string ifade birlestirilebilir

#Iki Argumanli Fonksiyon Tanimlamak

def carpma_yap(x, y):
    print(x*y)
 
carpma_yap(2,5)
    
#Ön Tanımlı Argümanlar

def carpma_yap(x, y = 2):
    print(x*y)
carpma_yap(3,5)

#Ne Zaman Fonksiyon Yazılır?

isi,nem,sarj 

40 25 90 

def direkt_hesap(isi, nem, sarj):
    print((isi + nem)/sarj) 
   
cikti = direkt_hesap(20, 40, 70)

#Fonksiyonun ciktisi direkt girdi olarak kullanilamaz

def direkt_hesap(isi, nem, sarj):
    return ((isi + nem)/sarj) 
cikti = direkt_hesap(25, 40, 70)
cikti
print(cikti)
direkt_hesap(25,40,70)*9
 

#fonksiyon return ifadesine gelince durur

#Local ve Global Değişkenler
x= 10
y= 20

def carpmayap(x=2,y=5):
    return (x*y)
carpmayap(2,4)

#Local Etki Alanından Global Etki Alanını Değiştirmek

x = [] #global etki alani

def elemanekle(y):
    x.append(y)
    print( str(y) + ' ifadesi eklendi')
#once local alandaki degiskenleri arar eger bulamazsa globalde o degeri bulur 

elemanekle('ali')
elemanekle('veli')
x
 
#True-False Sorgulamaları

sinir=5000

sinir==4000

5 == 5

#İf Yapısı

sinir=50000
gelir=40000

gelir < sinir

#else


if gelir > sinir:
    print('Gelir sinirdan kucuk')

else:
    print('Gelir sinirdan buyuk')

#elif

sinir=50000
gelir1=60000
gelir2=50000
gelir3=35000

if gelir > sinir:
    print('Gelir sinirdan kucuk')
elif gelir < sinir:
    print('Uyari!')
else:
    print('Gelir sinirdan buyuk')  


#miniuygulama

sinir = 50000
magazaadi = input('Magaza adi nedir?')
gelir = int(input('Gelirinizi Giriniz:'))

if gelir > sinir:
    print('Tebrikler' + magazaadi + ' promosyon kazandiniz')
elif gelir < sinir:
    print('Uyari! Cok dusuk gelir:' + str(gelir))
else:
    print('Takibe Devam')

#Donguler - for
 
ogrenci = ['ali','veli','isik','berke']

ogrenci[0]
ogrenci[1]

for i in ogrenci:
    print(i + str(' ahi'))


#fonksiyon ve donusum birlikte yazmak 

#maaslara yuzde 20 zam yapilacak gerekli kodlari yaziniz

maaslar = [1000,2000,3000,4000,5000]

def yenimaas(x):
    print(x)

yenimaas(4)

def yenimaas(x):
    print(x*20/100 + x)

for i in maaslar:
     yenimaas(i)

#if for ve fonksiyonlari bir arada kullanmak

maaslar = [1000,2000,3000,4000,5000]

sinir = 3000

def maasust(x):
    print(x*10/100 + x)
def maasalt(x):
    print(x*20/100 + x)
    
for maas in maaslar:
    if maas >= 3000:
        maasust(maas)
    else:
        maasalt(maas)
        
#break/continue

maaslar = [8000,5000,1000,2000,3000,4000,5000]

maaslar.sort()
maaslar

for i in maaslar:
    if i == 3000:
        print('kesildi')
        break
    print(i)

for i in maaslar:
    if i == 3000:
       continue
    print(i)     #degeri atlamak icin kullanilir  

#while

sayi = 1

while sayi < 10:
    sayi += 1
    print(sayi)





def ismin_ne():
    isim = input("ismin ne? ")
    print(isim)
ismin_ne()

def ismin_ne():
    isim = input("ismin ne? ")
    return isim
ismin_ne()

##return deyimini kullandığınız satırdan sonra gelen hiçbir kod çalışmaz

##fonksiyonun tek işlevi kullanıcıdan aldığı isim bilgisini ekrana basmaktır. Aldığınız bu veriyi başka yerlerde kullanamazsınız. Bu fonksiyonu çağırdığınız anda kullanıcıya ismi sorulacak ve alınan cevap ekrana basılacaktır. Ancak siz, tanımladığınız fonksiyonların tek görevinin bir veriyi ekrana basmak olmasını istemeyebilirsiniz.

#Örneğin yukarıdaki fonksiyon yardımıyla kullanıcıdan ismini aldıktan sonra, bu isim bilgisini başka bir karakter dizisi içinde kullanmak isteyebilirsiniz

def ismin_ne():
    isim = input("ismin ne? ")
    print(isim)

print("Merhaba {}. Nasılsın?".format(ismin_ne()))

def ismin_ne():
    isim = input("ismin ne? ")
    return isim

print("Merhaba {}. Nasılsın?".format(ismin_ne()))


a = [2,4,6,8]
for i in a:
    print(i**2)





