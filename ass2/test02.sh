#!/bin/dash

# ==============================================================================
# test00.sh
# Test the delete command.
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


# Try invalid delete
seq 1 5 | 2041 eddy 'pwrong' > "$expected" 2>&1

seq 1 5 | /usr/bin/python3 eddy.py 'pwrong' > "$actual" 2>&1

if ! diff "$expected" "$actual"; then
    echo "Failed test 1"
    exit 1
fi

# standard delete
seq 1 10 | 2041 eddy 'd' > "$expected" 2>&1

seq 1 10 | /usr/bin/python3 eddy.py 'd' > "$actual" 2>&1

if ! diff "$expected" "$actual"; then
    echo "Failed test 2"
    exit 1
fi

# line number delete
seq 1 10 | 2041 eddy '5d' > "$expected" 2>&1

seq 1 10 | /usr/bin/python3 eddy.py '5d' > "$actual" 2>&1

if ! diff "$expected" "$actual"; then
    echo "Failed test 3"
    exit 1
fi

# regex delete
seq 1 10 | 2041 eddy '/^1/d' > "$expected" 2>&1

seq 1 10 | /usr/bin/python3 eddy.py '/^1/d' > "$actual" 2>&1

if ! diff "$expected" "$actual"; then
    echo "Failed test 4"
    exit 1
fi

# line to regex delete
seq 1 10 | 2041 eddy '2,/6/d' > "$expected" 2>&1

seq 1 10 | /usr/bin/python3 eddy.py '2,/6/d' > "$actual" 2>&1

if ! diff "$expected" "$actual"; then
    echo "Failed test 5"
    exit 1
fi
