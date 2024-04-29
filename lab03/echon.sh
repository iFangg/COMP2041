#!/bin/dash
if test "$#" -ne 2; then
    echo "Usage: ./echon.sh <number of lines> <string>"
elif ! echo "$1" | grep -q "^[0-9]\+$" || [ "$1" -lt 0 ]; then
    echo "./echon.sh: argument 1 must be a non-negative integer"
else
    number=1
    while [ "$number" -le "$1" ]
    do
        echo "$2"
        number=$((number + 1))
    done
fi

