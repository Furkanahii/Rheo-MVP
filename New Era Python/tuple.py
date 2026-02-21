list [1,2,3]
tuple = (1,"iki",3)

print(type(list))
print(type(tuple))

print(list[2])
print(tuple[2])  # Tuple'dan 2. indeksteki öğeyi yazdırır

print(len(list))  # Listenin uzunluğunu yazdırır
print(len(tuple))  # Tuple'ın uzunluğunu yazdırır

list = ["ali", "veli", "ayşe"]
tuple = ("ali", "veli", "ayşe")

list[0] = "ahmet"  # Listenin ilk öğesini değiştirir
tuple[0] = "ahmet"  # Tuple'da değişiklik yapmaya çalışır, hata verecektir.Tuple'lar değiştirilemez (immutable) 

d = {'a':10,'c':30}
print(d['b'])
print(d.get('b'))

print(d['x'])         # hata verir çünkü 'x' yok
print(d.get('x', 0)) 

d['a']=80
print(d)
d['e']=100
print(d)