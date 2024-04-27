#!/bin/dash

# ==============================================================================
# test05.sh
# Test the pushy-rm [--force] [--cached] command.
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
    echo "Failed test1"
    exit 1
fi


# Create a simple file.

echo "line 1" > a

# add a file to the repository staging area

cat > "$expected_output" <<EOF
EOF


pushy-add a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test2"
    exit 1
fi


# commit the file to the repository history

cat > "$expected_output" <<EOF
Committed as commit 0
EOF


pushy-commit -m 'first commit' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test3"
    exit 1
fi

# Update the file.

echo "line 2" >> a

# update the file in the repository staging area

cat > "$expected_output" <<EOF
EOF


pushy-add a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test4"
    exit 1
fi

# pushy-rm errors
if ! pushy-rm a | grep -q -E "pushy-rm: error: 'a' has staged changes in the index"; then
    echo "Failed test5"
    exit 1
fi

if ! pushy-rm b | grep -q -E "pushy-rm: error: 'b' is not in the pushy repository"; then
    echo "Failed test"
    exit 1
fi

#

pushy-rm --cached a
if ! pushy-status | grep -q -E "^a - deleted from index"; then
    echo "Failed test"
    exit 1
fi

pushy-add a
pushy-commit -m "commit-2" >/dev/null
echo 3 >> a
pushy-add a
echo 4 >> a
if ! pushy-rm --cached a | grep -q -E "pushy-rm: error: 'a' in index is different to both the working file and the repository"; then
    echo "Failed test"
    exit 1
fi

echo "Passed test"
exit 0

