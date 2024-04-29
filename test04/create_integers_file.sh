#!/bin/dash

touch "$3"
count=$1
while [ $count -le $2 ]
do
    echo "$count" >> "$3"
    count=$((count + 1))
done

