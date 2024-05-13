#!/bin/dash

# for file in "$@";
# do
#     if echo "$file" | grep -Eq "\."; then
#         echo "# "$file" already has an extension"
#         continue
#     fi

#     if ! cat "$file" | head -1 | grep -Eq "\#\!"; then
#         echo "# "$file" does not have a #! line"
#         continue
#     fi
    
#     extensions="$(cat "$file" | grep -E "(perl|python|sh)" | wc -l)"
#     lines="$(cat "$file" | grep -E "#!" | wc -l)"
#     if [ "$extensions" -ne "$lines" ]; then
#         echo "# "$file" no extension for #! line"
#         continue
#     fi

#     if cat "$file" | grep -Eq "python"; then
#         if [ -f "$file.py" ]; then
#             echo "# "$file.py" already exists"
#             continue
#         fi

#         touch "$file.py"
#         echo "mv $file $file.py"
#     fi

#     if cat "$file" | grep -Eq "env.*perl"; then
#         if [ -f "$file.pl" ]; then
#             echo "# "$file.pl" already exists"
#             continue
#         fi
 
#         touch "$file.pl"
#         echo "mv $file $file.pl"
#     fi

#     if cat "$file" | grep -Eq "bash"; then
#          if [ -f "$file.sh" ]; then
#             echo "# "$file.sh" already exists"
#             continue
#         fi

#         touch "$file.sh"
#         echo "mv $file $file.sh"
#     fi
# done


# Solution from past paper:
for pathname in "$@"; do

    case "$(head -1 "$pathname")" in
        *perl*)   extension="pl" ;;
        *python*) extension="py" ;;
        *sh*)     extension="sh" ;;
        *)        extension=""   ;;
    esac

    new_pathname="$pathname.$extension"

    if echo "$pathname" | grep -Eq '\.[^/]+$'; then
        echo "# $pathname already has an extension"
    elif [ "$(head -c 2 "$pathname")" != '#!' ]; then
        echo "# $pathname does not have a #! line"
    elif [ -z "$extension" ]; then
        echo "# $pathname no extension for #! line"
    elif [ -e "$new_pathname" ]; then
        echo "# $new_pathname already exists"
    else
        echo "mv $pathname $new_pathname"
    fi

done


