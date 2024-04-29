#!/usr/bin/env python3
import fileinput, re


orcas = 0
for file in fileinput.input():
    fish_list = re.findall('\s(\d+)\s.*orca', file.lower())
    if len(fish_list) > 0: orcas += int(fish_list[0])


print(f"{orcas} Orcas reported")