#!/bin/dash

for c_file in "$@"
do
    include_list="$(cat "$c_file" | grep -E '^#include \".*\"' | sed -E 's/#include \"(.*)\"/\1/')"
    for file in $include_list
    do
        if ! [ -f "$file" ]; then
            echo "$file included into $c_file does not exist"
        fi
    done
done

