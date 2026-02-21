#Value type da adresin sadece bir kopyasi cikarilir

# n = "ada" satırı:
#Sadece n adlı yeni bir değişken "ada"yı göstermeye başlar
#Ama name dışarıda hâlâ "yigit" olarak kalır

def changeName(n):
    n = "ada"
    print(n)

name = "yigit"
changeName(name)
print(name)

#n ve sehirler aslında aynı listeyi gösterir (aynı referans)
#n[0] = "istanbul" → listenin ilk elemanı değiştirilir
#Bu, doğrudan orijinal listeyi etkiler

def change(n):
    n[0] = "istanbul"
sehirler = ["ankara","izmir"]
change(sehirler)
print(sehirler)

#n = sehirler[:]
#Bu ifade, sehirler listesinin yeni bir kopyasını oluşturur.

def change(n):
    n[0] = "istanbul"
sehirler = ["ankara","izmir"]
print(sehirler)


sehirler = ["ankara","izmir"]
n = sehirler[:]
n[0]="istanbul"
print(sehirler)  #➡️ ['ankara', 'izmir']
print(n)         #➡️ ['istanbul', 'izmir']



'''
Eğer Değiştirilebilir (mutable) bir tür olsaydı?
Örneğin bir liste gönderilseydi, davranış farklı olurdu:
 
def changeList(l):
    l[0] = 999

numbers = [1, 2, 3]
changeList(numbers)
print(numbers)  # [999, 2, 3]

Çünkü list mutable’dır ve fonksiyon içinde yapılan değişiklik orijinal listeyi etkiler.
'''

def add(a,b):
    return sum((a,b))
print(add(10,20))

def add(*params):
    print(params) #tuple listesi olarak yazdirir 
    return sum((params)) #toplamlari olarak yazdirilir
print(add(10,50) )
print(add(10,20,30,40,50,60))

# *params → Python’a “istediğin kadar argüman alabilirim” demektir.
def add(*params):
    print(type(params))
    total=0
    for n in params:
        total = total + n
    return total

def displayuser(**args):
    print(type(args))
    for key,value in args.items():    #for key, value in args.items(): Ne Yapar? “Sözlükteki her bir anahtar-değer çiftini sırayla al, anahtarı key değişkenine, değeri value değişkenine ata.
        print("{} is {} ".format(key,value))

displayuser(name = "Cinar", age=2, city= "istanbul")
displayuser(name = "Ada", age=12, city= "kocaeli")
displayuser(name = "Yigit", age=22, city= "ankara")

#**args Nedir?
#**args (genelde **kwargs diye yazılır), fonksiyona key = value formatında değişken sayıda argüman almasını sağlar.
#Bu argümanlar otomatik olarak bir sözlük (dict) haline gelir.