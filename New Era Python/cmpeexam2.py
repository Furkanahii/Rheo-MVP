l = [3,2,1]
ret = l.sort()  # YERİNDE sıralar, geri dönüşü None
print('l:', l)      # [1,2,3]
print('ret:', ret)  # None

l = [3,2,1]
ret = sorted(l)     # YENİ liste döndürür, orijinali bozmaz
print('l:', l)      # [3,2,1]
print('ret:', ret)  # [1,2,3]

#list.sort() → in-place (yerinde) sıralar, None döndürür.
#sorted(l) → yeni bir sıralı liste döndürür, l değişmez. 

def my_sorted(l):
  tmp = l.copy()
  tmp.sort()
  return tmp

my_l = [3,2,1]
ret = my_sorted(my_l)
print('my_l:', my_l)  # orijinal bozulmadı
print('ret:', ret)    # yeni sıralı liste


def my_sorted(l):
    l.sort()
    return l


def my_sorted(l):
    tmp = l.copy()
    tmp.sort()
    return tmp

my_l = [3,2,1]
ret = my_sorted(my_l)
print('my_l:', my_l) #[3,2,1]
print('ret:', ret) #[1,2,3]

def my_sorted(l):
    l.sort()
    return l
my_l = [3,2,1]
ret = my_sorted(my_l)
print(my_l)  #[1,2,3]
print(ret)   #[1,2,3]

#Fonksiyon içindeki değişken dışarıdan görünmez.
def new_sum(x,y):
  ret = x+y     # ret yerel değişkendir
  return ret

new_sum(3,4) 
print(x)        # HATA! NameError: name 'x' is not defined


x = 10
y = 20
def f():
  ret = x + y  # ← Python bu x'i “yerel” sayar çünkü aşağıda x’e atama var
  x = 50       # yerel x'e atama UnboundLocalError: cannot access local variable 'x' where it is not associated with a value
  return

x = 30
f()
print(x)

def f():
  global x
  global y
  z = x + y   # global x ve y kullanılıyor
  x = 50      # global x'i DEĞİŞTİRİYORUZ
  return

y = 10
x = 30
f() #globali 50 ye donusturdu
print(x)      # 50


d = {'a':10,'b':20,'c':30}
for (k,v) in sorted(d.items()):  #items: hem anahtara hem değere aynı anda erişmek isteriz.
   print(k,v)

l = list() 
for ((v,k)) in d.items():
  l.append((k,v))

#lazy evaluation 
print((1,2) < (2,'3')) #True sadece ilk elemanlari kiyaslar 
print((1,2) < (1,'3')) #ilk eleman ayni ikinci elemanlara gecer orda da TypeError verir

d = {'a':10,'b':20,'c':30}
for k in d.keys():
   print(k)
print(list(d.keys()))

for v in d.values():
   print(v)
print(list(d.values))


print(d['b']) # b yoksa hata (KeyError) verir.
print(d.get('b') ) # hata vermez, sadece None döndürür

print(d['x'])         # hata verir çünkü 'x' yok
print(d.get('x', 2))  # hata vermez, 2 döndürür

d['a']=80  #a yi degistirir
print(d)

d['e']=100 #e ekler 
print(d)

#Shallow Copy (yüzeysel kopya)
d = {'a':60, 'b':20, 'c': 40}
e = d  #yeni bir kopya oluşturmazsın.Sadece aynı sözlüğe iki farklı isim (referans) verirsin.
e['a'] = 80
print('d:',d) #d: {'a': 80, 'b': 20, 'c': 40}
print('e:',e) #e: {'a': 80, 'b': 20, 'c': 40}

#Explicit Copy (elle kopyalama)

d1= {"a":40,"b":20,"c":30}
d2= dict()
for k,v in d1.items():
   d2[k] = v
print(d2)
   
#kisa yolu 
d2 = d1.copy
d2 = dict(d1)

#En sık geçen kelimeleri bulma
text='Academic Integrity Procedure against Cheating Behavior Definitions  Cheating includes Academic Integrity Integrity'
text = text.lower()
n=5
word_list = text.split()
word_count_dict = dict()
for word in word_list:
   word = word.strip(",") #her kelime için:strip(',.;') ile noktalama işaretlerini temizler.
   word = word.strip(';')
   word = word.strip('.')
   word_count_dict[word] = word_count_dict.get(word,0)+ 1 

count_word_list = list()
for word,count in word_count_dict.items():
   count_word_list.append((count,word))
count_word_list.sort(reverse=True) #Reverse sayesinde buyukten kucuge siralanir.
print(count_word_list[:n])

# given a text, find the n most common letter
text='Academic Integrity Procedure against Cheating Behavior Definitions  Cheating includes Academic Integrity Integrity'
text = text.lower()
n = 10

word_count_dict = dict()
for c in text:
   if "a"<= c <= "z":
      word_count_dict[c] = word_count_dict.get(c,0) + 1 
count_word_list= []
for word,count in word_count_dict.items():
   count_word_list.append((count,word))
count_word_list.sort(reverse=True)
print(count_word_list[0:n])

# write a function, given a string, detect whether the string is composed of only vowels
# ioaeEEio: True
# oisaj: False

vowels='aeiou'
def is_only_vowels(s):
   s = s.lower()
   for c in s:
      if c in vowels:
         continue
      else:
         return False
   return True
print(is_only_vowels('ioaeEEio'))
print(is_only_vowels('ioaeEXEio'))

#Alternative solution:
vowels='aeiou'
def is_only_vowels(s):
  s = s.lower()
  for c in s:
    if not (c in vowels): # c not in vowels
      return False
  return True
print(is_only_vowels('ioaeEEio'))
print(is_only_vowels('ioaeEXEio'))

