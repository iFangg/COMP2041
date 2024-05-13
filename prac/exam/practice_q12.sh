#!/bin/dash

# doesn't work, haven't hashed out bugs
# curr_reachable="$1"
# visited=""
# next_reachable=""
# max=8
# min=1
# pos_change="-2 -1 1 2"

# while ! [ -z "$curr_reachable" ];
# do
#     echo "$curr_reachable"
#     for pos in $curr_reachable;
#     do
#         for i in $pos_change;
#         do
#             row="$(echo "$pos" | sed -E "s/[0-9]//" | sed -E "s/a/1/; s/b/2/; s/c/3/; s/d/4/; s/e/5/; s/f/6/; s/g/7/; s/h/8/; ")"
#             col="$(echo "$pos" | sed -E "s/[a-z]//")"

#             new_row="$(($row + $i))"
#             if [ "$new_row" -lt "$min" ] || [ "$new_row" -gt "$max" ]; then
#                 continue
#             fi

#             for j in $pos_change;
#             do
#                 if [ "$i" -eq "$j" ]; then
#                     continue
#                 fi

#                 new_col="$(($col + $j))"
#                 if [ "$new_col" -lt "$min" ] || [ "$new_col" -gt "$max" ]; then
#                     continue
#                 fi
#                 new_row="$(echo "$new_row" | sed -E "s/1/a/; s/2/b/; s/3/c/; s/4/d/; s/5/e/; s/6/f/; s/7/g/; s/8/h/; ")"
#                 new_pos="$new_row$new_col"
#                 if echo "$visited" | grep -Eq "$new_pos"; then
#                     continue
#                 fi

#                 if [ -z "$next_reachable" ]; then
#                     next_reachable="$new_pos"
#                 else
#                     next_reachable="$next_reachable $new_pos"
#                 fi
#             done

#         done

#         if [ -z "$visited" ]; then
#             visited="$pos"
#         else
#             visited="$visited $pos"
#         fi
#     done

#     curr_reachable="$(echo "$next_reachable" | tr ' ' '\n' | sort | tr '\n' ' ' | sed -E "s/.$/\n/")"
#     next_reachable=""
# done

# exit 0


# Solution from past paper
squares="$1"
squares_regex=XX

while test -n "$squares"
do
    echo "$squares"
    squares_regex="$squares_regex|$(echo "$squares"| tr ' ' '|')"
    # echo "regex is $squares_regex"
    squares="$(
        for square in $squares
        do
            column_number="$(echo "$square"|cut -c1|tr abcdefgh 12345678)"
            row_number="$(echo "$square"|cut -c2)"
            for column_delta in -2 -1 1 2
            do
                for row_delta in -2 -1 1 2
                do
                    test "$(echo $row_delta|tr -d -)" = "$(echo $column_delta|tr -d -)" &&
                        continue
                    new_row=$((row_number + row_delta))
                    new_column_number=$((column_number + column_delta))
                    new_column=$(echo $new_column_number|tr 12345678 abcdefgh)
                    echo "$new_column$new_row"
                done
            done
        done|
        sort|
        uniq|
        grep '^[a-h][1-8]$'|
        grep -Ev "$squares_regex"|
        tr '\n' ' '|
        sed 's/ *$//'
    )"
done
