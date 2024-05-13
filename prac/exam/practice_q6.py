#!/usr/bin/env python3
import sys, re, fileinput

contents_A = []
contents_B = []

with fileinput.input(files=(sys.argv[1])) as f:
    for line in f:
        contents_A.append(line)

with fileinput.input(files=(sys.argv[2])) as f:
    for line in f:
        contents_B.append(line)

if len(contents_A) != len(contents_B): 
    print(f"Not mirrored: different number of lines: {len(contents_A)} versus {len(contents_B)}")
    sys.exit(0)

diffs = []
for i in range(len(contents_A)):
    # print(f"line {i + 1}: {contents_A[i]} - {contents_B[-1 - i]}")
    # if contents_A[i] != contents_B[len(contents_B) - 1 - i]:
    if not contents_A[i].startswith(contents_B[-1 - i]):
        # print(i + 1)
        # print("hi")
        diffs.append(i + 1)

if not diffs:
    print("Mirrored")
    sys.exit(0)
if len(diffs) == 1:
    print(f"Not mirrored: line {diffs[0]} different")
else:
    for l in diffs:
        print(f"Not mirrored: line {l} different")
