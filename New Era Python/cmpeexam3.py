a = [1,2,3,4,5,6]
sum = 0 
for x in a:
    if x % 2 == 0:
        sum += 1 
print(sum)

b = [0,1,0,2,3,0,0]
total = 0
for x in b:
    if x == 0:
        total += 1 
print(total)

c = [5, 2, 8, 1, 9]
minvalue = c[0]
for x in c:
    if x < minvalue:
        minvalue = x
print(minvalue)

d = [3,-2,5,-8,0]
sum = 0
for x in d:
    if x > 0:
        sum += x
print(sum)

e =  [1,2,3,4]
list=[]
for x in range(len(e),0,-1):
    list.append(x)
print(list)

f = [1,3,6,8,9] 
list=[]
for x in f:
    if x % 3==0:
        list.append(x)
print(list)    

g = [2,3,4] 
total = 1
for x in g:
    total *= x
print(total)

h =[3,-2,5,-8,0]
list=[]
for x in h:
    if x > 0:
        list.append(x)
    elif x<=0:
        x = 0
        list.append(x)
print(list)

i = [4,5,6,7,8]
list=[]
for x in i:
    if x % 2 ==0:
        i = int(x/2)
        list.append(i)
    else:
        list.append(x)
print(list)

'''#Q32  Print numbers until total reaches 10
j = [2,3,4,5,1]
sum=0
i=0
list=[]

while i<len(j) and sum <10:
        sum += j[i]
        list.append(j[i])
        if sum >=10:
            break
        i +=1
print(list)'''

k = [4,5,7,3,2]
total = 0 
i = 0
list=[]
while i< len(k) and total < 15:
        total += k[i]
        list.append(k[i])
        if total >15:
            break
        i+=1
print(list)

##Medium

l =[2,4,6,8,10]
sum = 0
count=0
for x in l:
    sum += x
avg = sum/len(l)
for x in l:
    if x > avg:
        count +=1 
print(count)

m = [1,2,3,4] 
sum = 0 
list = []
for x in m:
    sum += x
    list.append(sum)
print(list)

n = [1,3,2,4,6,5]
list = []
for x in range(1,len(n)-1):
    if n[x-1]<n[x] and n[x]>n[x+1]:
        list.append(n[x])
print(list)

#Guzel soru Q10 – Remove consecutive duplicates
o=[1,1,2,2,2,3,1,1]
list1 = []
list1.append(o[0])
for x in range(0,len(o)-1):
    if o[x] == o[x+1]:
        continue
    else:
        list1.append(o[x+1])
print(list1)

p=[2,2,3,1,5,4,6]
list1 = []
max_value = p[0]
list1.append(max_value)
for x in range(0,len(p)-1):
    if p[x+1]<= max_value:
        continue
    else:
        max_value = p[x+1]
        list1.append(max_value)
print(list1)

r = [0,1,0,3,12]
list1 = []
zero_counter=0
for x in range(0,len(r)):
    if r[x] == 0:
        zero_counter+=1
    else:
        list1.append(r[x])
list1.extend([0]*zero_counter) #listem.extend([4, 5]) $\rightarrow$ [1, 2, 3, 4, 5]
print(list1)

s = [1,2,2,3,4,1] 
count=1
max_count=1
for x in range(0,len(s)-1):
    if s[x]<s[x+1]:
        count+=1
        max_count = count
    elif s[x]>=s[x+1]:
        count=1
print(max_count)

#Cumulative product Guzel Soru

t =[2,3,0,4,5,0,2] 
list = []
product=1
for x in t:
    if x==0:
        list.append(product)
        product=1 
    else:
        product*=x
if t[-1]!= 0:
    list.append(product)
print(list)
#alternative solution
def cumulative_product(nums):
    product=1
    list = []
    for x in t:
        if x == 0:
            list.append(product)
            product=1
        else:
            product *= x
    if nums[-1] != 0:
        list.append(product)
    return list 
print(cumulative_product([2,3,0,4,5,0,2]))

#Baya guzel soru 
def running_minmax(u):
    list1=[]
    list2=[]
    minval=u[0]
    maxval=u[0]
    for x in u:
        if x<minval:
            minval = x
            list1.append(minval)
        else:
            list1.append(minval)
    for y in u:
        if y>maxval:
            maxval = y
            list2.append(maxval)
        else:
            list2.append(maxval)
    return list1,list2
