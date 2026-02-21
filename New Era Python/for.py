numbers = [1,2,3,4,5]

for a in numbers:
    print(a)

names = ["amy","furkan"]

for a in names:
    print(f"My names is {a}")

name = "Sadik turan"

for n in name:
    print(n)
#Her eleman bir dizi elemani gibi gozukur
 
tuple = [(1,2),(1,3),(3,5),(5,7)]

for a,b in tuple:
    print(a,b)

d = {"k1":1,"k2":2,"k3":3}
for item in d:
    print(item) #Sadece key degerelerini yazar


#Eger value da isteniyorsa 
for item in d.items():
    print(item)

for key,value in d.items():
    print(key,value) 