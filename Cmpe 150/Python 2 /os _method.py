import os
print(dir(os))
print(os.getcwd())

# os.chdir('Users/furkanahi/Desktop/')
print(os.getcwd()) #
print(os.listdir())

os.mkdir('test.txt2') #Create new file
os.rmdir('test.txt2') #Remove file
os.rename('test.txt','test.txt2')

import os

for root, dirs, files in os.walk("project"):
    print("Current root:", root)
    print("Subfolders:  ", dirs)
    print("Files:       ", files)
    print("----------")

