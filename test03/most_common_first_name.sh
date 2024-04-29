#!/bin/dash

sort -k2,2 |
cut -d'|' -f2,3 |
sort -k1,1 |
uniq |
cut -d'|' -f2 |
cut -d',' -f2 |
cut -d ' ' -f2 |
sort -k1,1 |
uniq -c |
sort -nr |
head -1 |
sed -E 's/^\s+[0-9]+ //'
