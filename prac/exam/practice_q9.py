#!/usr/bin/env python3
import sys, fileinput

def format_line(n, line):
    if len(line) <= n: 
        return line
        
    spaces = [i for i, c in enumerate(line) if c == " "]
    if not spaces:
        return line

    index = spaces[0]
    spaces_before_newline = [i for i in spaces if i < n]
    if spaces_before_newline:
        index = spaces_before_newline[-1]

    return f"{line[:index]}\n{format_line(n, line[index + 1:])}"

limit = int(sys.argv[1])

with fileinput.input(files=(sys.argv[2]), inplace = True) as f:
    count = 0
    for line in f:
        print(format_line(limit, line.rstrip('\n')))
        
