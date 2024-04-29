#!/usr/bin/env python3
import fileinput, re, sys

def num_word(word, file):
    count = 0

    for line in file:
        sentence = re.findall(r'[a-zA-Z]+', line.lower())
        count += sentence.count(word)


    print(f"{word} occurred {count} times")

num_word(sys.argv[1], sys.stdin)