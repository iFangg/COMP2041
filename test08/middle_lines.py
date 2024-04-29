#!/usr/bin/env python3
import sys, fileinput

try:
    file_len = 0
    for line in fileinput.input():
        file_len += 1

    line_count = 1
    lines = [file_len // 2 + 1, file_len // 2 + 1] if file_len % 2 != 0 else [file_len // 2, file_len // 2 + 1]
    for line in fileinput.input():
        if line_count == lines[0] or line_count == lines[1]: print(line, end="")
        line_count += 1
except:
    pass
