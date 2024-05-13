#!/usr/bin/env python3
import sys, re, collections

# for line in sys.stdin:
#     # print(line.rstrip('\n'))
#     balanced_words = []
#     for word in line.strip().split(' '):
#         word_counts = collections.Counter()
#         for c in word:
#             word_counts[c] += 1

#         # print(word_counts)
#         if len(set(word_counts.values())) <= 1:
#             balanced_words.append(word)
    
#     # print(balanced_words)

#     print(' '.join(balanced_words))

# this is sol'n from past paper
def is_equi_word(word):
    letter_count = {}
    for letter in word.lower():
        letter_count[letter] = letter_count.get(letter, 0) + 1
    return len(set(letter_count.values())) == 1

for line in sys.stdin:
    words = line.split()
    equi_words = filter(is_equi_word, words)
    print(' '.join(equi_words))
        



