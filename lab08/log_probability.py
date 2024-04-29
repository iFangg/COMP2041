#!/usr/bin/env python3
import sys, glob, re, math

def all_words(file):
    words = 0
    with open(file, "r") as file:
        for line in file:
            sentence = re.findall(r'[a-zA-Z]+', line)
            words += len(sentence)

    return words

def num_word(word, file):
    count = 0
    
    with open(file, "r") as file:
        for line in file:
            sentence = re.findall(r'[a-zA-Z]+', line.lower())
            count += sentence.count(word.lower())
    
    return count

artists = {}
for word in sys.argv[1:]:
    for file in glob.glob("lyrics/*.txt"):
        name = re.split(r"/", file)[1]
        name = re.split(r"\.", name)[0]
        name = re.sub('_', " ", name)
        total = all_words(file)
        word_count = num_word(word, file) + 1
        freq = float(word_count / total)
        if name not in artists: artists[name] = math.log(freq)
        else: artists[name] += math.log(freq)


for k, v in sorted(artists.items()):
    print(f"{v:10.5f} {k}")
