
#First encounter
x = 15

if(x > 20):
  print("Bigger")

if(x < 10):
  print("Smaller")


#For loop example

for i in range(5):
    print(i)
    if(i>2):
        print("Bigger than 2")
    print("Done with i, ", i)
print("All done")


#Else

x= 10
if(x>10):
    print("Bigger")
else:
    print("Smaller than or equal to 10")



#Number Guessing
x = 40

guess = input("What is your guess?")
guess = int(guess)

while(guess != x):
    guess = input("Guess again?")
    guess = int(guess)
    
    if(guess == x):
        print("You won, that is the number!")
    elif(guess > x):
        print("Try smaller number")
    else:
        print("Correct number was bigger")


















