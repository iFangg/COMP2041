#!/usr/bin/env python3
import fileinput, re

fishies = {}

for file in fileinput.input():
    fish_name = ' '.join(re.findall("[a-zA-Z-\']+", file)).lower()
    if fish_name[-1] == 's': fish_name = fish_name[:-1]
    fish_no = int(re.search('\s(\d+)\s', file).groups()[0])
    if fish_name.lower() not in fishies:
        fishies[fish_name] = [1, fish_no]
    else:
        fishies[fish_name][0] += 1
        fishies[fish_name][1] += fish_no

for key, value in sorted(fishies.items()):
    print(f"{key} observations: {value[0]} pods, {value[1]} individuals")

