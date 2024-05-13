#!/bin/dash

cut -d'|' -f2,3 | sort -k1,1 | uniq -c | grep -E '\s+2' | cut -d'|' -f1,1 | sed -E 's/\s+2 //'
