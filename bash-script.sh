#!/usr/bin/env bash

# $# # number of arguments
# $* # all arguments
# $@ # all arguments
# http://stackoverflow.com/questions/12314451/accessing-bash-command-line-args-vs
# http://www.gnu.org/software/bash/manual/bashref.html#Special-Parameters
# $0 # script name
# $1 # 1st argument, last name
# $2 # 2nd argument, first name
# $9 # ninth argument

# Treat unset variables and parameters other than the special parameters "@" and "*" as an error when performing parameter  expansion.
set -u
# set -o nonunset # longer version

# Terminate as soon as any command fails
set -e

# Show error code of first error in a pipe.
set -o pipefail

# All at the same time.
set -euo pipefail

# http://redsymbol.net/articles/unofficial-bash-strict-mode/

# Testing if a file exists.
test -e myfile.txt
# Testing a command's return value and exiting if there is an error.
ERROR_CODE=$?
if [ $ERROR_CODE -ne 0 ]; then
    echo "Error: command failed."
    exit $ERROR_CODE
fi

# Using the if construct
if [ $# -lt 1 ]; then
    echo "No arguments."
    exit
fi

# Integer comparison in if statements
# eq, ne, gt, ge, lt, le
# ==, !=, > , >=, < , <=

# http://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
for myfile in *.ext
do
    myfile_no_extension="${myfile%.*}"
    echo "$myfile"
done
