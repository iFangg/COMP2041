#!/bin/dash

backup="$(find . -type d | grep -E ".snapshot." | sed -E "s/.*\.([0-9]+)$/\1/" | sort -nr | head -1)"
if [ -z "$backup" ]; then
    backup=0
else
    backup=$((backup + 1))
fi
mkdir ".snapshot.$backup"
for file in *
do
    # echo "$file"
    if [ "$file" != "snapshot-load.sh" -a "$file" != "snapshot-save.sh" ]; then
        cp -r "$file" ".snapshot.$backup"
    fi
done

echo "Creating snapshot $backup"


