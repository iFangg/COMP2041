#!/bin/dash

# ==============================================================================
# test09.sh
# Test the pushy-merge command.
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

if ! pushy-merge | grep -q -E "pushy-merge: error: this command can not be run until after the first commit"; then
    echo "Failed test"
    exit 1
fi

echo 1 > eg.txt
echo 2 >> eg.txt
pushy-add eg.txt
pushy-commit -m commit-0 >/dev/null

if ! pushy-merge | grep -q -E "usage: pushy-branch <branch|commit> -m message"; then
    echo "Failed test"
    exit 1
fi

if ! pushy-merge -asd hehe | grep -q -E "usage: pushy-branch <branch|commit> -m message"; then
    echo "Failed test"
    exit 1
fi

if ! pushy-merge 1111 -m test | grep -q -E "pushy-merge: error: unknown commit 'commit'"; then
    echo "Failed test"
    exit 1
fi

if ! pushy-merge non_branch -m test | grep -q -E "pushy-merge: error: unknown branch 'non_branch'"; then
    echo "Failed test"
    exit 1
fi

pushy-branch b1
pushy-checkout b1 >/dev/null
echo 3 >> eg.txt
pushy-commit -a -m commit-1 >/dev/null
pushy-checkout master >/dev/null
if ! pushy-merge b1 -m merge-message | grep -q -E "Fast-forward: no commit created"; then
    echo "Failed Test"
    exit 1
fi

if ! pushy-status | grep -q -E "eg.txt - same as repo"; then
    echo "Failed test"
    exit 1
fi


echo "Passed test"
exit 0

