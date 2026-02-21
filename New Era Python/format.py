name = "Simay"
surname = "Ahi"
print('My name is {} {}'.format(name,surname)) # format() metodu ile değişkeni ekler 
print('My name is {1} {0}'.format(name,surname))
print('My name is {n} {s}'.format(n=name,s=surname))

result = 500/700
print('the result is {r:5.6}'.format(r=result)) # 5.6 ifadesi, sonucu 5 basamak genişliğinde ve 6 ondalık basamakla yazdırır.
print(f'My name is {name} {surname}')  # f-string ile değişkeni ekler