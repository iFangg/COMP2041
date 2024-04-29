#!/bin/dash

cwd="$(pwd)"
for dir in "$@"
do
    cd "$dir" || exit
    for track in *.mp3
    do
        title="$(echo "$track" | cut -d'-' -f2 | sed -E 's/^ | $//')"
        id3 -t "$title" "$track" >/dev/null
        artist="$(echo "$track" | cut -d'-' -f3 | sed -E 's/^ | $//' | sed -E 's/.mp3$//')"
        id3 -a "$artist" "$track" >/dev/null
        album="$(pwd | sed -E 's/^.*\/(.*)/\1/')"
        id3 -A "$album" "$track" >/dev/null
        year="$(pwd | sed -E 's/^.*, //')"
        id3 -y "$year" "$track" >/dev/null
        track_no="$(echo "$track" | cut -d'-' -f1 | sed -E 's/ //g')"
        id3 -T "$track_no" "$track" >/dev/null
    done
    cd "$cwd" || exit
done

