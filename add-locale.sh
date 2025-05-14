#!/bin/bash
# Usage: ./add-locale.sh <lang-code> e.g. ./add-locale es
# Creates all the po files and such for a new locale

mkdir _$1.src

cp -r _en.src/* _$1.src/

for pot in $(find ./_$1.src -name '*.pot'); do
    po="${pot%%.pot}.po"
    msginit -i $pot -o $po --locale $1 --no-translator
    rm $pot
done

mkdir -p $1


