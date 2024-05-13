#!/bin/dash

file="$(cat "$1" | sort)"
num="$(echo "$file" | head -1)"
prev=0
max="$(echo "$file" | tail -1)"
while ! [ -z "$file" ];
do
    if ! echo "$file" | grep -Eq "$num"; then
        if [ "$prev" -eq "$max" ]; then
            break
        fi
        echo "$num"
        break
    fi

    prev="$num"
    num="$((num + 1))"
done

