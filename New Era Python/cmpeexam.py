#Listedeki en kucuk sayiyi bulma
numbers = 10,20,34,4,5,67,8,9
min = numbers[0]
for n in numbers:
    if n < min:
        min =n
print("Min:",min)

#Max degeri bulma

numbers = 10,20,34,4,5,67,8,9
max = numbers[0]
for n in numbers:
    if n > max:
        max =n
print("Max:",max)

#Compute Average of list with for sum
numbers = 10,20,34,4,5,67,8,9
total = 0
for i in numbers:
    total += i 
avaragelist = total / len(numbers)
print("Avarage: " ,avaragelist)

#Sayiyi bilme oyunu

chosen_number = 33 
guess_counter = 0

while(True):
    guessnumber=int(input("Give me number"))
    guess_counter += 1 
    if guessnumber == chosen_number:
        print(f"{guess_counter}.hakkinizda {chosen_number} sayisini bildiniz")
        break
    elif guessnumber < chosen_number:
        print("Try a higher number!")  
    else:
        print("Try a lower number!")

#Verilen bir sayı için aşağıdaki kuralları kullanarak, o sayının 1’e ulaşması için kaç adım gerektiğini yazin

count = 0
guessnumber = int(input("Give me number: "))

while guessnumber != 1:               
    count += 1                        
    if guessnumber % 2 == 0:          
        guessnumber = guessnumber // 2
    else:                             
        guessnumber = guessnumber * 3 + 1

print(f"{count} adimda 1'e ulaşıldı.")

#Listedeki ciftleri yazdirma 
list1=[]
numbers = [1,2,3,4,5,6,7,8,9,10]
for i in numbers:
    if i % 2 == 0:
        list1.append(i)
print("Cift sayilar: ",list1)

#Elemanlari tersten yazdirma
list2=[]
numbers = [1,2,3,4,5,6,7,8,9,10]
for i in numbers[::-1]:
    list2.append(i)
print("Tersten sayilar: ",list2)

#EX-3 Compute Range of the list(max)-(min)

numbers = [11,2,34,4,5,65,7,28,59,10]
minvalue = 1000
maxvalue = -1000
for i in numbers:
    if i < minvalue:
        minvalue = i
    if i > maxvalue:
        maxvalue = i
rangelist = maxvalue - minvalue
print(rangelist)

#Make a new list of same elements but in order as, odds first, evens latter
oddlist = []
evenlist = []
numbers = [11,2,34,4,5,65,7,28,59,10]

for i in numbers:
    if i % 2 == 0:
        evenlist.append(i)
    else:
        oddlist.append(i)
total = oddlist + evenlist
print(total)

#Given an integer n, print the number of its positive divisors, including 1 and n itself.A positive divisor of n is a positive integer d such that n % d == 0.
x = 14
count = 0
for i in range(1,x+1):
    if x % i == 0:
        count += 1 
output = count 

#Maximum even number
numbers = [11,2,34,4,5,65,7,28,59,10]
maxeven = numbers[0]
for i in numbers:
    if i > maxeven and i % 2 == 0:
        maxeven = i
print(maxeven)

#Total cift sayilar 
numbers = [11,2,34,4,5,65,7,28,59,10]
evenlist = []
total = 0
for i in numbers:
    if i % 2 == 0:
        evenlist.append(i)
for a in evenlist:
    total += a
output = total

#Elmasli ornek 

# n diamonds
n = int(input('n:'))
for i in range(n):
  # each dimond:
  n_rows = (n-1)//2
  # upper triangle:
  for row_index in range(n_rows):
    n_s = (n-1)//2 - row_index
    n_x = (row_index*2)+1
    for j in range(n_s):
      print(' ',end='')
    for j in range(n_x):
      print('x',end='')
    print()
  # middle part
  for j in range(n):
    print('x',end='')
  print()
  # lower triangle
  for row_index in range(n_rows):
    n_s = row_index +1
    n_x = n-(row_index+1)*2
    for j in range(n_s):
      print(' ',end='')
    for j in range(n_x):
      print('x',end='')
    print()

x = [1,[2],[[4]],[[[5]]]]



# print out min, max and avg of entered integers read ints one by one (until non-int), print largest value

minvalue = 0
maxvalue = 0
number=0
total = 0
firsttime = True

while (True):
    s = input("Enter: ")
    try:
        val = int(s)
    except:
        break
    
    if firsttime:
        maxvalue = val
        minvalue = val
        number = 1 
        total = val
        first_time = False
    else:
        if val > maxvalue:
            maxvalue = val
        if val < maxvalue:
            maxvalue = val
        total += val
        number +=1 
