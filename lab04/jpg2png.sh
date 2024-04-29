#!/bin/dash


for img in *.jpg
do
    # echo "$img"
    newImg="$(echo "$img" | sed -E 's/\.jpg/.png/')"
    if [ -f "$newImg" ]; then
        echo "$newImg already exists"
    else
    #   echo "$newImg"
        convert "$img" "$newImg"
        rm "$img"
    fi
done
