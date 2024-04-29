#!/usr/bin/env python3
import sys, fileinput, collections

files = []
lines = collections.defaultdict(str)

count = 1
for line in fileinput.input():
    files.append(line)
    lines[count] = line
    count += 1

count = 1
for line in files:
    if line.startswith("#"):
        replacement = int(line[1:])
        print(lines[replacement], end = "")
    else:
        print(lines[count], end = "")
    
    count += 1
        