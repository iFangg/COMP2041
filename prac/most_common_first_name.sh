#!/bin/dash

# cut -d'|' -f2,3 |
# sort -k1,1 |
# cut -d',' -f2,2 |
# cut -d' ' -f2,2 |
# sort |
# uniq -c |
# sort -nr |
# head -1 |
# sed -E 's/.*([A-Z][a-z]+).*$/\1/'

grep -E '^COMP(2041|9044)' |
cut -d'|' -f2,3 |
sort |
uniq 
# cut -d'|' -f2 |
# sed -E 's/[^,]+, ([^ ]+) .*/\1/' |
# sort |
# uniq -c |
# sort -k1,1rn -k2,2 |
# head -n1 |
# sed -E 's/^.*\s//'
