fruits = {'orange', 'apple', 'banana', 'kiwi', 'grape'}

print(fruits)
#print(fruits[0])  # Set'ler sıralı değildir, bu nedenle indeksleme yapılamaz

for x in fruits:
    print(x) # Set elemanlarını döngü ile yazdırır

fruits.add('mango')  # Set'e yeni bir öğe ekler
print(fruits)
fruits.update(['pear', 'peach'])  # Set'e birden fazla öğe ekler

fruits.remove('banana')  # Set'ten bir öğe kaldırır
fruits.discard('kiwi')  # Set'ten bir öğe kaldırır, eğer öğe yoksa hata vermez
fruits.pop()  # Set'ten rastgele bir öğe kaldırır
fruits.clear()  # Set'i tamamen temizler, tüm öğeleri kaldırır

myList = [1,2,3,3,4,2,4,5,6]
print(set(myList))  # Listeyi sete dönüştürür, tekrar eden öğeleri kaldırır
print(fruits)  # Güncellenmiş set'i yazdırır
