x,y,z  = 2,5,10
numbers = 1,5,7,10,6
#Kullanicidan aldiginiz 2 sayinin carpimi ile x,y,z toplaminin farki nedir?
a = int(input("Birinci sayiyi giriniz: "))
b = int(input("Ikinci sayiyi giriniz: "))
carpim = a * b
result = (x+y+z) - carpim
print("Sonuc: ", result)
#y'nin x e kalansiz bolumunu hesaplayiniz.
bolum = y//x
print("y'nin x'e kalansız bölümü: ", bolum)
#(x,y,z) toplaminin mod 3'u nedir?
mod = (x+y+z)%3 
print("Toplamın mod 3'u: ", mod)
# y'nin x.kuvvetini hesaplayiniz.
result = y**x
print("y'nin x. kuvveti: ", result)
# x, *y ,z numbers islemine gore z nin kupu nedir?
x,*y,z = numbers
kup = z**3
print("z'nin küpü: ", kup)

#x,*y, z = numbers islemine gore y nin degerleri toplami nedir?
x,*y,z = numbers
toplam_y = y[0] + y[1] + y[2]  # y'nin değerlerini toplama
print("y'nin değerleri toplamı: ", toplam_y)