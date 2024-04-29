#!/usr/bin/env python3
import fileinput, re, sys

def all_words(file):
    words = 0
    for line in file:
        sentence = re.findall(r'[a-zA-Z]+', line)
        words += len(sentence)

    print(f"{words} words")


all_words(fileinput.input())
