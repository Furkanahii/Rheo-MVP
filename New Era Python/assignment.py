x,y,z = 5, 10, 15
x,y = y,x # x ve y'nin değerlerini takas etme
print(x, y, z)  


x = x+5
x += 5  # x'in değerini 5 artırma
print(x)  # 20

values = 1,2,3,4,5 # Tuple oluşturma
print(values)  # (1, 2, 3)
print(type(values))  # <class 'tuple'>

x,y,*z = values  #burda *z, kalan değerleri alır
print(x, y, z)  
print(x,y,z[1]) # 1, 2, 4
print(type(z))  # <class 'list'>, çünkü kalan değerler liste olarak saklanır
