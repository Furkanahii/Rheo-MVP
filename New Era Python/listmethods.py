numbers = [1, 2, 3, 4, 5]

def list_methods():
    # 1. append() - Listenin sonuna bir öğe ekler
    numbers.append(6)
    print("After append:", numbers)

    # 2. extend() - Bir listeyi başka bir liste ile genişletir
    numbers.extend([7, 8])
    print("After extend:", numbers)

    # 3. insert() - Belirli bir indekse öğe ekler
    numbers.insert(3, 0)
    print("After insert:", numbers)

    # 4. remove() - Belirtilen öğeyi listeden kaldırır
    numbers.remove(4)
    print("After remove:", numbers)

    # 5. pop() - Belirtilen indeksteki öğeyi kaldırır (varsayılan olarak son öğeyi)
    last_item = numbers.pop()
    print("After pop:", numbers, "Removed item:", last_item)        

    # 6. clear() - Tüm listeyi temizler
    numbers.clear()
    print("After clear:", numbers)

    # 7. index() - Belirtilen öğenin indeksini döndürür
    numbers = [1, 2, 3, 4, 5]
    index_of_three = numbers.index(3)
    print("Index of 3:", index_of_three)

    # 8. count() - Belirtilen öğenin sayısını döndürür
    count_of_two = numbers.count(2)
    print("Count of 2:", count_of_two)

    # 9. sort() - Listeyi sıralar
    numbers.sort()
    print("After sort:", numbers)

    # 10. reverse() - Listeyi tersine çevirir
    numbers.reverse()
    print("After reverse:", numbers)