if firsttime:
    print('you did not enter any number!')
else:
    print("max,min,avarage",maxvalue,minvalue,total/number)



max_val = 0
first_time = True
while(True):
  s = input('Enter: ')
  try:
    val = int(s)
  except:
    break
  if first_time:
    max_val = val
    first_time = False
  else:
    if val>max_val:
      max_val = val

if first_time:
  print('you did not enter any number!')
else:
  print(max_val)






# read ints one by one (until non-int), print largest value
max_val = 0
first_time = True

while(True):
    s = input("Enter")
    try:
        val = int(s)
    except:
       break
    if first_time:
       max_val = val
       first_time = False
    else:
       if max_val < val:
          max_val = val
print("Max value:",max_val)
          

# read ints from user, if non-int, output the sum
total = 0
firsttime = True
while(True):
    s = input("give me int number")
    try:
      val = int(s)
    except:
      break
    if firsttime:
       total = val
       firsttime = False
    else:
       total += val
print("Toplam:",total)


# while <bool-expr>:
#    <stat1>
#    <stat1>
#    <stat1>
# continue or break

list=[]
x = 20 
while x>=0:
   if x % 3 == 0:
      list.append(x)
   x = x-1 


n = int(input("n: "))

for row in range(1,n+1):
   for col in range(row):
      print("x",end="")
   print()

#Jump Game 

nums = [2, 3, 1, 1, 4]

n = len(nums)
jumps = 0
end = 0         # Şu anki zıplamanın ulaşabildiği en uzak nokta
farthest = 0    # Bu menzilde ulaşabileceğimiz en uzak nokta

i = 0
while i < n - 1:            # son elemana gelmeden
    farthest = max(farthest, i + nums[i])  # en uzağı güncelle
    if i == end:            # menzilin sonuna geldikse
        jumps += 1
        end = farthest      # yeni menzili başlat
        if end >= n - 1:    # son elemana ulaşabiliyorsak bitir
            break
    i += 1

print("Minimum jumps:", jumps)

#Count and say

n= int(input("Kac adim girilecek: "))
count = 1 
term = '1' 

while count < n:
   nextterm = ""
   i=0
   while i <len(term):
      currenterm = term[i]
      runlength = 1 
      for j in range(i +1,len(term)):
         if term[j] == currenterm:
            runlength += 1 
         else:
              break
      nextterm += str(runlength) + currenterm
      i += runlength
   term = nextterm 
   count += 1 
print(term) 

#Pascal triangle

triangle = []
numrows = int(input("Kaç satır? "))

for i in range(numrows):
    row = []
    for c in range(0, i + 1):
        if c == 0 or c == i:
            row.append(1)
        else:
            y = triangle[i-1][c-1] + triangle[i-1][c]
            row.append(y)
    triangle.append(row)

print(triangle)

#Duplicates items:

a = [10, 20, 30, 20, 10, 50, 60, 40, 80, 50, 40]
uniqueitems=[]

for x in a:
   if x not in uniqueitems:
      uniqueitems.append(x)
print(uniqueitems)

#Kullanıcıdan bir sayı al (n).n’den başlayarak 0’a kadar olan sayıları tersten yazdır ve sadece çift sayıları listeye ekle.
list=[]
n = int(input(("Give me number: ")))
for i in range(n, -1, -1):
   if i % 2 == 0:
      list.append(i)
print(list)

#Listenin max-min farkını (range) bul ve yazdır. Yani range = max - min.

nums = [11, 2, 34, 4, 5, 65, 7, 28, 59, 10]
minvalue = 1000
maxvalue = -1000

for i in nums:
   if maxvalue < i:
      maxvalue = i 
for j in nums:
   if minvalue > j:
      minvalue = j 
range1 = maxvalue-minvalue
print(range1)

#Bir liste veriliyor: nums = [4, 7, 9, 12, 5, 8, 3] Listenin ortalamasından büyük olan sayıların sayısını bul.

nums = [4, 7, 9, 12, 5, 8, 3]
sum = 0
count = 0
for i in nums:
   sum += i 
x = sum/len(nums)
for j in nums:
   if j>x:
      count += 1 
print(count)
   
#Yana yatik bir ucgen oluştur:

row = int(input("Number of rows: "))

for i in range(1, row + 1):
    for j in range(1, i + 1):
        print("*", end="")
    print()

#1’den n’e kadar olan bir desen bastır: Ucgen biciminde

n = int(input("Give me number: "))

