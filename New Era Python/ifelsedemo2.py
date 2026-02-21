#Girilen bir sayinin 0-100 arasinda olup olmadigini kontrol ediniz.

sayi1 = int(input("Bir sayi giriniz: "))
if (0 < sayi1 < 100):
    print("Girdiginiz sayi 0-100 arasindadir.")
else:
    print("Girdiginiz sayi 0-100 araliginda degildir.")

#Girilen sayinin pozitif cift sayi olup olmadigini kontrol ediniz.
sayi2 = int(input("Bir sayi giriniz: "))
if (sayi2 >0) and (sayi2%2 == 0):
    print("Girdiginiz sayi pozitif cift sayidir.")
elif (sayi2 > 0) and (sayi2 % 2 != 0):
    print("Girdiginiz sayi pozitif tek sayidir.")
elif (sayi2 < 0) and (sayi2 % 2 == 0):
    print("Girdiginiz sayi negatif cift sayidir.")
else:
    print("Girdiginiz sayi pozitif cift sayi degildir.")


#Email ve parola bilgileri ile giris kontrolu yapiniz.

email = "furkanahi6@gmailcom"
password = "abc12345"
girilen_email = input("Email adresinizi giriniz: ")
girilen_password = input("Parolanizi giriniz: ")
if (email == girilen_email.strip().lower()):
    if(password == girilen_password.strip()):
       print("Giris basarili.")
    else:
        print("Parola yanlis")
else:
    print("Email bilgisi yanlis")

#Girilen 3 sayiyi buyukluk olarak karsilastiriniz.

a = int(input("Birinci sayiyi giriniz: "))
b = int(input("Ikinci sayiyi giriniz: "))
c = int(input("Ucuncu sayiyi giriniz: "))
if a>b and a>c:
    print(f"Birinci sayi ({a}) en buyuktur:")
elif (b>a) and (b>c):
    print(f"Ikinci sayi ({b}) en buyuktur:")
elif (c>a) and (c>b):
    print(f"Ucuncu sayi ({c}) en buyuktur:")