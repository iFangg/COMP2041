#!/bin/dash

for file in *.htm
do
    html="$(echo "$file" | sed -E 's/(.*)\.htm$/\1.html/')"
    if [ -f "$html" ]; then
        echo "$html exists"
        exit 1
    fi
    mv "$file" "$html"
done

