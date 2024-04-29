#!/usr/bin/env python3
import sys, fileinput, re

for line in fileinput.input():
    numbers = re.findall('[0-9]+.?[0-9]+', line)
    for n in numbers:
        line = line.replace(n, str(round(float(n))))
    print(line, end = "")

