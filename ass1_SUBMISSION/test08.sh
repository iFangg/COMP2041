#!/bin/dash

# ==============================================================================
# test08.sh
# Test the pushy-checkout command.
#
# Written by: Ivan Fang <z5418045@ad.unsw.edu.au>
# Date: 2024-03-23
# For COMP2041/9044 Assignment 1
# ==============================================================================

# add the current directory to the PATH so scripts
# can still be executed from it after we cd

PATH="$PATH:$(pwd)"

# Create a temporary directory for the test.
test_dir="$(mktemp -d)"
cd "$test_dir" || exit 1

# Create some files to hold output.

expected_output="$(mktemp)"
actual_output="$(mktemp)"

# Remove the temporary directory when the test is done.

trap 'rm "$expected_output" "$actual_output" -rf "$test_dir"' INT HUP QUIT TERM EXIT

# Create pushy repository

cat > "$expected_output" <<EOF
Initialized empty pushy repository in .pushy
EOF

pushy-init > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

if ! pushy-checkout | grep -q -E "pushy-checkout: error: this command can not be run until after the first commit"; then
    echo "Failed test"
    exit 1
fi


# Create simple files

echo "line 1" > a
echo "line 2" > b
echo "line 3" > c

# add a file to the repository staging area

cat > "$expected_output" <<EOF
EOF


pushy-add a b c > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# commit the file to the repository history

cat > "$expected_output" <<EOF
Committed as commit 0
EOF


pushy-commit -m 'first commit' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi


# Make a branch
pushy-branch b1
if ! pushy-checkout b1 | grep -q -E "Switched to branch 'b1'"; then
    echo "Failed test"
    exit 1
fi

echo "line 4" > d
echo "line 5" > e
echo "line 6" > f
pushy-add d e f
pushy-commit -m "commit 2" >/dev/null
if ! pushy-status | grep -q -E "^d"; then
    echo "Failed test"
    exit 1
fi
pushy-checkout master >/dev/null
if pushy-status | grep -E "^d"; then
    echo "Failed test"
    exit 1
fi

pushy-checkout b1 >/dev/null
pushy-branch b2
pushy-checkout b2 >/dev/null
echo "line 7" > g
pushy-add g
pushy-commit -m "commit-3" >/dev/null
pushy-branch b3
pushy-checkout b3 >/dev/null
if ! pushy-status | grep -q -E "^g "; then
    echo "Failed test"
    exit 1
fi


# checking errors

if ! pushy-checkout | grep -q -E "usage: pushy-checkout <branch>"; then
    echo "Failed test1"
    exit 1
fi

if ! pushy-checkout c1 | grep -q -E "pushy-checkout: error: unknown branch 'c1'"; then
    echo "Failed test2"
    exit 1
fi

pushy-checkout master >/dev/null
if ! pushy-checkout master | grep -q -E "Already on 'master'"; then
    echo "Failed test3"
    exit 1
fi


echo "Passed test"
exit 0

