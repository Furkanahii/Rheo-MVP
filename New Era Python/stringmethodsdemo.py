website = "https://www.example.com"
course = "Python Programming"
# 1-  "Hello World" karakter dizisinin bas ve sonundaki bosluklari siliniz.
# 2- website icindeki example bilgisi haricini siliniz.
# 3- course karakter dizisinin tum karakterlerini kucuk harfe ceviriniz
# 4- website icinde kac tane a harfi var? (count('a'))
# 5- website 'www' ile baslayip com ile bitiyor mu 
# 6- website icinde .com ifadesi var mi 

print("1-Bosluklar silindi: ", " Hello World ".strip())
print(website.lstrip("https://"))

website.strip("https://www." + ".com")

print("3-Kucuk harfe cevirildi: ", course.lower())

print("4- A harfi sayisi: ", website.count('a'))

print("5- 'www' ile baslayip 'com' ile bitiyor mu?: ", website.startswith("www") and website.endswith("com"))

print("6-Ifade var mi?: ",website.find(".com"))
print("6-Ifade var mi?: ",website.find("example",0,10)) # find() metodu, belirtilen alt dizeyi bulamazsa -1 döner.

#7-course icindeki karakterlerin hepsi alfabeti mi 
#8 Contents ifadesini satirda 50 karakter icine yerlestirip sag ve soluna * karakteri ekleyiniz.
#9-course karakter dizisindeki tum bosluklari - ile degistiriniz.
#10-"Hello World" karakter dizisinin ilk 5 karakterini aliniz.
#11- course karakter dizisini bosluk karakterlerinden ayirin

print("7- Tum karakterler alfabetik mi?: ", course.isalpha())
print("123".isdigit())

a = "Contents"
print("8- Contents ifadesi: ", a.center(50, '*')) 

print("9-Bosluklar - ile degistirildi: " , course.replace(" ", "-"))

a = "Hello World"
print("10- ilk 5 terimi alindi: ",a[0:5])

print("11- Bosluk karakterlerinden ayirildi: ", course.split(" "))