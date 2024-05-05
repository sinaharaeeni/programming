import re
from time import sleep

from colorama import init, Fore, Style

# Initializes Colorama
init(autoreset=True)

# Save information on NameList.txt
SaveFile = open("NameList.txt", "a")
# Text pattern
PhonePattern = r"^[0][0-9]{7}$"
IDCodePattern = r"^[0-9]{10}$"
while True:
    # Receive information from user
    FirstName = input("Enter your first name: ")
    LastName = input("Enter your last name: ")
    Phone = input("Enter your phone (sample = 0654321): ")
    if re.match(PhonePattern, Phone):
        print("Valid Phone")
    else:
        print("Invalid Phone")
    IDCode = input("Enter your ID code (sample = 0011223344): ")
    if re.match(IDCodePattern, IDCode):
        print("Valid ID Code")
    else:
        print("Invalid ID Code")
    # Print user information
    print("You are " + FirstName + " " + LastName + " and ID is " + IDCode)

    # Validation information of user
    print(Style.BRIGHT + Fore.YELLOW + "If your information is true, enter 'Y' : ")
    UserValidation = input()
    if UserValidation == 'Y':
        var = list[FirstName, LastName, Phone, IDCode]
        SaveFile.write(var)
        SaveFile.close()
        print(Style.BRIGHT + Fore.GREEN + "Save successfully.")
    else:
        print(Style.BRIGHT + Fore.RED + "Enter data again.")
    sleep(1)
