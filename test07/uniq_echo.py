#!/usr/bin/env python3
import sys as s

unique_words = []
for word in s.argv[1:]:
    unique_words.append(word) if word not in unique_words else None

for word in unique_words:
    print(word, end=" ")

print("")

