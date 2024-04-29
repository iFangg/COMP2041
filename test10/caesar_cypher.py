#!/usr/bin/env python3
import sys

cypher = int(sys.argv[1])

alphabet = {
    'a': 1,
    'b': 2,
    'c': 3,
    'd': 4,
    'e': 5,
    'f': 6,
    'g': 7,
    'h': 8,
    'i': 9,
    'j': 10,
    'k': 11,
    'l': 12,
    'm': 13,
    'n': 14,
    'o': 15,
    'p': 16,
    'q': 17,
    'r': 18,
    's': 19,
    't': 20,
    'u': 21,
    'v': 22,
    'w': 23,
    'x': 24,
    'y': 25,
    'z': 26,
}

cypher_map_lower = {
    'a': 1,
    'b': 2,
    'c': 3,
    'd': 4,
    'e': 5,
    'f': 6,
    'g': 7,
    'h': 8,
    'i': 9,
    'j': 10,
    'k': 11,
    'l': 12,
    'm': 13,
    'n': 14,
    'o': 15,
    'p': 16,
    'q': 17,
    'r': 18,
    's': 19,
    't': 20,
    'u': 21,
    'v': 22,
    'w': 23,
    'x': 24,
    'y': 25,
    'z': 26,
}

cypher_map_upper = {
    'A': 1,
    'B': 2,
    'C': 3,
    'D': 4,
    'E': 5,
    'F': 6,
    'G': 7,
    'H': 8,
    'I': 9,
    'J': 10,
    'K': 11,
    'L': 12,
    'M': 13,
    'N': 14,
    'O': 15,
    'P': 16,
    'Q': 17,
    'R': 18,
    'S': 19,
    'T': 20,
    'U': 21,
    'V': 22,
    'W': 23,
    'X': 24,
    'Y': 25,
    'Z': 26,
}

def get_char(value):
    for k, v in alphabet.items():
        # print(k, v)
        if v == value:
            return k


for k, v in cypher_map_lower.items():
    shift = (v + cypher) % 26
    cypher_map_lower[k] = shift if shift != 0 else 26
    cypher_map_upper[k.upper()] = shift if shift != 0 else 26

newline = False
try:
    while True:
        string = input().rstrip('\n').lstrip('\n')
        if not string: break
        new_str = ""
        for c in string:
            char = c
            if c in cypher_map_lower:
                char = get_char(cypher_map_lower[c])
            if c in cypher_map_upper:
                char = get_char(cypher_map_upper[c]).upper()
            new_str += char
        
        print(new_str.rstrip('\n'))
except Exception as e:
    sys.exit(0)
