age = -1
isStudent = False
distance = -1.0
price = -1.0

with open("input.txt", "r", encoding="utf-8") as f:
    #1
    currentline = f.readline()
    age = int(currentline)
    #2
    currentline = f.readline()
    if currentline[0] == "Y":
        isStudent = True
    #3
    currentline = f.readline()
    distance = int(currentline)

#HOMEWORK STARTS BELOW

price = distance * 3

if age < 12 or age > 50:
    price = price * 0.5
elif isStudent:
    price = price * 0.75

if distance > 100:
    price = price * 0.9

#HOMEWORK ENDS NOW

with open("output.txt", "w", encoding="utf-8") as f:
    f.write(str(round(price,2)))
