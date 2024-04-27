#!/bin/dash

# ==============================================================================
# test00.sh
# Test the -f option.
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


# error: unknown flag
seq 1 10 | 2041 eddy -fF 'p' > "$expected" 2>&1

seq 1 10 | /usr/bin/python3 eddy.py -fF 'p' > "$actual" 2>&1

if ! diff "$expected" "$actual"; then
    echo "Failed test 1"
    exit 1
fi


# using invalid file
echo "hello" > 1.txt
seq 1 5 | 2041 eddy -f 1.txt > "$expected" 2>&1

seq 1 5 | /usr/bin/python3 eddy.py -f 1.txt > "$actual" 2>&1

if ! diff "$expected" "$actual"; then
    echo "Failed test 2"
    exit 1
fi

# using valid file
echo '$q' > 1.txt
seq 1 5 | 2041 eddy -f 1.txt > "$expected" 2>&1

seq 1 5 | /usr/bin/python3 eddy.py -f 1.txt > "$actual" 2>&1

if ! diff "$expected" "$actual"; then
    echo "Failed test 3"
    exit 1
fi
