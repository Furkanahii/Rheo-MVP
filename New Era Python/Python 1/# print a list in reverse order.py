# print a list in reverse order 
ages = [23, 45, 12, 67, 34]
length = len(ages)
while length > 0:
    print(ages[length - 1])
    length -= 1

counter = 1 
while True:
    print(ages[-counter])
    counter += 1
    if counter > len(ages):
        break
