my_list = [1, 2, 3, 4, 5]
my_list2 = ["bir",2,True,3.14]
print(my_list)
print(my_list2)

list1 = ["one, two ,three"]
list2 = ["four", "five", "six"]

numbers = list1 + list2  # Listeleri birleştirir
print(numbers)  # Birleştirilmiş listeyi yazdırır
print(len(numbers))  # Birleştirilmiş listenin uzunluğunu yazdırır
print(numbers[2])  # 2. indeksteki öğeyi yazdırır
 
userA = ["Furkan", "Ahi", 21]
userB = ["Amy","Lee",40]
users = [userA, userB]  # Kullanıcı listelerini birleştirir
print(users[0])
print(users[1][0])  # İkinci kullanıcının adını yazdırır
