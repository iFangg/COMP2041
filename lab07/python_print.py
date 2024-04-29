#!/usr/bin/env python3
import sys as s

string = ' '.join(repr(word) for word in s.argv[1:])

print(f"#!/user/bind/env python3\n\nprint({string})\n")
