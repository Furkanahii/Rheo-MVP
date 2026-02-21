with open('test.txt','r') as f:
    content = f.read()
    print(content)

    content = f.read(100)
    print(content)

with open('test.txt','r') as f:

    for line in f:
        print(line,end='')

    content = f.readline()
    print(content, end='')

with open('test.txt','r') as f:
    size_to_read = 10
    content = f.read(size_to_read)

    while len(content)>0:
        print(content,end='*')
        content = f.read(size_to_read)

    print(f.tell())
    print(f.seek(0))
