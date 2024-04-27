#!/bin/dash

# ==============================================================================
# test00.sh
# Test the quit command.
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

# Try invalid quit
seq 1 5 | 2041 eddy 'qerror' > "$expected" 2>&1

seq 1 5 | /usr/bin/python3 eddy.py 'qerror' > "$actual" 2>&1

if ! diff "$expected" "$actual"; then
    echo "Failed test 1"
    exit 1
fi

# Try working simple quit 

seq 1 5 | 2041 eddy 'q' > "$expected" 2>&1

seq 1 5 | /usr/bin/python3 eddy.py 'q' > "$actual" 2>&1

if ! diff "$expected" "$actual"; then
    echo "Failed test 2"
    exit 1
fi

# line number quit
seq 1 5 | 2041 eddy '2q' > "$expected" 2>&1

seq 1 5 | /usr/bin/python3 eddy.py '2q' > "$actual" 2>&1

if ! diff "$expected" "$actual"; then
    echo "Failed test 3"
    exit 1
fi


# regex number quit
seq 1 5 | 2041 eddy '/3/q' > "$expected" 2>&1

seq 1 5 | /usr/bin/python3 eddy.py '/3/q' > "$actual" 2>&1

if ! diff "$expected" "$actual"; then
    echo "Failed test 4"
    exit 1
fi

