#!/bin/bash
# Usage: ./add-po-from-english-file.sh file e.g. ./add-po-from-english-file.sh file
# Creates blank po files in all languages. 
# Input file path is relative to _en.src/  e.g. passing index.pot = _en.src/index.pot

for lang in $(bash translations.sh); do
    pot="_en.src/$1"
    po="${pot%%.pot}.po"
    po_out="$(echo $po | sed "s#_en.src#_$lang.src#g")"
    # gross linux way of making sure path exists
    install -D /dev/null $po_out
    msginit -i $pot -o $po_out --locale $1 --no-translator
done