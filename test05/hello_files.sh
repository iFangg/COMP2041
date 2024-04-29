#!/bin/dash

count=1
while [ "$count" -le "$1" ];
do
    echo "hello $2" > "hello$count.txt"
    count=$((count + 1))
done

