def changename(n):
    n = 'ada'
name= 'yigit'
changename(name)
print(name)
#value type 

def change(n):
    n[0] = 'istanbul'
sehirler = ['ankara','izmir']
change(sehirler)

change(sehirler[:])
print(sehirler)



def add(*params):
    * => tuple 
    sum = 0
    for n in params:
        sum = sum + n
    return sum
    
    ** => dictionary
    return sum((params))

def displayuser(**args)
    for key,value in args.items
    print('[] is []' format(key,value))
    


