#!/usr/bin/env python3
import sys as s

with open(s.argv[3], "w") as file:
    for n in range(int(s.argv[1]), int(s.argv[2]) + 1):
        file.write(f'{str(n)}\n')


