#!/bin/dash

max=0
max_file=""
for file in "$@";
do
    len="$(wc -l "$file" | cut -d' ' -f1)"
    if [ "$max" -lt "$len" ]; then
        max="$len"
        max_file="$file"
    fi
done

echo "$max_file"

