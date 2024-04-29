#!/usr/bin/env python3
import sys as s

string = ' '.join(repr(word) for word in s.argv[2:])

if int(s.argv[1]) == 1: 
    print(f"#!/user/bind/env python3\n\nprint({string})\n")
else: 
    code = f"#!/user/bind/env python3\n\nprint({string})" 
    for n in range(int(s.argv[1]) - 1):
        code = f"#!/user/bind/env python3\n\nprint({repr(code)})" 
    
    print(code)
