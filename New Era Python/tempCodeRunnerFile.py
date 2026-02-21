urunler = []
adet = int(input("Kac tane urun eklemek istiyorsunuz: "))
i = 0
while i < adet:
    name = input("Urun ismi: ")
    price = int(input("Urunun fiyati nedir: "))
    urunler.append({
        "name": name,
        "price": price
    })
    i += 1