#!/bin/sh

#Redirect output to stderr
exec 1>&2

#Check for Bash scripts
files=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.sh$')

if [ -z "$files" ]; then
        exit 0
fi

#Loop through each staged file and check syntax
for file in $files; do
        if [ -f "$file" ]; then
                bash -n "$file"
                if [ $? -ne 0 ]; then
                        echo "Syntax error in: $file"
                        exit 1
                fi
        fi
done

echo "All Bash Scripts passed syntax check."
exit 0