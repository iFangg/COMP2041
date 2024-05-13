#!/bin/dash

# awards="$(grep -E "$1" "$2"| sort | cut -d'|' -f2,2 | sort | uniq)"
# if [ -z "$awards" ]; then
#     echo "No award matching '$1'"
#     exit 1
# fi

# year="$(echo "$awards" | head -1)"
# prev="$year"
# max="$(echo "$awards" | tail -1)"
# while [ "$prev" -ne "$max" ];
# do
#     if ! echo "$awards" | grep -Eq "$year"; then
#         echo "$year"
#     fi

#     prev="$year"
#     year="$((year + 1))"
# done

# Sample sol'n
years=$(grep -E "^$1\|" "$2" | sort -t'|' -k2 | cut -d'|' -f2)

if [ -z "$years" ]; then
    echo "No award matching '$1'" >&2
    exit 1
fi

start=$(echo "$years" | head -n1)
end=$(echo "$years" | tail -n1)

for year in $(seq "$start" "$end"); do
    if ! echo "$years" | grep -q "$year"; then
        echo "$year"
    fi
done

# OR

# Use process substitution instead of a temporary file
# Requires bash
# (Not a valid solution as not POSIX compliant)

# Given
# 1) a 'pipe seperated values' file with award winners
# in the format:
#   award name
#   award year
#   winner name
#   winner gender
#   winner country
#   winner birth year
# 2) The name of an award
#
# find all years in which the award was *not* given

# years=$(grep -E "^$1\|" "$2" | sort -t'|' -k2 | cut -d'|' -f2)

# if [ -z "$years" ]; then
#     echo "No award matching '$1'" >&2
#     exit 1
# fi

# start=$(echo "$years" | head -n1)
# end=$(echo "$years" | tail -n1)

# comm -23 <(seq "$start" "$end") <(echo "$years")
