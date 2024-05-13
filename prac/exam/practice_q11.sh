#!/bin/dash

# solutions from past paper
unset CDPATH

for d in "$1" "$2"; do
    (cd "$d" || exit 1; find . -type f)
done |
sort |
uniq | (
    same_size=0
    different_size=0
    tree1_only=0
    tree2_only=0
    while read pathname
    do
        if test ! -f "$2/$pathname"
        then
            tree1_only=$((tree1_only + 1))
        elif test ! -f "$1/$pathname"
        then
            tree2_only=$((tree2_only + 1))
        elif test "$(stat -c '%s' "$1/$pathname")" != "$(stat -c '%s' "$2/$pathname")"
        then
            different_size=$((different_size + 1))
        else
            same_size=$((same_size + 1))
        fi
    done
    echo $same_size $different_size $tree1_only $tree2_only
)
