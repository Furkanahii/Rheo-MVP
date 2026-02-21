#Dictionary Methods

#1- values()
users = {0:"Mario",1:"Luigi",2:"James"}
print(users.values())

#2-keys()
users = {0:"Mario",1:"Luigi",2:"James"}
print(users.keys())

#3-pop()
users = {0:"Mario",1:"Luigi",2:"James"}
print(users.pop(2))
print(users) 

#4-popitem()
users = {0:"Mario",1:"Luigi",2:"James"}
users.popitem()
users.popitem()
users.popitem()

#5-copy()
sample_dict = {0:["a","b"], 1:["c","d"]}
my_copy = sample_dict.copy()
print(id(sample_dict))
print(id(my_copy))

my_copy[0][0]="???"
print(my_copy)

#6-get()
users = {0:"Mario",1:"Luigi",2:"James"}
print(users.get(0))
print(users.get(3,"Missing"))

#7-setdefault()
users = {0:"Mario",1:"Luigi",2:"James"}
print(users.setdefault(0))
print(users.setdefault(3,"Sean"))
print(users)

#8-items()
users = {0:"Mario",1:"Luigi",2:"James"}
print(users.items()) 

#9-update()
users = {0:"Mario",1:"Luigi",2:"James"}
users.update({2:"Bob",3:'James\'s sister'})
print(users)

#dictionary = {key: expression for (key,value) in iterable}
cities_1 = {"New York":32, "Boston":75,"Los angeles":100,"Chicago":50}
cities_2 = {key:((value-32)*(5/9)) for (key,value) in cities_1.items()}
print(cities_2)