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
# set -o nounset # longer version

# Terminate as soon as any command fails.
set -e

# Show error code of first error in a pipe.
set -o pipefail

# All at the same time.
set -euo pipefail
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

# Testing if a file exists.
test -e myfile.txt

# Testing a command's return value and exiting if there is an error.
mycommand
ERROR_CODE=$?
if [ $ERROR_CODE -ne 0 ]; then
    echo "Error: command failed."
    exit $ERROR_CODE
fi

# Testing piped commands for errors.
command1 | command2
TEMP=("${PIPESTATUS[@]}")
echo "TEMP: ${TEMP[@]}"
if [ ${TEMP[0]} -ne 0 ]; then
    echo "1st command error: ${TEMP[0]}"
elif [ ${TEMP[1]} -ne 0 ]; then
    echo "2nd command error: ${TEMP[1]}"
else
    echo "TEMP: ${TEMP[@]}"
    echo "Both return codes = 0."
fi
# https://stackoverflow.com/questions/6565694/left-side-failure-on-pipe-in-bash/6566171
# Yes, that really is the best way to copy an array.

# Using the if construct with arithmetic conditionals.
if [ $# -lt 1 ]; then
    echo "No arguments."
    exit
fi

# Test if a string is not empty.
VAR="hello"
if [ -n "$VAR" ]; then
    echo "VAR is not empty"
fi
# Test if a string is empty.
VAR=""
if [ -z "$VAR" ]; then
    echo "VAR is empty"
fi
# http://timmurphy.org/2010/05/19/checking-for-empty-string-in-bash/

# Using the if construct with process return values.
if ping -c 1 google.com > /dev/null; then
	wget http://www.google.com
else
	echo 'Cannot ping google.com.'
fi
# Alternative syntax.
if ping -c 1 google.com > /dev/null
then
	wget http://www.google.com
else
	echo 'Cannot ping google.com.'
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

# iterate over arguments separated by spaces.
# http://stackoverflow.com/questions/255898/how-to-iterate-over-arguments-in-bash-script
for var in "$@"
do
	echo "$var"
done

# Run through each line of a text file.
# http://stackoverflow.com/questions/1521462/looping-through-the-content-of-a-file-in-bash
while read line; do
	echo "$line"
done < ~/path/to/file.txt

# bash functions.
function myfunc {
	local num_args="$#"
	echo "number of args: $num_args"
}
# invoke the function
myfunc

# Read-only (immutable or constant) variables.
readonly mypath="/tmp/"

# Unfortunately, these are inconvenient for shell functions,
# because even if they're local,
# they still can only be assigned once,
# and so this function can only be run once:
function myfunc {
	readonly local mypath="/tmp/"
	echo "$mypath"
}

# read a text file into a shell variable.
TARGET=$(cat -- "myfile.txt")

# If you cd to a relative path,
# make sure to do this, or the directory might be wrong.
unset CDPATH
# https://bosker.wordpress.com/2012/02/12/bash-scripters-beware-of-the-cdpath/

# Splitting piplines with comments on each line.
cat myfile.txt | # Output the file.
sort -n |        # Sort it numerically.
uniq |           # Remove repeats.
head -n 1        # Get the line beginning with the first (smallest) number.

# Find directory script was called from.
DIR="$(dirname "$0")"
# more robust:
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
# https://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
