#!/bin/dash

sort -k2,2 | cut -d'|' -f2,3 | uniq | sort -k1,1 -n | uniq | cut -d',' -f2,2 | cut -d' ' -f2,2 | sort