#!/bin/sh
# Usage: ./po-update.sh
# Update PO files with latest PO templates from `en`.

set -e

# HTML translations.
for po in $(find . -maxdepth 10 -name '*.po'); do
    pot="_en.src/$(echo "$po" | sed -E 's#^\./[^/]+/##')t"
    msgmerge -q --previous -U --backup=none "$po" "$pot"
done

# Image translations.
# for pot in $(find img -name '*.pot'); do
#     for po in "$(dirname "$pot")"/*.po; do
#         msgmerge -q --previous -U "$po" "$pot"
#     done
# done