# Alternative solution2:
vowels='aeiou'
def is_vowel(c):
  return c in vowels

def is_only_consonents(s):
  s = s.lower()
  for c in s:
    if is_vowel(c):
      return False
  return True

print(is_only_consonents('xbxbbs'))
print(is_only_consonents('xbOxbbs'))

# list comprehension 
l1 = [] 
for i in range(5): 
  l1.append(i*10) 
print(l1) 

l2 = [i*10 for i in range(5)] 
print(l2)

m = [[1,2],[3,4]]
l = list()
for row in m: #Dış döngü: her satırı (row) dolaşır → [1,2], sonra [3,4]
  for item in row: #İç döngü: her satırdaki elemanları (item) dolaşır → 1, 2, 3, 4
    l.append(item)
print(l)

l2 = [item for row in m for item in row]
print(l2)

'''[expression for item in iterable if condition]'''
# expression → oluşturmak istediğin değer (örneğin i*10, x.upper(), (x,y), vs.)
# for item in iterable → hangi değerler üzerinde dolaşacağını belirtir
# (opsiyonel) if condition → filtre eklemek istersen kullanılır

nums = [i+10 for i in range(10) if i % 2 == 0]

# all letters are non-zero and different from each other
def solve():
  for O in range(1,10):
    for R in range(1,10):
      if R==O: continue
      for X1 in range(2):
        if 2*O!=R+10*X1: continue
        for W in range(1,10):
          if W==R or W==O: continue
          for U in range(1,10):
            if U==W or U==R or U==O: continue
            for X2 in range(2):
              if 2*W+X1!=U+10*X2: continue
              for T in range(1,10):
                if T==U or T==W or T==R or T==O: continue
                for F in range(2):
                  if F==T or F==U or F==W or F==R or F==O: continue
                  if 2*T+X2==O+10*F:
                    print(' ',T,W,O)
                    print(' ',T,W,O)
                    print('+-------')
                    print(F,O,U,R)
                    return
solve()

#join()
ll = ['a','b','c','d'] 
print("-.-".join(ll)) #join bir liste içindeki stringleri tek bir string hâline getirir.

#combine_dics()
#Combine a list of dictionaries by summing values for the same keys.
ll = [{'a': 1, 'b': 2}, {'a': 3, 'c': 5}, {'b': 4}]
def combine_dics(ll):
  out_dict = dict()
  for dd in ll: #her sozlugu sirayla al 
    for key,val in dd.items(): #her anahtar deger cifti
      out_dict[key] = out_dict.get(key,0) +val
  return out_dict
print(combine_dics(ll))

#flatten_dict()

dd={'a': {'b': {'c': 3}}, 'd': 4}
def flatten_dict(input_dict):
  out_dict = dict()
  d0=input_dict
  for key0,val0 in d0.items():
    if type(val0)!=type(dict()):
      out_dict[key0]=val0
    else:
      d1=val0
      for key1,val1 in d1.items():
        if type(val1)!=type(dict()):
          out_dict[key0 + "."+ key1] = val1
        else:
          d2=val1
          for key2,val2 in d2.items():
              out_dict[key0 + "."+ key1+ "." + key2] = val2
  return out_dict
print(flatten_dict({'a': {'b': {'c': 3, 'f':6}}, 'd': 4}))

'''
#Build Adjacency Dictionary
#From edge list [('A', 'B'), ('B', 'C'), ('A', 'C')] → {'A': ['B', 'C'], 'B': ['C'], 'C': []}

def build_adj_dict(ll):
  adj_dict=dict()
  all_nodes=dict()
  for node1,node2 in ll:
    all_nodes[node2] = True
    adj_dict[node1] = adj_dict.get(node1,[]) + [node2]
  for node in all_nodes.key():
    if node not in adj_dict.keys():
      adj_dict[node] = []
  return adj_dict
'''

#Matrix to Dictionary: Given matrix

mm = [[1,2],
      [3,4],
      [5,6]]
def mat_to_dict(mm):
  out_dict = dict()
  for r in range(len(mm)):
    for c in range(len(m[0])):
      out_dict[(r,c)] = mm[r][c]
  return out_dict
print(mat_to_dict(mm))

##Spiral order traversal of matrix Return elements of a 2D grid in spiral order.
#Input: [[1,2,3],[4,5,6],[7,8,9]] → Output: [1,2,3,6,9,8,7,4,5]

def spiral_order_traverse(mm):
    ll = list()  # Çıktı listesi (spiral sıra)
    stage = 1    # 1: sağa, 2: aşağı, 3: sola, 4: yukarı
    
    # Başlangıç sınırları
    c_min, r_min = 0, 1
    c_max, r_max = len(mm[0]) - 1, len(mm) - 1
    
    # Başlangıç pozisyonu
    r, c = 0, 0
    
    # Toplam eleman sayısı
    n_elements = len(mm) * len(mm[0])
    
    # Tüm elemanlar toplanana kadar dön
    while len(ll) < n_elements:
        ll.append(mm[r][c])  # mevcut elemanı listeye ekle
        
        if stage == 1:  # sağa git
            if c < c_max:
                c += 1
            else:
                stage = 2
                c_max -= 1
                r += 1
                
        elif stage == 2:  # aşağı git
            if r < r_max:
                r += 1
            else:
                stage = 3
                r_max -= 1
                c -= 1
                
        elif stage == 3:  # sola git
            if c > c_min:
                c -= 1
            else:
                stage = 4
                c_min += 1
                r -= 1
                
        else:  # stage == 4, yukarı git
            if r > r_min:
                r -= 1
            else:
                stage = 1
                r_min += 1
                c += 1
                
    return ll