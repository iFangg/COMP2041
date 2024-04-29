#!/usr/bin/env python3
import sys as s

def three_vowels(string):
    vowels = ['a', 'e', 'i', 'o', 'u']
    counter = 0
    for letter in string:
        if letter in vowels: counter += 1
        else: counter = 0
        if counter == 3: return True
    
    return False

for string in s.argv[1:]:
    if three_vowels(string.lower()): print(string, end=" ")

print("")

