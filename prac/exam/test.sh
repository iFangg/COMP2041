#!/bin/dash

cat "$1" | 
while read -r line;
do
    echo "hi"
    echo "$line"
done
