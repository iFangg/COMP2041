#!/bin/dash

if test "$#" -ne 2; then
    echo "Usage: ./scraping_courses.sh <year> <course-prefix>"
elif [ "$1" -le 2019 ] || [ "$1" -ge 2023 ]; then
    echo "./scraping_courses.sh: argument 1 must be an integer between 2019 and 2023"
else
    curl -s "https://www.handbook.unsw.edu.au/api/content/render/false/query/+unsw_psubject.implementationYear:$1%20+unsw_psubject.studyLevel:undergraduate%20+unsw_psubject.educationalArea:$2*%20+unsw_psubject.active:1%20+unsw_psubject.studyLevelValue:ugrd%20+deleted:false%20+working:true%20+live:true/orderby/unsw_psubject.code%20asc/limit/10000/offset/0" | jq -r '.contentlets[] | "\(.code) \(.title)"' | while read -r line; do
        echo "$line"
    done

    curl -s "https://www.handbook.unsw.edu.au/api/content/render/false/query/+unsw_psubject.implementationYear:$1%20+unsw_psubject.studyLevel:postgraduate%20+unsw_psubject.educationalArea:$2*%20+unsw_psubject.active:1%20+unsw_psubject.studyLevelValue:pgrd%20+deleted:false%20+working:true%20+live:true/orderby/unsw_psubject.code%20asc/limit/10000/offset/0" | jq -r '.contentlets[] | "\(.code) \(.title)"' | while read -r line; do
        echo "$line"
    done 
fi

