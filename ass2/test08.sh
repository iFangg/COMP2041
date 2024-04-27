#!/bin/dash

# ==============================================================================
# test00.sh
# Test the comments and whitespace acceptance implementation.
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


# Testing implementation of comments
seq 1 5 | 2041 eddy '3,17d#comment' > "$expected" 2>&1

seq 1 5 | /usr/bin/python3 eddy.py '3,17d#comment' > "$actual" 2>&1

if ! diff "$expected" "$actual"; then
    echo "Failed test 1"
    exit 1
fi


# Testing implementation of whitespaces
seq 1 5 | 2041 eddy '2 ,             17d    ' > "$expected" 2>&1

seq 1 5 | /usr/bin/python3 eddy.py '2 ,             17d    ' > "$actual" 2>&1

if ! diff "$expected" "$actual"; then
    echo "Failed test 2"
    exit 1
fi

# Testing implementation of comments and whitespaces
seq 1 5 | 2041 eddy '/2/d # delete  ;  4  q # quit' > "$expected" 2>&1

seq 1 5 | /usr/bin/python3 eddy.py '/2/d # delete  ;  4  q # quit' > "$actual" 2>&1

if ! diff "$expected" "$actual"; then
    echo "Failed test 3"
    exit 1
fi
