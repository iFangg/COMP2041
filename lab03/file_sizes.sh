#!/bin/dash
small=''
medium=''
large=''
for file in * 
do
    lines=$(wc -l < "$file")
    if [ "$lines" -lt 10 ]; then
        small="${small}$file "
    elif [ "$lines" -le 100 ]; then
        medium="${medium}$file "
    else
        large="${large}$file "
    fi
done

echo "Small files: $small"
echo "Medium-sized files: $medium"
echo "Large files: $large"
