#!/bin/dash

snapshot-save.sh
cwd="$(pwd)"
cd ".snapshot.$1" || return
for file in *
do
    cp -r "$file" "$cwd"
done
echo "Restoring snapshot $1"

