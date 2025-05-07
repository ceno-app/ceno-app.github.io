#!/bin/sh
# Usage: ./translations.sh
# List the languages with usable translations.

for dir in $(find . -type d -regex '.*\.src'); do
    prefix="$(basename ${dir%%.src} | sed s/^_//g)"
    echo $prefix
done
