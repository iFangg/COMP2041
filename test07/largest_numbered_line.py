#!/usr/bin/env python3
import sys as s
import re

max_lines = []
max_n = float('-inf')
while True:
    try:
        line = input()
        num = re.findall(r'-*\d*\.?\d+', line)
        if len(num) > 0:
            line_max_n = max(float(n) for n in num)
            if line_max_n > max_n:
                max_n = line_max_n
                max_lines = [line]
            elif line_max_n == max_n:
                max_lines.append(line)
    except:
        for line in max_lines:
            print(line)
        break
