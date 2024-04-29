#!/usr/bin/env python3
import sys as s


with open(s.argv[2], "r") as file:
    # nums = file.read().split('\n')
    nums = file.read().splitlines()
    print(nums[int(s.argv[1]) - 1]) if int(s.argv[1]) - 1 < len(nums) else None
