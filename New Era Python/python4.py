#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 23 21:41:25 2024

@author: furkanahi
"""
#Sinif nedir?

class Veribilimi():
    print('Bu bir siniftir')

#Sinifin ozellikleri (Class attributes)

class Veribilimci():
    bolum = ''
    sql = ''
    deneyimyili = 0
    bildigidil = []

#Siniflarin ozelliklerine erismek
Veribilimci.bolum
Veribilimci.sql
#Siniflarin ozelliklerini degistirmek

Veribilimci.sql = 'Hayir'
Veribilimci.sql

#Sinif Orneklendirmesi (instatiation)

ali = Veribilimci()
ali.sql
ali.bolum

ali.bildigidil.append('Python')
ali.bildigidil

veli = Veribilimci()

#Ornek Ozellikleri 

class Veribilimci():
    bildigidil = ['R','Python']
    def __init__(self):
        self.bildigidil = []
        self.bolum = ''
ali = Veribilimci()
ali.bildigidil.append('python')
ali.bildigidil       

veli.bildigidil.append('Js')
veli.bildigidil

ali.bolum = 'istatistik'
Veribilimci.bolum

#Ornek Methodlari
     
class Veribilimci():
    calisanlar = []
    def __init__(self):
        self.bildigidil = []
        self.bolum = ''
    def dilekle(self,yenidil):
        self.bildigidil.append(yenidil)

ali.bildigidil
ali.dilekle('R')

#Miras Yapilari(inheritance)

class Employees():
    def __init__(self):
        self.FirstName = ''
        self.LastName = ''
        self.Address = ''

class DatasScience(Employees):
    def __init__(self):
        self.Programming = ''
        
class Marketing():
    def __init__(self):
        self.StoryTelling = ''

veribilimci1 = DatasScience()
veribilimci1.
     
#Yan etkisiz Fonksiyonlar(Pure Functions)

#Ornek 1 Bagimsizlik 

A = 9

def impure_sum(b):
    return b + A 
impure_sum(5)

def pure_sum(a,b):
    return a + b 

impure_sum(6)
pure_sum(4,7)
 
#Olumcul Yan etkiler
 

ogrenciler = {}

number = input("Öğrenci numarasını giriniz: ")
name = input("Öğrencinin adını giriniz: ")
surname = input("Öğrencinin soyadını giriniz: ")
phone = input("Öğrencinin telefon numarasını giriniz:")

#ogrenciler[number] = { 
#    "ad": name,
#    "soyad": surname,
#    "telefon": phone 
# }
#print(ogrenciler)

ogrenciler.update({
    number: {
        "ad": name,
        "soyad": surname,
        "telefon": phone
    }
})

email = "furkanahi6@gmail.com"
password = "abc12345"

girilen_email = input("Email adresinizi giriniz: ")
girilen_password = input("Parolanizi giriniz: ")

isEmail = (email == girilen_email.lower().strip()) # Email adresini küçük harfe çevir ve başındaki/sonundaki boşlukları kaldır
isPassword = (password == girilen_password.strip())  # Paroladaki başındaki/sonundaki boşlukları kaldır
print(f"Email kontrolu: {isEmail}, Parola kontrolu: {isPassword}")




a = int(input("Bir sayi giriniz: "))
print(f"Girilen sayi 0-100 arasinda mi? : 0 < {a} and {a} < 100")

a = int(input("Bir sayi giriniz: "))
result = (0 < a) and (a < 100)
print(f"Girilen sayi 0-100 arasinda mi? : {result}")
