#value types => string,number 

x = 5 
y = 25

x = y 

y = 50

print(x,y) 

print(x)  # 25
print(y)  # 50
# x değişkeni artık y'nin değerini tutuyor, bu yüzden x'in değeri 25 oldu.

#reference types => list

a = ["banana", "apple", "orange"]
b = ["kiwi", "grape", "mango"]
a = b  # a artık b'nin referansını tutuyor
b[0] = "pear"  # b'nin ilk öğesini değiştiriyoruz

print(a)  # ["pear", "grape", "mango"]
print(b)  # ["pear", "grape", "mango"]
# a ve b artık aynı listeyi referans alıyor, bu yüzden her ikisi de "pear", "grape", "mango" olarak güncelleniyor.