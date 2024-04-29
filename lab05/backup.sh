#!/bin/dash

# if [ "$#" -ne 1 ]; then
#     echo "usage: backup.sh <file>"
#     exit 1
# fi

backup="$(find . -type f | grep -E "$1." | sed -E "s/.*\.([0-9]+)$/\1/" | sort -nr | head -1)"
if [ -z "$backup" ]; then
    backup=0
else
    backup=$((backup + 1))
fi
touch "$1.$backup"
cp "$1" ".$1.$backup"
echo "Backup of '$1' saved as '.$1.$backup'"

