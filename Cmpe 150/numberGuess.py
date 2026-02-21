from random import randint

print("Welcome to the Number Guessing Game!")

range = int(input("Please enter the desired range for the game:"))
correct_number = randint(1,range)
print("Ok, i have picked a number.")

#Choosing game mode
gameMode = 1

while(gameMode == 1):
    prompt_str = "Guess a number between 1 and " + str(range) + ":"
    guessed_number = int(input(prompt_str))
    if(correct_number == guessed_number):
        break
    elif(guessed_number < correct_number):
        print("Your guess is too low.")
    else:
        print("Your guess is too high.")

while(gameMode == 2):
    prompt_str = "Guess a number between 1 and " + str(range) + ":"
    guessed_number = int(input(prompt_str))
    if (correct_number == guessed_number):
        break
    distance = abs(guessed_number - correct_number)
    if(distance <= 10):
        print("HOT")
    else:
        print("COLD")

print("Congrats, you won!")