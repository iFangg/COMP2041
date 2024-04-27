#!/bin/dash

# ==============================================================================
# test00.sh
# Test the pushy-init command.
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


# Initialize pushy repo with command-line arguments

cat > "$expected_output" <<EOF
usage: pushy-init
EOF

pushy-init arg1 arg2 > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# Create pushy repository

cat > "$expected_output" <<EOF
Initialized empty pushy repository in .pushy
EOF

pushy-init > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# Create pushy repo when it already exists

cat > "$expected_output" <<EOF
pushy-init: error: .pushy already exists
EOF

pushy-init > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# Add a file to the repository

echo "line 1" > a

# add and commit to pushy

cat > "$expected_output" <<EOF
Committed as commit 0
EOF

pushy-add a
pushy-commit -m "first commit" > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

echo "Passed test"
exit 0