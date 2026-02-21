#Inheritance(Kalitim):Miras alma

#Person =>name,lastname,age,eat(),run(),drink()
#Student(Person) ,Teacher(Person )

class Person():
    def __init__(self):
        print('Person Created')

class Student(Person):
    def __init__(self):
        Person.__init__(self) #Üst sınıf (Person)’ın constructor'ını manuel olarak çağırıyorsun.Böylece Person'ın tüm başlangıç ayarları da Student nesnesi içinde geçerli olur.
        print("Student Created")   #print("Student Created") Student’ın kendine özel çıktısıdır.

p1 = Person()
s1 = Student()