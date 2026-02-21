name = "Sadik Turan"

#continue o satiri atlayip donguyu yazdirmaya devam eder 
for letter in name:
    if letter == "i":
        continue 
    print(letter)

#break donguden direkt cikar 
for letter in name:
    if letter == "i":
        break 
    print(letter)

# 0 ve 1
x = 0 
while x < 5:
    if x == 2:
        break
    print(x)
    x+=1


x = 0 
while x < 5:
    x+=1
    if x == 2:
        continue
    print(x)


x = 1
result = 0
while x<=100:
    x+=1
    if x % 2 == 1:
        continue
    result += x
print(f"toplam: {result}")