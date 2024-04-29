#!/usr/bin/env python3
import fileinput, re

word_sum = 0
for file in fileinput.input():
    # print(file)
    nums = re.findall('(\d+)+', file)
    if len(nums) > 0: 
        # print(nums)
        word_sum += sum(int(n) for n in nums)

print(word_sum)
