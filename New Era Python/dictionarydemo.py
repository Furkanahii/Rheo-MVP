'''
ogrenciler = {
    "120" : {
        "ad": "Ali",
        "soyad": "Yılmaz",
        "telefon": "555-1234"
    },
    "121" : {
        "ad": "Ayşe",
        "soyad": "Demir",
        "telefon": "555-5678"
    },
    "122" : {
        "ad": "Mehmet",
        "soyad": "Kara",
        "telefon": "555-8765"
    }
}
1-Bilgileri verilen ogrencileri kullanicidan aldiginiz bilgilerle bir dictionary'e ekleyiniz.
2-Ogrenci numarasini kullanicidan alarak o ogrencinin bilgilerini ekrana yazdiriniz.

'''

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
print(ogrenciler)

sozluk = {"a": 1}
sozluk.update({"b": 2, "c": 3})  # b ve c anahtarları eklendi
print(sozluk)  # {'a': 1, 'b': 2, 'c': 3}

# var olan bir anahtarı günceller
sozluk.update({"a": 10})
print(sozluk)  # {'a': 10, 'b': 2, 'c': 3}



ogrNo = input("Ogrenci numarasini giriniz:")
ogrenci = ogrenciler[ogrNo]
print(ogrenci)