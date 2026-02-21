def listeyecevir(*params):
    liste = []
    for param in params:
        liste.append(param)
    return liste
result = listeyecevir(10,20,30,'Merhaba')
print(result)




def asalsayilaribul(sayi1, sayi2):
    for sayi in range (sayi1,sayi2+1):
        if sayi >1 :
            for i in range(2, sayi):
                if (sayi % i == 0):
                    break
            else:
                print(sayi)
sayi1 = int(input('sayi1: '))
sayi2 = int(input('sayi2: '))

asalsayilaribul(sayi1,sayi2)


def tambolenleribul(sayi):
    tambolenler = []

    for i in range(2, sayi):
        if(sayi % i == 0):
            tambolenler.append(i)
    return tambolenler
print(tambolenleribul())