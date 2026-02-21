#class

class Person:
    pass #hatayi engeller
    #class attributes (tum nensneler icin ortak bir bilgidir)
    address = "no information"
    #constructor(yapici method)
    def __init__(self,name,year):
        #object attributes
        self.name = name
        self.year = year 
        print("init methodu calisti.")

        #methods

#object(instance)
p1 = Person(name = "ali",year = 1992)
p2 = Person(name = "ayse",year = 1996)
#updating
p1.name = "ahmet"
p1.address = "kocaeli"
#accessing object attributes
print(f"p1:name : {p1.name} year : {p1.year} address :{p1.address}")
print(f"p2:name : {p2.name} year : {p2.year} address :{p2.address}")

print(type(p1))
print(type(p2))

'''
class Araba:  # Sınıf (class) tanımı
    marka = "Bilinmiyor"

# Nesne (instance) oluşturuyoruz
araba1 = Araba()
araba2 = Araba()

# Değer atayalım
araba1.marka = "Toyota"
araba2.marka = "BMW"

print(araba1.marka)  # Toyota
print(araba2.marka)  # BMW

'''


'''
class Araba:
    teker_sayisi = 4  # class attribute

    def __init__(self, marka, renk):
        self.marka = marka      # instance attribute
        self.renk = renk        # instance attribute

# Nesne oluştur
araba1 = Araba("Toyota", "Kırmızı")
araba2 = Araba("BMW", "Siyah")

print(araba1.marka)  # Toyota
print(araba2.renk)   # Siyah
print(araba1.teker_sayisi)  # 4 (class özelliği)

'''