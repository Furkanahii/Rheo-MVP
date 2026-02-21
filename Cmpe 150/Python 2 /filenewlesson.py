# os.listdir() → klasördeki dosya isimlerini veriyordu
# os.path.isfile() → bu isim bir dosya mı, klasör mü diye bakıyordu
# CWD: Python’ın “şu an hangi klasördeyim?” dediği yer. os.getcwd() ile görüyorduk.



# check all files in the current directory
# report the ones with the same contents
import sys
import os
files = os.listdir( )
content_files = {}
for file_name in files:
    if os.path.isfile(file_name):
        try:
            with open(file_name) as f:
                content = f.read()
        except:
            continue
        content_files[content] = content_files.get(content,[])+[file_name]
        f.close()

for content,f_list in content_files.items():
    if len(f_list) > 1:
        print(content,f_list)

# traverse all the subdirectories of the current directory
# gather file names
# read contents and report if the ones with the same contents
import sys
import os
names = os.listdir( ) #sadece bir seviyeyi listeler
file_names = list() # read all files in the file_names for their content
for name in names:
    if os.path.isfile(name):
        file_names.append(name)
    else: # if name is a director
        sub_names = os.listdir(name)
        for sub_name in sub_names:
            if os.path.isfile(name+'/'+sub_name):
                file_names.append(name+'/'+sub_name)
print(file_names)

content_files = dict()
for file_name in file_names:
    print(file_name)
    f = open(file_name)
    content = f.read()
    f.close()
    content_files[content] = content_files.get(content, []) + [file_name]
for content,f_list in content_files.items():
    if len(f_list) > 1:
        print(content,f_list)

#Alternative
for root, dirs, files in os.walk("."):
    for f in files:
        print(os.path.join(root, f))

#Search all sub-directories and find the files with the same names. Print out the file names.
import os
# Dictionary: filename → list of full paths containing that filename
name_map = {}
# Use a list as a queue for directories to visit
dirs_to_visit = ["."] # (.) = current working directory.
index = 0
# Traverse all subdirectories
while index < len(dirs_to_visit):
    current_dir = dirs_to_visit[index]
    index += 1 # we could have poppsed them as well
    for item in os.listdir(current_dir):
        path = os.path.join(current_dir, item)
        if os.path.isdir(path): #Klasorse True,degilse False
            dirs_to_visit.append(path)
        else:
            # item is the file name
            if item in name_map:
                name_map[item].append(path)
            else:
                name_map[item] = [path]
#Print file names that appears more than once
found = False
for name in name_map:
    paths = name_map[name] #valuelari gosterir
    if len(paths)>1:
        found=True
        print("Duplicate file name:", name)
if not found:
    print("No duplicate file names found.")

# Onemli yontem
dictionary[key] = dictionary.get(key, []) + [value]
#Alternative Method
if key not in dictionary:
    dictionary[key] = []
dictionary[key].append(value)



