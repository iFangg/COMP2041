#!/bin/dash

# ==============================================================================
# test00.sh
# Test the multiple commands feature of subset 1.
#
# Written by: Ivan Fang <z5418045@ad.unsw.edu.au>
# Date: 2024-04-21
# For COMP2041/9044 Assignment 2
# ==============================================================================

# add the current directory to the PATH so scripts
# can still be executed from it after we cd

PATH="$PATH:$(pwd)"

# Create a temporary directory for the test.
test_dir="$(mktemp -d)"

# Create some files to hold output.

expected="$(mktemp)"
actual="$(mktemp)"

# Remove the temporary directory when the test is done.

trap 'rm "$expected" "$actual" -rf "$test_dir"' INT HUP QUIT TERM EXIT


# invalid command(s)
seq 1 5 | 2041 eddy 'p;sVerywrong' > "$expected" 2>&1

seq 1 5 | /usr/bin/python3 eddy.py 'p;sVerywrong' > "$actual" 2>&1

if ! diff "$expected" "$actual"; then
    echo "Failed test 1"
    exit 1
fi

# valid test 1
seq 1 5 | 2041 eddy '5q;/3/d' > "$expected" 2>&1

seq 1 5 | /usr/bin/python3 eddy.py '5q;/3/d' > "$actual" 2>&1

if ! diff "$expected" "$actual"; then
    echo "Failed test 2"
    exit 1
fi

# valid test 2
seq 1 5 | 2041 eddy '/3/d;5q' > "$expected" 2>&1

seq 1 5 | /usr/bin/python3 eddy.py '/3/d;5q' > "$actual" 2>&1

if ! diff "$expected" "$actual"; then
    echo "Failed test 3"
    exit 1
fi

# valid test 3
seq 1 20 | 2041 eddy '1,/.1/p;/5/,/9/s/.//;/.2/,/.5/p;8q' > "$expected" 2>&1

seq 1 20 | /usr/bin/python3 eddy.py '1,/.1/p;/5/,/9/s/.//;/.2/,/.5/p;8q' > "$actual" 2>&1

if ! diff "$expected" "$actual"; then
    echo "Failed test 2"
    exit 1
fi