print(running_minmax([5,2,7,1,6]))

def rotate_list(v, k):
    list1 = []
    n = len(v)
    
    for i in range(n - k, n):
        list1.append(v[i])

    for i in range(0, n - k):
        list1.append(v[i])

    return list1
print(rotate_list([1, 2, 3, 4, 5], 2))

def interleave(y,z):
    list1 = []
    minvalue = min(len(y),len(z))
    
    for i in range(minvalue):
        list1.append(y[i])
        list1.append(z[i])
    return list1

print(interleave([1,2,3],['a','b']))


def clockwise(k,l,m):
    result=[]
    for a in range(0,len(k)):
        result.append(k[a])
    result.append(l[-1])
    for c in range(len(m)-1,-1,-1):
        result.append(m[c]) 
    result.append(l[0])   
    return result
print(clockwise([1,2,3],[4,5,6],[7,8,9]))  

def localmin(a):
    count = 0
    for x in range(1,len(a)-1):
        if a[x]< a[x-1] and a[x]<a[x+1]:
            count+=1
    return count
print(localmin([3,2,4,1,5,0,6]))


"""def increasesub(b):
    length=1
    maxlength=1
    for x in range(0,len(b)-1):
        if b[x]<b[x+1]:
            length+=1
            if length>maxlength:
                maxlength = length
        else:
            length=1
    return maxlength
print(increasesub([10,9,2,5,3,7,101,18]))"""
#Guzel soru 
def tripletzero(c):
    list1 = []
    for x in range(0,len(c)):
        for y in range(x+1,len(c)):
            for z in range(y+1,len(c)):
                if c[x]+c[y]+c[z] == 0:
                    triplet = sorted([c[x], c[y], c[z]])
                    if triplet not in list1:   
                        list1.append(triplet)
    return list1
print(tripletzero([-1, 0, 1, 2, -1, -4]))

#Guzel soru 
def leaderelement(d):
    list1 = []
    for x in range(0,len(d)):
        for y in range(x+1,len(d)):
            if d[x]<=d[y]:
                break
        else:
            list1.append(d[x]) 
    return list1
print(leaderelement([16,17,4,3,5,2]))


def invertdict(e):
    outdict=dict()
    for key,val in e.items():
        for x in val:
            if x not in outdict:
                outdict[x]=[key]
            else:
                outdict[x].append(key)
    return outdict
print(invertdict({'A': [1, 2], 'B': [2, 3]}))

        
def combinedict(f):
    dict1 = {}
    for x in f:
        for key,val in x.items():
            if key not in dict1:
                dict1[key]=val
            else:
                # dict1[key]+=[val] Listeye ekleme (örnek: {'a':[1,3]})
                dict1[key]+=val
    return dict1
print(combinedict([{'a': 1, 'b': 2}, {'a': 3, 'c': 5}, {'b': 4}]))

def flattennested(g, parent_key=""):
    dict1 = {}

    for key, value in g.items():
        if parent_key:
            new_key = parent_key + "." + key
        else:
            new_key = key

        if isinstance(value, dict):  # iç içe sözlük varsa içine gir
            inner = flattennested(value, new_key)
            for k, v in inner.items():
                dict1[k] = v        # alt anahtarları ekle
        else:
            dict1[new_key] = value  # değilse direkt ekle
    
    return dict1

print(flattennested({'a': {'b': {'c': 3}}, 'd': 4}))

def two_sum(nums,target):
    list=[]
    for x in range(len(nums)):
        for y in range(x+1,len(nums)):
            if nums[x]+nums[y]==target:
                list.append([x,y])
            else:
                continue
    return list
print(two_sum([2,7,11,15],9))
                
#Alternative dict ile

def two_sum(nums, target):
    seen = {}
    for i in range(len(nums)):
        needed = target - nums[i]
        if needed in seen:
            return [seen[needed,i]]
        seen[nums[i]] = i
    return []

#bir daha bak
text =  "Hi"
def new_func(text):
    print(f"{text:*^10}")

new_func(text)

def array(row,column):
    outerlist = []
    for i in range(row):
        innerlist = []
        for j in range(column):
            k = i*j
            innerlist.append(k)
        outerlist.append(innerlist)
    return outerlist
print(array(3,4))

#A harfi yazma 


          












    

