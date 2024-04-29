#!/usr/bin/env python3
import sys as s

lines = []
with open(s.argv[1], "r") as file_A:
    lines = file_A.read().splitlines()
    lines.reverse()

with open(s.argv[2], "w") as file_B:
    for line in lines:
        file_B.write(f"{line}\n")


