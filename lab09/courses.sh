#!/bin/dash

course="$1"
courses=""
curl --location --silent "http://www.timetable.unsw.edu.au/2024/${1}KENS.html" | grep -E "$course" | cut -d'>' -f2,3 | sed -E "s/.*($1[0-9]{4}).*>([a-zA-Z ]+.*)<.*$/\1 \2/" | grep -vE "$course[0-9]{4} $course[0-9]{4}$" | sort | uniq
