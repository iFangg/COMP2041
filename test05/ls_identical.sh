#!/bin/dash

same_files=""

for fileA in "$1"/*;
do
    nameA="$(echo "$fileA" | sed -E "s/$1\///")"
    if [ "$nameA" = "*" ]; then
        continue
    fi
    for fileB in "$2"/*;
    do
        nameB="$(echo "$fileB" | sed -E "s/$2\///")"
        if [ "$nameB" = "*" ]; then
            continue
        fi
        if [ "$nameA" != "$nameB" ]; then
            continue
        fi
        if ! diff "$fileA" "$fileB" >/dev/null; then
            continue
        fi

        echo "$nameA"
    done
done



