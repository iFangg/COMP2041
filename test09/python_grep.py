#!/usr/bin/env python3
import sys, re

regex = sys.argv[1]
file = sys.argv[2]

with open(file, "r") as f:
    for line in f:
        line = line.rstrip()
        if re.search(regex, line):
            print(line)

