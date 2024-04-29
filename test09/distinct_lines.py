#!/usr/bin/env python3
import sys

unique = []
count = 0
try:
    while True:
        word = input().lower().lstrip().rstrip()
        # print(word.split())
        words = word.split()
        # words = [w for w in word]
        unique.append(words) if words not in unique else None
        count += 1
        # print(unique)
        if len(unique) == int(sys.argv[1]):
            print(f"{sys.argv[1]} distinct lines seen after {count} lines read.")
            break
except Exception as e:
    # print(e)
    print(f"End of input reached after {count} lines read - {sys.argv[1]} different lines not seen.")



