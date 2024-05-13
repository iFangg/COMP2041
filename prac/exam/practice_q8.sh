#!/bin/dash

saved=""
for file1 in "$@";
do
    if echo "$saved" | grep -Eq "$file1"; then
        continue
    fi

    for file2 in "$@";
    do
        if echo "$saved" | grep -Eq "$file2"; then
            continue
        fi

        if [ "$file1" = "$file2" ]; then
            # echo "hi"
            continue
        fi
        if diff "$file1" "$file2" >/dev/null; then
            echo "ln -s $file1 $file2"
            if [ -z "$saved" ]; then
                saved="$file1 $file2"
            else
                saved="$saved $file1 $file2"
            fi
        fi
    done
done

if [ -z "$saved" ]; then
    echo "No files can be replaced by symbolic links"
fi


