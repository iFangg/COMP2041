#!/bin/dash

# ==============================================================================
# test07.sh
# Test the pushy-branch [-d] command.
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

if ! pushy-branch | grep -q -E "pushy-branch: error: this command can not be run until after the first commit"; then
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


# checking errors

if pushy-branch 123 123 12 | grep -E "usage: pushy-branch [-d] <branch>"; then
    echo "Failed test"
    exit 1
fi

if ! pushy-branch 11 | grep -q -E "pushy-branch: error: invalid branch name '11'"; then
    echo "Failed test"
    exit 1
fi

if ! pushy-branch b1 | grep -q -E "pushy-branch: error: branch 'b1' already exists"; then
    echo "Failed test"
    exit 1
fi

if ! pushy-branch -d master | grep -q -E "pushy-branch: error: can not delete branch 'master': default branch"; then
    echo "Failed test"
    exit 1
fi

pushy-checkout b1 >/dev/null
if ! pushy-branch -d b1 | grep -q -E "pushy-branch: error: can not delete branch 'b1': current branch"; then
    echo "Failed test"
    exit 1
fi


echo "Passed test"
exit 0

