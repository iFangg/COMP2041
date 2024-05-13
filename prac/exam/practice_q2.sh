#!/bin/dash

grep -E "M$" | cut -d'|' -f2,3 | sort | uniq | cut -d'|' -f2,2 | cut -d',' -f1,1 | sort | uniq

