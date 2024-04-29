#!/usr/bin/env python3
import sys as s
from collections import defaultdict

lines = defaultdict(int)
limit = s.argv[1]
while True:
    try:
        line = input().split('\n')
        # print(line)
        if lines[line[0]] + 1 >= int(limit): 
            print(f"Snap: {line[0]}")
            break
        else:
            lines[line[0]] += 1
    except:
        break

