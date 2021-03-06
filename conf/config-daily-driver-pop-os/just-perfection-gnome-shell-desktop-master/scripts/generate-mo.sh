#!/bin/bash

# Script to generate locale MO files
#
# This Script is released under GPL v3 license
# Copyright (C) 2020 Just Perfection

set -e

# cd to the repo root
cd "$( cd "$( dirname "$0" )" && pwd )/.."

for filename in po/*.po;
do
    lang=$(basename "$filename" .po)
    moPath="locale/$lang/LC_MESSAGES/just-perfection.mo"
    mkdir -p "locale/$lang/LC_MESSAGES"
    msgfmt "$filename" --output-file="$moPath" && echo "$lang [OK]" || 
    	echo "ERROR: Failed to generate '$lang.po'."
done

