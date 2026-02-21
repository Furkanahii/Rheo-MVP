#1-100 e kadar 

x = 1
while x <= 100:
    if x % 2 ==1:
        print(f"sayi tek: {x}")
    else:
        print(f"sayi cift: {x}")
    x += 1 
    
print("bitti...")


name = "" #False
while not name.strip(): #bosluk karakterini arindirmak icin
    name = input("isminizi giriniz: ")
print(f"Merhaba, {name}") 

i = 100
while i > 0 :
    print(i)
    i -= 1  
   
