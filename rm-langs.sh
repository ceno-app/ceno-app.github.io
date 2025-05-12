#!/bin/sh
# Usage: ./rm-langs.sh
# Deletes all output files

for lang in $(bash translations.sh); do
    rm -rf $lang/*
done