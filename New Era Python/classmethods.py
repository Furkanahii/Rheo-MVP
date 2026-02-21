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

    #instance methods
    def intro(self):
        print("Hello there. I am " + self.name)
    
    def calculateage(self):
        return 2019 - self.year
#object(instance)   
p1 = Person(name = "ali",year = 1992)
p2 = Person(name = "ayse",year = 1996)

p1.intro()   #p1.intro() → aslında Python bunu şuna çevirir: Person.intro(p1)Yani self otomatik olarak p1 nesnesinin kendisi olur.
p2.intro()

print(f"yasim: {p1.calculateage()}")
print(f"yasim: {p2.calculateage()}")




class Circle:
    #Class object attribute 
    pi = 3.14

    def __init__(self,yaricap=1):
        self.yaricap = yaricap   #bu nesneye özel yarıçap bilgisini tutar (instance attribute).

    #Methods 
    def cevrehesapla(self):
        return 2 * self.pi * self.yaricap
    
    def alanhesapla(self):
        return self.pi * (self.yaricap**2)
    
c1 = Circle() #yaricap = 1
c2 = Circle(5)

print(f"c1 : alan = {c1.alanhesapla()} cevre = {c1.cevrehesapla()}")
print(f"c2 : alan = {c2.alanhesapla()} cevre = {c2.cevrehesapla()}")











