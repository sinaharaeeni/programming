from time import sleep

FileName = 'NameList.txt'
SampleText = 'text is sample and we know this'
while True:
    ReadFile = open(FileName, 'r')
    SearchWord = input('Word to search: ')
    Result = SearchWord in ReadFile.read()
    if Result:
        print("YES! We have a match!")
    else:
        print("No match")
    # print(ReadFile.read())
    sleep(1)
