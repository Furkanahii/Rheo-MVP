l1 = [0,2,4]
l2 = []
for i in l1:
    l2.append(i)
print(l2)

l =["ali","Ali","0li",".li","#li"]
l.sort()
print(l)

#Ord() karakterin sayisal karsiligini verir 
print(ord("A"))
print(ord("0"))
print(ord("!"))

#Chr() sayiyi karaktere cevirir
print(chr(65))
print(chr(97))
print(chr(33))

x = input("Give me a letter,I will find the next: ")
print(chr(ord(x)+1))

l=[1,2,3,4,5,6,7,8,9]
for e in l:
    print("check",e)
    if e>=5:
        break
    if e %2==0:
        print(e)
print("All numbers are printed")

#range() bitis dahil degil 

print(range(10))
print(list(range(-5,10,3)))

l = [0,1,2]
for x in range(len(l)):
    print(x)
    l.append(3)

sum=0
for x in range(10,100,2):
    sum= sum+x
print(sum)


product=1
for x in range(10,100,2)
product = product * x
print(product)

n = int(input("give me n: "))
for j in range(n):
    for i in range(n):
        print("x",end="")
    print()

n = int(input("give me n:"))
for row in range(n): #satir sayisini ayarlar 
    m = n - row  #kac tane x yazilacagini gosterir 
    for i in range(m): #kac tane x yazilacagini belirliyor/ i sadece sayac 
        print("x",end="")
    print() #alt satira gecmeyi saglar 

n = int(input("give me n:"))
for row in range(n):
    m = n - row 
    s = row  #her satirda soldaki bosluk sayisi 
    for i in range(s):
        print(' ',end="")
    for i in range(m):
        print("x",end="")
    print()