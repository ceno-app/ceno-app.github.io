#!/bin/sh
# Usage: ./build.sh
# Takes HTML and MD pages from _en.dev, assembles them together in _en.src, then
# applies all _en.overwrite files.
set -e

rm -rf _en.src/
mkdir _en.src

yes | cp -rf _en.dev/* _en.src/

rm _en.src/\$card.html
rm _en.src/\$download.html
rm _en.src/\$template.html
rm _en.src/\$metadata.html

cd en

> "tmpmeta"
> "sortedmeta"
# Generates an index.html file in each directory, which holds a list of all the 
# markdown documents that are stored in that directory
for dir in $(find ../_en.src -type d -not -wholename "../_en.src"); do
    > "tmp"
    > "tmpmeta"
    > "sortedmeta"
    for md in $(find $dir -name "*.md"); do
        echo -e "$(pandoc --template=../_en.dev/\$metadata.html $md)$md" >> tmpmeta
    done
    echo "<main>" > tmp
    dirname=$(basename $dir)
    title=$(echo $dirname | tr - " ")
    echo "<h1 class='title'>$title</h1>" >> tmp
    echo "<section>" >> tmp
    cat tmpmeta | sort -r >> sortedmeta
    while read line; do
        md=$(echo $line | cut -d "%" -f2)
        pandoc --template=../_en.dev/\$card.html $md >> tmp
    done <sortedmeta
    echo "</section>" >> tmp
    echo "</main>" >> tmp
    mv "tmp" "$dir/index.html"
done
rm tmpmeta
rm sortedmeta

# Turn markdown documents into html
for md_src in $(find ../_en.src -regex '.*/[^_][^/]+\.md'); do
    page=${md_src%%.md}
    pandoc -s --template=../_en.dev/\$template.html $md_src -o "${md_src%%.md}.html"
done

cd ../_en.dev

# Search all files for occurrences of $DOWNLOAD and replace with download template
for html_src in $(find ../_en.src -regex '.*/[^_][^/]+\.html'); do
    sed -i '/$DOWNLOAD/{
        s/$DOWNLOAD//g
        r ../_en.dev/$download.html
        }' $html_src
done

cd ../
