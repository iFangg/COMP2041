#!/bin/dash

sort -k2,2 -t'|' "$@" |
cut -d'|' -f2-3 |
uniq -c |
grep -E '^ *2 ' |
sort -nr |
cut -d'|' -f1 |
sed -E "s/^\s+[0-9] //" |
sort -n
