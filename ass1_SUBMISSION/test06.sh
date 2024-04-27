#!/bin/dash

# ==============================================================================
# test06.sh
# Test the pushy-status command.
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

pushy-commit -a -m "msg 1" > "$actual_output" 2>&1
if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# Create a simple files.

echo "line 1a" > a
echo "line 1b" > b
echo "line 1c" > c
echo "line 1d" > d
echo "line 1e" > e
echo "line 1f" > f

# test rm error - file not in cwd/index/repo
cat > "$expected_output" <<EOF
pushy-rm: error: 'a' is not in the pushy repository
EOF

pushy-rm a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# add a file to the repository staging area

cat > "$expected_output" <<EOF
EOF


pushy-add a b c e > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi


# test rm from index (not in repo)
cat > "$expected_output" <<EOF
EOF

pushy-add a b c
if ! pushy-status | grep -q -E "a - added to index"; then
    echo "Failed test"
    exit 1
fi
pushy-rm --cached a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi


if ! pushy-status | grep -q -E "^a \- untracked"; then
    echo "Failed test"
    exit 1
fi


pushy-commit -m "commit 0" >/dev/null
if ! pushy-status | grep -q -E "^b - same as repo"; then
    echo "Failed test"
    exit 1
fi

echo 2 >> b
if ! pushy-status | grep -q -E "^b - file changed, changes not staged for commit"; then
    echo "Failed test"
    exit 1
fi

pushy-add b
if ! pushy-status | grep -q -E "^b - file changed, changes staged for commit"; then
    echo "Failed test"
    exit 1
fi


pushy-rm --cached b
if ! pushy-status | grep -q -E "^b - deleted from index"; then
    echo "Failed test"
    exit 1
fi

pushy-add b
if ! pushy-status | grep -q -E "^b - file changed, changes staged for commit"; then
    echo "Failed test"
    exit 1
fi

echo 3 >> b
if ! pushy-status | grep -q -E "^b - file changed, different changes staged for commit"; then
    echo "Failed test"
    exit 1
fi

pushy-commit -a -m "commit-2" >/dev/null
pushy-rm c
if ! pushy-status | grep -q -E "^c - file deleted, deleted from index"; then
    echo "Failed test"
    exit 1
fi

echo "Passed test"
exit 0

