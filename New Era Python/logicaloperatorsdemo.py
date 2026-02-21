#Girilen bir sayinin 0-100 arasinda olup olmadigini kontrol ediniz.
a = int(input("Bir sayi giriniz: "))
result = (0 < a) and (a < 100)
print(f"Girilen sayi 0-100 arasinda mi? : {result}")

#Girilen sayinin pozitif cift sayi olup olmadigini kontrol ediniz.

result = int(input("Bir sayi giriniz: "))
isPositive = (result > 0)
isEven = (result % 2 == 0)
print(f"Girilen sayi pozitif cift sayi mi? : {isPositive and isEven}")

#Email ve parola bilgileri ile giris kontrolu yapiniz.

email = "furkanahi6@gmailcom"
password = "abc12345"
girilen_email = input("Email adresinizi giriniz: ")
girilen_password = input("Parolanizi giriniz: ")
isEmail = email == girilen_email.strip().lower()  # Email adresini küçük harfe çevir ve başındaki/sonundaki boşlukları kaldır
isPassword = password == girilen_password.strip()  # Paroladaki başındaki/sonundaki boşlukları kaldır
print(f"Giris kontrolu: {isEmail and isPassword}")

#Girilen 3 sayiyi buyukluk olarak karsilastiriniz.

a = int(input("Birinci sayiyi giriniz: "))
b = int(input("Ikinci sayiyi giriniz: "))
c = int(input("Ucuncu sayiyi giriniz: "))
result = (a>b) and (a>c)
print(f"Birinci sayi ({a}) en buyuktur: {result}")
result = (b>a) and (b>c)
print(f"Ikinci sayi ({b}) en buyuktur: {result}")
result = (c>a) and (c>b)
print(f"Ucuncu sayi ({c}) en buyuktur: {result}")

#Kullanicidan 2 vize(%60) ve final notunu alarak ortalama hesaplayiniz. Eger ortalama 50 ve ustu ise gecti, altinda ise kaldiniz yazdiriniz.
#ortalama 50 olsa bile final notu en az 50 olmalidir.
#Finalden 70 alindiginda ortalamanin onemi yoktur.

vize1 = float(input("Birinci vize notunu giriniz: "))
vize2 = float(input("Ikinci vize notunu giriniz: "))
final = float(input("Final notunu giriniz: "))
ortalama = (vize1 + vize2) / 2 * 0.6 + final * 0.4
result = (ortalama >= 50) and (final >= 50) or (final >= 70)
print(f"Ortalamaniz: {ortalama}, Dersten gecme durumunuz: {result}")
