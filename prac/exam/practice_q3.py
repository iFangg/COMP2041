#!/usr/bin/env python3
import sys, re

names = []
for line in sys.stdin:
    line_names = re.findall(r"[A-Z][a-z]+\,.*M$", line)
    # print(line_names)
    if not line_names: continue
    name = line_names[0].split(',')[0]
    if name not in names: names.append(name)

for n in sorted(names):
    print(n)

