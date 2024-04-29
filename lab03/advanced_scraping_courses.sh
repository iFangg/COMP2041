#!/bin/dash

if test "$#" -ne 2; then
    echo "Usage: ./advanced_scraping_courses.sh <year> <course-prefix>"
elif ! echo "$1" | grep -q "^[0-9]\+$"; then
    echo "./advanced_scraping_courses.sh: argument 1 must be an integer between 2005 and 2023"
elif [ "$1" -le 2005 ] || [ "$1" -ge 2023 ]; then
    echo "./advanced_scraping_courses.sh: argument 1 must be an integer between 2005 and 2023"
else
    curl -s --cipher 'DEFAULT:!DH' -sL "https://legacy.handbook.unsw.edu.au/assets/json/search/${1}data.json" | jq -r 'if has("specifictitle") then "\(.code) \(.specifictitle) else "\(.code)" end else // empty end' | while read -r line; do
        if [ echo "$line" | grep -E '^$2']; then
            echo "$line"
        fi
    done

    # curl -s "https://www.handbook.unsw.edu.au/api/content/render/false/query/+unsw_psubject.implementationYear:$1%20+unsw_psubject.studyLevel:postgraduate%20+unsw_psubject.educationalArea:$2*%20+unsw_psubject.active:1%20+unsw_psubject.studyLevelValue:pgrd%20+deleted:false%20+working:true%20+live:true/orderby/unsw_psubject.code%20asc/limit/10000/offset/0" | jq -r '.contentlets[] | "\(.code) \(.title)"' | while read -r line; do
    #     echo "$line"
    # done 
fi

