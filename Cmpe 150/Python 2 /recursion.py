#Problem 1
def faktoriyel(n):
    # 1. Temel Durum
    # 0! ve 1! = 1 olarak tanımlanır. Bu, fonksiyonun durma noktasıdır.
    if n == 0 or n == 1:
        return 1
    # 2. Özyinelemeli Adım
    # n! = n * (n-1)!
    else:
        return n * faktoriyel(n - 1)

# Kullanım:
print(f"5'in faktoriyeli: {faktoriyel(5)}") # Çıktı: 120
print(f"0'ın faktoriyeli: {faktoriyel(0)}") # Çıktı: 1

#Problem 2

''' output
isSorted([]) True
isSorted([1,2,3,4]) True 
isSorted([1,4,2]) False
'''

def isSorted(lst):
    if len(lst) <= 1:
        return True
    if  lst[0] < lst[1]:
        return True
    else:
        return isSorted(lst[1:]) #Son eleman da dahildir