#!/usr/bin/env python3
import sys, collections

numbers = [int(n) for n in sys.argv[1:]]
uniq_nums = set(numbers)
# print(numbers)
# print(uniq_nums)
count = len(numbers)
unique = len(uniq_nums)
min_n = min(numbers)
max_n = max(numbers)
avg = sum(numbers) / count
middle = sorted(numbers)[len(numbers) // 2]

nums = collections.defaultdict(int)
for n in numbers:
    nums[n] += 1
mode = sorted(nums.items(), key = lambda x: x[1], reverse = True)[0][0]
sum_n = sum(numbers)
product = 1
for n in numbers:
    product *= n


print(f"count={count}")
print(f"unique={unique}")
print(f"minimum={min_n}")
print(f"maximum={max_n}")
print(f"mean={avg}") if avg % 1 != 0 else print(f"mean={int(avg)}")
print(f"median={middle}")
print(f"mode={mode}")
print(f"sum={sum_n}")
print(f"product={product}")

