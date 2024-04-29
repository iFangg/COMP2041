#!/bin/dash

date="$(echo "$(ls -l "$1")" | sed -E 's/.*([A-Z][a-z]{2}.*:[0-9]{2}).*$/\1/')"
# echo "$date"
convert -gravity south -pointsize 36 -draw "text 0,10 '$date'" $1 "$1"

