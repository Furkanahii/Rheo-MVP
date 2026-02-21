# Identity Operator : is

x = y= [1, 2, 3]
z = [1, 2, 3]

print(x == y)  # True, çünkü x ve y'nin içeriği aynı
print(x == z)  # True, çünkü x ve z'nin içeriği aynı

print(x is y)  # True, çünkü x ve y aynı nesneyi referans alıyor
print(x is z)  # False, çünkü x ve z farklı nesneleri referans alıyor


# Membership Operator : in

x = ["apple", "banana",]
print("apple" in x)  # True, çünkü "apple" x listesinde var

name = "Furkan"
print("F" in name)  # True, çünkü "F" name stringinde var
print
