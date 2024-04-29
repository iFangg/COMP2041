#!/bin/dash

# show img
for img in $@
do
    # if ! [ "$img" = *.jpg$ -o "$img" = *.png$ ]; then
    #     echo "$img is not an image!"
    #     exit 1
    # fi
    display "$img"
    echo -n "Address to e-mail this image to? "
    read answer1
    email="$(echo "$answer1")"
    echo -n "Message to accompany image? "
    read answer2
    msg="$(echo "$answer2")"
    echo "$msg" | mutt -s "File sent!" -e 'set copy=no' -a $img -- "$email"
    echo -n "$img sent to $email \n"
done
