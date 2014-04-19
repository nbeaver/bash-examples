#!/usr/bin/env bash

# Treat unset variables and parameters other than the special parameters "@" and "*" as an error when performing parameter  expansion.
set -u
# set -o nonunset # longer version

# Terminate as soon as any command fails
set -e
# set -o errexit

# Using the if construct
if [ $# -lt 1 ]; then
    echo "No arguments."
    exit
fi

# http://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
for myfile in *.ext
do
    myfile_no_extension="${myfile%.*}"
    echo "$myfile"
done
