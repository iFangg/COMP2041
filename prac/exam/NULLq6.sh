#!/bin/dash

file1="$(cat "$1" | sort)"
len1="$(echo $file1 | wc -l)"
file2="$(cat "$2" | sort)"
len2="$(echo $file2 | wc -l)"

if [ "$len1" -eq "$len2" ] && echo "$file2" | grep -Eq "$file1"; then
    echo "Mirrored"
    exit 0
fi

if [ "$len1" -ne "$len2" ]; then
    echo "Not mirrored: different number of lines: "$len1" versus "$len2""
    exit 0
fi

different="$(diff "$1" "$2")"
line="$(echo $different | grep -E '^[0-9]' | sed -E 's/^([0-9]+,?[0-9]*).*/\1/')"
# lines="$(echo "$line" | wc -m)"
if echo "$line" | grep -Eq "\,"; then
    echo "Not mirrored: lines $line"
else
    echo "Not mirrored: line $line different"
fi

exit 0

