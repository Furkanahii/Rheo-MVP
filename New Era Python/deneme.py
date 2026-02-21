def f():
    ret = 2 + 3
    return ret

sonuc = f()
print(sonuc)


def f(x,y):
    ret2 = x + y
    return ret2 
a = f(2,5)
print(a)

def f():
  global x
  global y
  z = x + y   # global x ve y kullanılıyor
  x = 50      # global x'i DEĞİŞTİRİYORUZ
  return

y = 10
x = 30
f() #globali 50 ye donusturdu
print(x)      # 50
