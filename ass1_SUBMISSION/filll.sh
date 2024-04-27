count=0
# while [ "$count" -lt 10 ]
# do
#     touch "test0$count.sh"
#     echo '#!/bin/dash' > "test0$count.sh"
#     count=$((count + 1))
# done

while [ "$count" -le 1000 ]
do
    echo "$count" >> "a3test.txt"
    count=$((count + 1))
done