for i in range(1,n+1):
   for j in range(1,i+1):
      print(j,end="")
   print()

#“ters üçgen” desenini oluştur

n = int(input("Give me number: "))
for i in range(1,n+1):
   m = n-i+1 
   for j in range(m,0,-1):
      print("*",end="")
   print()

#Bir liste: nums = [10, 15, 20, 25, 30] Sadece 5’e bölünebilenleri -1 ile değiştir.Sonucu yazdır
list1 = []
nums = [10, 15, 24, 25, 30]

for i in nums:
   if i % 5 == 0:
      list1.append(-1)
   else:
      list1.append(i)

print(list1)

#Bir liste: nums = [3, 7, 9, 12, 8, 4, 10] Listedeki tüm çift sayıları çıkar (sil).

nums = [3, 7, 9, 12, 8, 4, 10]
new_nums = []

for i in nums:
   if i % 2 != 0:
      new_nums.append(i)

print(new_nums)

#Kullanıcıya rastgele 0–20 arasında gizli bir sayı belirle.Her tahminde “daha küçük” / “daha büyük” ipucu ver.Doğru bulunca kaç denemede bulduğunu yaz.
truevalue = 16
count = 0

while True:
    n = int(input("Give me number: "))
    count += 1
    if n == truevalue:
        print(f"{count}.hakkinizda dogru bildiniz")
        break
    elif n < truevalue:
        print("You should increase your number")
    else:
        print("You should decrease your number")
  
#Palindrome

name = input("Bir kelime giriniz: ")
isPalindrome = True

