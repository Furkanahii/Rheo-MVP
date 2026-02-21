#range
for item in range(50,100,20):
    print(item)

print(list(range(5,100,20)))

#enumerate

index = 0
greeting = "Hello"

for letter in greeting:
    print(f"index: {index} letter: {greeting[index]}")
    index +=1

greeting = "Hello"
for index, item in enumerate(greeting):
    print(f"index: {item} letter: {letter}")


#zip
list1 = [1,2,3,4,5] 
list2 = ["a","b","c","d","e"]
print(list(zip(list1,list2)))

for a,b in zip(list1,list2):
    print(a)