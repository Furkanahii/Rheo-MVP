#Girilen 2 sayidan hangisi buyuktur?

a = int(input("Birinci sayiyi giriniz: "))
b = int(input("Ikinci sayiyi giriniz: "))

result = a > b 
if result:
    print(f"Birinci:{a} sayisi ikinci:{b} sayisindan buyuktur.")
else:
    print(f"Ikinci:{a} sayi birinci sayidan{b} buyuktur veya esitler.")
#Kullanicidan 2.vize(%60) ve final(%40) notunu alip ortalama hesaplayiniz.Eger ortalama 50 ve ustu ise gecti, altinda ise kaldiniz yazdiriniz.


vize = float(input("Vize notunu giriniz: "))
final = float(input("Final notunu giriniz: "))
ortalama = (vize * 0.6) + (final * 0.4)
print(f"Ortalamaniz: {ortalama} ve dersten gecme durumunuz: {ortalama >= 50}")

#Parola ve email kontrolu yapiniz.

email = "furkanahi6@gmail.com"
password = "abc12345"

girilen_email = input("Email adresinizi giriniz: ")
girilen_password = input("Parolanizi giriniz: ")

isEmail = (email == girilen_email.lower().strip()) # Email adresini küçük harfe çevir ve başındaki/sonundaki boşlukları kaldır
isPassword = (password == girilen_password.strip())  # Paroladaki başındaki/sonundaki boşlukları kaldır
print(f"Email kontrolu: {isEmail}, Parola kontrolu: {isPassword}")