for index in range(len(name)//2):
   if name[index] != name[-(index+1)]:
      isPalindrome=False
      break
print(isPalindrome)

#Prime checking:

n = int((input("Give me a number: ")))
isPrime = True

for i in range(2,n):
   if n%i == 0:
      isPrime = False
      break
if isPrime:
    print("Prime number",n)
else:
     print("Not prime number",n)     

#nums vals degerlerini silmek 

nums = [2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6]
val = 3

i = 0
while i < len(nums):
    if nums[i] == val:
        nums.pop(i)   # elemanı sil
        # i artırma çünkü liste kaydı
    else:
        i += 1        # sadece val olmayanlarda ilerle

#Longest Substring Without Repeating Characters
s = "abcabcbb" 
window = [] 
maxlen = 0
for i in s:
   while i in window:
      window.pop[0]
      window.append(i)
      maxlen += 1 
   if len(window) > maxlen: 
      maxlen = len(window)
print(maxlen)

#Problem: Bir tamsayı dizisindeki tüm 0’ları sona taşı, sıfır olmayanların relative sırası bozulmasın.

nums = [0,1,0,3,12]
k=0 # sıfır olmayanların yerini takip eder

for i in range(len(nums)):
   if nums[i] != 0:
      nums[i]=nums[k]
      k+=1
for i in range(k,len(nums)):
   nums[i] = 0
print(nums)

#Problem: nums ve target veriliyor. nums[i] + nums[j] == target olacak herhangi bir (i, j) çifti bul ve döndür (indeks veya değer).    

nums = [1,2,4,6,7,10]
target = 9
list1 = []

for i in range(len(nums)):
   for j in range(i+1,len(nums)):
      if nums[i] + nums[j] == target:
        list1.append([i,j])
print(list1)

#Longest Run of Equal Characters
#sayac sifirlama mantigi devreye giriyor
s = "aaabbbbcc"
maxlen = 1

for i in range(0, len(s)):
    count = 1   # her i için sayacı sıfırla
    for j in range(i + 1, len(s)):    
        if s[i] == s[j]:
            count += 1
        else:
            break                     
    if count > maxlen:
        maxlen = count

print(maxlen)
 
#yana yatik ucgen:

n = int(input("Adim sayisini giriniz: "))

for row in range(1,n+1):
   for col in range(1,row+1):
      print("*",end="")
   print()
    
#Elmas cizme 

n = int(input("Adim sayisini giriniz: "))
rows = n //2 

for i in range(rows+1):
   for j in range(rows-i):
      print(" ",end="")
   for k in range(2*i+1):
      print("*",end="")

for i in range(rows-i-1):
   for j in range(rows-i-1):
      print(" ",end="")
   for k in range(rows+i-1):
      print("*", end="")
   print()
   
n = int(input("n: "))
rows = n // 2  # üst kısmın satır sayısı

# Üst üçgen
for i in range(rows + 1):
    for s in range(rows - i):   # boşluklar
        print(" ", end="")
    for star in range(2 * i + 1):  # yıldızlar
        print("*", end="")
    print()

# Alt üçgen
for i in range(rows - 1, -1, -1):
    for s in range(rows - i):
        print(" ", end="")
    for star in range(2 * i + 1):
        print("*", end="")
    print()
   
#Soru (LeetCode #53 tarzı):Bir liste veriliyor. İçindeki alt dizilerden (subarray) toplamı en büyük olanı bul.nums = [-2,1,-3,4,-1,2,1,-5,4] → maksimum toplam = 6(çünkü [4, -1, 2, 1]
 
nums = [-2,1,-3,4,-1,2,1,-5,4]
maxsum = nums[-2]
for i in range(0,len(nums)):
   count = 0
   for j in range(i,len(nums)):
      total= nums[i] + nums[j]
      if total > maxsum:
         total = maxsum
      else:
         total += nums[j]
   

nums = [-2,1,-3,4,-1,2,1,-5,4]
max_sum = nums[0]

for i in range(len(nums)):
    running = 0
    for j in range(i, len(nums)):
        running += nums[j]           
        if running > max_sum:      
            max_sum = running

print(max_sum)   
   
#Kac kelime oldugunu bulma:
n="saveChangesInTheEditor"
count = 1


for i in n:
   if i >= "A" and i<= "Z":
      count +=1
print(count)

#Soru (Hackerrank “Happy Number” mantığı):Bir sayıyı al, rakamlarının karelerinin toplamını tekrar tekrar al.Sonunda 1’e ulaşıyorsa “happy number”dır, ulaşmıyorsa değildir. n= 19 → 1²+9²=82 → 8²+2²=68 → 6²+8²=100 → 1²=1 ✅

n = int(input("Bir sayi giriniz: "))
sum = 0
for i in range(0,len(n)):
   sum += n[i]**2 
   if sum ==1:
      print("Happy number")

#String ile (index kullanarak)
n = 68
s = str(n)
total = 0
for ch in s:
    total += int(ch)
print(total)   

##Reading input as an integer x
import sys
if len(sys.argv) > 1:
    inPath = sys.argv[1]
    with open(inPath) as f:
        line = f.readline()
        x = int(line)
else:
    x = 20 #You can put any value here for trying

#initializing the output variable
output = -1
#-----------------YOUR SOLUTION BELOW----------------
count = 0
for i in range(1, n+1):
    if n % i == 0:
        count += 1
output = count

#-----------------YOUR SOLUTION ABOVE----------------
print(output)
#It is important that this code prints only 1 line, with this last statement

#Reading input as a list of integers
import sys
if len(sys.argv) > 1:
    inputList = []
    with open(sys.argv[1], "r") as file:
        line = file.readline()
        for element in line.split():
            inputList.append(int(element))
else:
    inputList = [1,2,3,4,5] #You can put any value here for trying

#initializing the output variable
output = -1
#-----------------YOUR SOLUTION BELOW----------------
maxeven = inputList[0]
for i in inputList:
   if i%2==0 and i > maxeven:
      maxeven=i
output=maxeven
   


#-----------------YOUR SOLUTION ABOVE----------------
print(output)
#It is important that this code prints only 1 line, with this last statement


#Reading input as a list of integers
import sys
if len(sys.argv) > 1:
    inputList = []
    with open(sys.argv[1], "r") as file:
        line = file.readline()
        for element in line.split():
            inputList.append(int(element))
else:
    inputList = [1,2,3,4,5] #You can put any value here for trying

#initializing the output variable
output = -1
#-----------------YOUR SOLUTION BELOW----------------
sum = 0
for i in inputList:
   if i % 2 == 0:
      sum += i
output = sum

#-----------------YOUR SOLUTION ABOVE----------------
print(output)
#It is important that this code prints only 1 line, with this last statement


#Sayi bilme oyunu:

guessnumber = 56
counter=0
isGuess = True

while isGuess:
   n = int(input("Give me number: "))
   counter+=1 
   if n == guessnumber:
      print(f"Tebrikler{counter}.adimda bildiniz")
      isGuess = False
      break
   elif n> guessnumber:
      print("You should decrease your guess")
   else:
      print("You should increase your guess")


#Kullanıcı, 5 sayılık bir liste içinde olup olmadığını bulmak için sürekli sayı girsin.Varsa “bulundu” desin, yoksa tekrar sorsun.

nums=[1,5,6,34,23]
isFound = True

while isFound:
    n = int(input("Give me number: "))
    for i in nums:
       if i == n:
          isFound=False
          print("Sayi bulundu")
      




