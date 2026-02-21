#VERI YAPILARI

#Listeler (Degistirilebilir Farkli tipte verileri tutabilir Siralidir)
##1.  []
##2.  list()

notlar = [90,80,70,50]

liste = ['A',19.3,90]
listegenis = ['A',19.3,90, notlar]
len(listegenis)
type(listegenis[0])

tumListe = [ liste, listegenis]

#del tumListe

#Listeler - Eleman Islemleri
liste =[10,20,30,40,50]
liste[:2]
liste[2:]

yeniliste = ['a',10,[20,30,40,50]]
yeniliste[2][1] #listenin icindeki baska bir ifadeyi isterken 
 
#Listeler - Eleman Degistirme

liste = ['ali','veli','berkcan','ayse']
liste
liste[1] = 'velinin babasi'
liste

liste[1] = 'veli'
liste[0:3] = 'alininbabasi','velininbabasi','berkcaninbabasi' 

liste = ['ali','veli','berkcan','ayse']
liste

liste = liste + ['kemal']
liste

del liste[2]
liste

#Listeler - liste metodlari

liste = ['ali','veli','isik']
dir(liste)

#append
liste.append('berkcan')
liste
##append ile kalici ddegisiklik olur tekrardan atama yapmak gerekmez
#remove
liste.remove('berkcan')

#insert
liste = ['ali','veli','isik']
liste
#append() ile eklenen elemanlar oluşturulmuş dizinin sonuna geliyordu. 
#insert() metodu ile listenin istediğimiz yerine yeni elemanı ekleyebiliriz.

liste.insert(0,'ayse')
liste
liste = ['ali','veli','isik']
liste[0] = 'ayse'
liste

liste.insert(len(liste),'beren')
liste

#pop belirtilen bir indeks' deki elemanı silmek için pop() metodu kullanılır
liste.pop(0)
liste

#count
liste = ['ali','veli','isik','ali','veli']
liste.count('ali')

#copy
listeyedek = liste.copy() #yedekleme yapilmak istendiginde 

#extend

liste.extend(['a','b',10])
liste

#index()

liste.index('ali') #kacinci sirada oldugunu gosterir

#reverse()

liste.reverse() #sirayi terse cevirir
liste

#sort() siralama icin gereklidir

liste = [10,40,5,90]
liste.sort()
liste

#clear

liste.clear()
liste

#VERI YAPILARI - TUPLE degistirilemez

t = ('ali','veli',1,2,3.2,[1,2,3,4])
 
t = 'ali','veli',1,2,3.2,[1,2,3,4]

#tuple() kapsayicidir siralidir degistirilemez

t = ('eleman',) #tek eleman olunca sonuna virgul gelince tuple oldugunu anlar
type(t)

t[1]

t[2] = 99 #hata verir cunku tuple degistirilemez

#Veri Yapilari - Dictionary ( sirasizdir) index islemi yapilamaz

sozluk = {'reg' : 'regresyon modeli',
          'loj' : 'lojistik regresyon',
          'cart' : 'classification and reg'}
sozluk
del sozluk

sozluk = {'reg' : 10,
          'loj' : 20,
          'cart' : 30}
sozluk

sozluk[0] #sirasiz oldugu icin klasik index modeli calismaz
sozluk['reg']

sozluk = {'reg' : ['rmse',10],
          'loj' :['mse',20],
          'cart' : ['sse',30]}
sozluk['reg']
  
#Sozlukten eleman secme
sozluk = {'reg' : {'rmse':10,
                   'mse' :20,
                   'sse' :30},
          
          'loj' : {'rmse' : 10,
                   'mse' :20,
                   'sse' : 30},
         
          'cart' : {'rmse' : 10,
                    'mse' : 20,
                    'sse' : 30}}
          
sozluk 
sozluk['reg']['sse']

#Sozluk - Eleman Eklemek - Degistirmek

sozluk = {'reg' : 'regresyon modeli',
          'loj' : 'lojistik regresyon',
          'cart' : 'classification and reg'}

sozluk['gbm'] = 'Gradient Boosting Mac'
sozluk 

sozluk['reg'] = 'Coklu Dogrusal Regresyon'
sozluk

sozluk[1] = 'Yapay Sinir Aglari'
sozluk

#key degerleri sadece sabit tiple yazilabilir bu yuzden liste kullanilamaz

l = [1]
l

sozluk[l] = 'yeni bir sey'


#VERI YAPILARI-SETLER

##setler:Sirasizdir
         Degerleri essizdir  
         Degistirilebilir
         Farkli tipleri barindirabilir
    
s = set()
s

l = [1,'a','ali',123]
s = set(l)
s

ali = 'lutfenatabakmaaliuzayagit'
s = set(ali)
s

l = ['ali','lutfen','ata','bakma','uzaya','git','git','ali','git']
l
s = set(l)
s

s[0] #gecersiz cunku setler sirasiz index islemleri yapilamaz

#Eleman ekleme/cikarma 

l = ['gelecegi','yazanlar']

s = set(l)
s

dir(s)

s.add('ile')
s

s.add('gelecegegit')
s
#her ifade tek bir defa yazilir(essizdir)

s.remove('ali')
s

#hata uretmemesi kod akisini bozmamasi icin discard kullanilir 

s.discard('ali')
s
#Setler Klasik Kume Islemleri

# =============================================================================
# difference() ile iki kumenin farkini ya da'-' ifadesi
# intersection() iki kumenin kesisimi ya da'&' ifadesi
# union() iki kumenin birlesimi
# symmetric_difference() ikisinde de olmayanlari
# =============================================================================

#difference 

set1 = set([1,3,5])
set2 = set([1,2,3])

set1.difference(set2) sonuc suslu parantezde cikar{}

set1 - set2

set1.symmetric_difference(set2)
set2.symmetric_difference(set1)

#intersection

set1.intersection(set2)

set1 & set2

#union

birlesim = set1.union(set2)
birlesim

set1.intersection_update(set2)
set1
#degerin set1 e kaydolmasi icin update kodu kullanilir 

#Setlerde Sorgu İşlemleri

set1 = set([7,8,9])
set2 = set([5,6,7,8,9,10])

#iki kumenin bos olup olmadigini sorgulanmasi

set1.isdisjoint(set2)

#bir kumenin butun elemanlarinin baska bir kume icerisinde yer alip almadigini

set1.issubset(set2) #bir kumenin digerinin alt kumesi olup olmadigini sorgular 

#bir kumenin bir diger kumeyi kapsayip kapsamadigini 

set2.issuperset(set1)


süslü parantezler {sözlük};

köşeli parantezler [tuple];

normal parantezler (liste);




