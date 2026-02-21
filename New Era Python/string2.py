name = "Furkan"
surname = "Ahi"
age = 21

greeting = ("My name is " + name + " " + surname + " and \nI am " + str(age) + " years old.")
length = len(greeting)
print(greeting)
print(greeting[0])
print(greeting[len(greeting) - 1])  # Son karakteri yazdırır
print(greeting[3:5]) # 3. ve 4. karakterleri yazdırır
print(greeting[3:])  # 3. karakterden sonrasını yazdırır
print(greeting[5:10:2])  # 5. karakterden başlayarak 2'şer atlayarak 10. karaktere kadar yazdırır


# \n ifadesi, yazdırma işlemi sırasında yeni bir satıra geçilmesini sağlar.
