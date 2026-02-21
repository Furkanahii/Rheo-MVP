def array(row,column):
    outerlist = []
    for i in range(row):
        innerlist = []
        for j in range(column):
            k = i*j
            innerlist.append(k)
        outerlist.append(innerlist)
    return outerlist
print(array(3,4))

#A harfi yazma 
result_str = "" 
