#!/usr/bin/env python3
import sys, glob, re

def all_words(file):
    words = 0
    with open(file, "r") as file:
        for line in file:
            # print(line)
            sentence = re.findall(r'[a-zA-Z]+', line)
            # print(sentence)
            words += len(sentence)

    return words

def num_word(word, file):
    count = 0
    
    with open(file, "r") as file:
        for line in file:
            sentence = re.findall(r'[a-zA-Z]+', line.lower())
            count += sentence.count(word)
    
    return count

artists = {}
for file in glob.glob("lyrics/*.txt"):
    name = file[7:-4].replace('_', ' ')
    total = all_words(file)
    word_count = num_word(sys.argv[1], file)
    artists[name] = [word_count, total]
    # print(f"{word_count}, {total}, {name.replace('_', ' ')}")
    # print(f"{word_count}/  {total} = {float(word_count / total)} {name}")

# print(sorted(artists))
for k, v in sorted(artists.items()):
    print(f"{v[0]:4}/{v[1]:6} = {v[0]/v[1]:.9f} {k}")
