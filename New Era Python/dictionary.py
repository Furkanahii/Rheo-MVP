# key - value

# Boş bir sözlük:
sozluk = {}

# Bazı anahtar-değer çiftleriyle bir sözlük:
sozluk2 = {
    "anahtar1": "deger1",
    "anahtar2": 123,
    "anahtar3": [1, 2, 3],
}



sehirler = ["kocaeli", "istabul"]
plakalar = [41,34]
print("Kocaelinin plakasi: ", plakalar[sehirler.index("kocaeli")])

plakalar = { "kocaeli": 41, "istanbul": 34, "ankara": 6, "izmir": 35 }
print("Kocaelinin plakasi: " , plakalar["kocaeli"])

users = {
    "furkan": {
        "email": "furkanahi",
        "phone": "1343231",
        "age": 21
    },
    "amy": {
        "email": "amylee",
        "phone": "123456789",
        "age": 40
    }
}
print(users["furkan"]["email"])# Furkan'ın email adresini yazdırırprint(users["furkan"]["email"]) # Furkan'ın email adresini yazdırır