website = "https://www.example.com"
course = "Python Programming"

# 1-  course karakteri dizisinde kac karakter var?
# 2-  website karakteri dizisinin www karakterini alin?
# 3-  website karakteri dizisinin com karakterini alin?
# 4-  course karakteri dizisinin ilk 15 ve son 15 karakterini alin?
# 5-  course ifadesindeki karakterleri tersten yaziniz 

print("1-Karakter sayisi: ", len(course))

print("2- www karakteri:",website[8:11])

print("3- com karakteri:", website[-3:])

print('4- Ilk 15 karakter:', course[:15])

print('4- Son 15 karakter:',course[-15:])

print("5-Tersten yazma: ", course[::-1])

name , surname , age , job = "Furkan", "Ahi", 21, "Software Engineer"

# 6- Yukaridaki degiskenleri kullanarak "Benim adim Furkan Ahi, 21 yasindayim ve Software Engineer olarak calisiyorum." ifadesini yazdiriniz
# 7 - "hello world" ifadesindeki w harfini W olarak     degistiriniz.
#8- "abc" ifadesini yan yana 3 kez yazdiriniz.

print("Ifade: Benim adim {} {}, yasim {} ve meslegim {}".format(name,surname,age, job))

a = "hello world"

print('Yeni ifade: ', a[0:6] + "W" + a[7:])
print("Degistirilmis ifade: ", a.replace("w","W"))

s = "abc"
print("Yan yana 3 kez: ",s * 3)
