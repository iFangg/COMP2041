#!/bin/dash

# ==============================================================================
# test02.sh
# Test the pushy-commit [-a] -m command.
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

# testing nothing to commit
cat > "$expected_output" <<EOF
nothing to commit
EOF

pushy-commit -m "msg 1" > "$actual_output" 2>&1
if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# Committing nothing with -a

cat > "$expected_output" <<EOF
nothing to commit
EOF


pushy-commit -a -m 'third commit' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# Create a simple file.

echo "line 1" > a

# add a file to the repository staging area

cat > "$expected_output" <<EOF
EOF


pushy-add a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# Update the file.

echo "line 2" >> a

# Add the file in the repository staging area using commit -a

cat > "$expected_output" <<EOF
Committed as commit 1
EOF


pushy-commit -a -m 'second commit' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# test incorrect pushy-commit usage

cat > "$expected_output" <<EOF
usage: pushy-commit [-a] -m commit-message
EOF

pushy-commit > "$actual_output" 2>&1
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

# Update the file.

echo "line 2" >> a

# update the file in the repository staging area

cat > "$expected_output" <<EOF
EOF


pushy-add a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# commit the file to the repository history again

cat > "$expected_output" <<EOF
Committed as commit 1
EOF


pushy-commit -m 'second commit' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# Update the file.

echo "line 3" >> a

# Check that the file that has been commited hasn't been updated

cat > "$expected_output" <<EOF
line 1
EOF

pushy-show 0:a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# Check that the file that is in the staging area hasn't been updated

cat > "$expected_output" <<EOF
line 1
line 2
EOF


pushy-show :a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi


echo "Passed test"
exit 0

