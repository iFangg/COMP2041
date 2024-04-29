#!/usr/bin/env python3
import sys, fileinput

lines = {}
line_no = 1
for line in fileinput.input():
    lines[line_no] = [len(line), line]
    line_no += 1

lines = sorted(lines.items(), key = lambda x: (x[1][0], x[1][1]))
for line in lines:
    print(line[1][1], end="")


