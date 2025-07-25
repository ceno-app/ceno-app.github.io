#!/bin/bash
# Usage: ./publish.sh
# Takes _en.src, generates all locales, and builds all their sites
# with overwrites!

set -e

./build.sh

./pot-extract.sh

for lang in $(cat supported_locales); do
    if [ "$lang" != "en" ]; then
        ./gen-locale.sh $lang

        # Exclude Privacy Policy from translation, overwrite any translation with en version
        cp -f "_en.src/privacy_policy.html" "_$lang.src/privacy_policy.html"
    fi

    dir="ltr"

    RTL_LANGUAGES="ar fa ur"

    if echo "$RTL_LANGUAGES" | grep -qE "\b$lang\b"; then
        dir="rtl"
    fi


    pushd $lang

    # Finally, wrap all html files in _$lang.src/ in the header and footer and write the
    # output to $lang/

    echo "wrapping $lang"

    for html_src in $(find ../_$lang.src -regex '.*/[^_][^/]+\.html'); do
        html="$(echo $html_src | sed "s#../_$lang.src#.#g")"
        page="$(echo $html_src | sed -e "s#../_$lang.src/##g" -e "s#.html##g")"
        echo "$page"
        install -D /dev/null $html
        # TODO: Get from content source, but it must be in some translatable tag or attribute.
        # FIXME: When first adding a page, a placeholder page needs to be dropped in `en`
        # so that its title can be extracted here (it can just contain `<title>TITLE</title>`).
        title="$(sed -nE 's#.*<title>(.+)</title>.*#\1#p' "$html_src" | head -1)"

        tmp="$(mktemp)"
        echo '<!-- WARNING: Please do not edit this file directly, edit files in "en.dev" instead. -->' >> "$tmp"
        echo "<html lang="$lang" dir="$dir">" >> "$tmp"
        sed -e "s#@PAGE@#$page#g" -e "s#@TITLE@#$title#g" ../_$lang.src/_head.html >> "$tmp"
        cat "$html_src" >> "$tmp"
        sed -e "s#@PAGE@#$page#g" -e "s#@TITLE@#$title#g" ../_$lang.src/_tail.html >> "$tmp"
        echo '</body>' >> "$tmp"
        echo '</html>' >> "$tmp"
        sed -i "s#@LANG@#$lang#g" "$tmp" 
        mv "$tmp" "$html"
    done

    # Copy faq.html to support.html
    cp -f "../$lang/faq.html" "../$lang/support.html"

    popd
done
