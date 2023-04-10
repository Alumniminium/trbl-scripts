#!/usr/bin/env bash

index=$1
delim=$2

if [[ -z $delim ]]; then
        echo 'delim zero'
        delim=' '
else
        echo "delim is $delim"
fi

echo "delim used: $delim"

for file in *.mp4 *.avi *.mov *.wmv *.flv *.mkv; do
        if [[ -f "$file" ]]; then
                newFile=$(echo "$file" | cut -d "$delim" -f "$index")
                newFile="${newFile%%.*}" # remove all file extensions
                newFile=$(echo "$newFile" | sed 's/^[[:space:]]*//') # remove leading spaces
                echo "$file |->  $newFile.mkv"

		if [[ $newFile =~ S[0-9]+E[0-9]+ ]]; then
                        mv "$file" "${newFile}.mkv"
                fi
        fi
done
