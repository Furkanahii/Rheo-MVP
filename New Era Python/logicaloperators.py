x = 7

#and

result = x > 5 and x < 10  # True,True => True
result = x > 5 and x < 2  # True,False => False

#or

result = (x >0) or (x % 2 == 0)  # True,False => True
                                 # False,False => False
                                 #True,True => True

#not

result = not (x > 5)  # False, çünkü x 5'ten büyük
print(result)
