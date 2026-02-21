#  https://www.hackerrank.com/challenges/list-comprehensions/problem
#  Given three integers x, y, and z representing the dimensions of a cuboid along
#  the x, y, and z axes, respectively, and an integer n representing an upper limit,
#  print a list of all possible coordinates given by (i, j, k) on a 3D grid where the sum of i + j + k is not equal to n.
x = int(input())
y = int(input())
z = int(input())
n = int(input())
    
newlist = []
for i in range(x+1):
    for j in range(y+1):
        for k in range(z+1):
            if i+j+k !=n:
                newlist.append([i,j,k])
print(newlist)