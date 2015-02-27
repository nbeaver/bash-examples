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
set -o nounset # equivalent longer version

# Now undo that.
set +u
set +o nounset

# Terminate as soon as any command fails.
set -e

# Show error code of first error in a pipe.
set -o pipefail

# All at the same time.
set -euo pipefail
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

# Undo all at the same time.
set +euo pipefail

# Testing if a file exists.
test -e myfile.txt

# Testing a command's return value and exiting if there is an error.
example_error() {
    return 1;
}
check_exit_code() {
    $* # run the command.
    ERROR_CODE=$?
    if [ $ERROR_CODE -ne 0 ]; then
        echo "The command '"$*"' failed with return code $ERROR_CODE."
    fi
}
check_exit_code example_error

# Testing piped commands for errors.
another_error() {
    return 42;
}
print_pipe_errors() {
    printf "Running this:\n\t$*\n"
    $*
    TEMP=("${PIPESTATUS[@]}")
    declare -p TEMP
    echo "TEMP: ${TEMP[@]}"
    if [ ${TEMP[0]} -ne 0 ]; then
        echo "1st command error: ${TEMP[0]}"
        echo "2nd command error: ${TEMP[1]}"
    elif [ ${TEMP[1]} -ne 0 ]; then
        echo "2nd command error: ${TEMP[1]}"
    else
        echo "TEMP: ${TEMP[@]}"
        echo "Both return codes = 0."
    fi
}
print_pipe_errors 'example_error | another_error'
print_pipe_errors echo "Hello, world." | tr . !

# https://stackoverflow.com/questions/6565694/left-side-failure-on-pipe-in-bash/6566171
# Yes, that really is the best way to copy an array.

# Using the if construct with arithmetic conditionals.
if [ $# -lt 1 ]; then
    echo "No arguments."
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

VAR=1
# Seeing a variable's value.
declare -p VAR
echo $VAR

## Using the if construct with process return values.
#if ping -c 1 google.com > /dev/null; then
#	echo 'Succesfully pinged google.com.'
#else
#	echo 'Cannot ping google.com.'
#fi
## Alternative syntax that is more symmetric.
#if ping -c 1 google.com > /dev/null
#then
#	echo 'Succesfully pinged google.com.'
#else
#	echo 'Cannot ping google.com.'
#fi

# Integer comparison in if statements
# eq, ne, gt, ge, lt, le
# ==, !=, > , >=, < , <=

# http://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
for myfile in *.txt
do
    echo "Filename with extension: $myfile"
    myfile_no_extension="${myfile%.*}"
    echo "Filename without extension: $myfile_no_extension"
done

# iterate over arguments separated by spaces.
# http://stackoverflow.com/questions/255898/how-to-iterate-over-arguments-in-bash-script
for var in "$@"
do
    echo "$var"
done

# Run through each line of a text file.
# http://stackoverflow.com/questions/1521462/looping-through-the-content-of-a-file-in-bash
while read MYVAR
do
    echo "$MYVAR" #MYVAR holds the line.
done < ./example.txt

# bash functions.
function myfunc {
local num_args="$#"
echo "number of args: $num_args"
declare -p num_args
}
# invoke the function
myfunc 1 2 3

# Read-only (immutable or constant) variables.
readonly readonly_path="/tmp/"
declare -p readonly_path

# Unfortunately, these are inconvenient for shell functions,
# because even if they're local,
# they still can only be assigned once,
# and so this function can only be run once:
function myfunc {
readonly local readonly_local_path="/tmp/"
echo "$readonly_local_path"
declare -p readonly_path
}

# read a text file into a shell variable.
TARGET=$(cat -- "./example.txt")

# If you cd to a relative path,
# make sure to do this, or the directory might be wrong.
echo $CDPATH
unset CDPATH
echo $CDPATH
# https://bosker.wordpress.com/2012/02/12/bash-scripters-beware-of-the-cdpath/

# Splitting piplines with comments on each line.
cat ./example.txt | # Output the file.
sort -n |           # Sort it numerically.
uniq |              # Remove repeats.
head -n 1           # Get the line beginning with the first (smallest) number.

# Find directory script was called from, even if it's called from a symlink.
DIR="$(dirname "$0")"
declare -p DIR
# more robust for e.g. calling from a symlink:
FULL_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
declare -p FULL_PATH
# https://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in

# Brace expansion
echo -n '{aa,bb,cc,dd} = '
echo {aa,bb,cc,dd} # aa bb cc dd
echo -n '{0..12} ='
echo {0..12}       # 0 1 2 3 4 5 6 7 8 9 10 11 12
echo -n '{3..-2} ='
echo {3..-2}       # 3 2 1 0 -1 -2
echo -n '{a..g} ='
echo {a..g}        # a b c d e f g
echo -n '{g..a} ='
echo {g..a}        # g f e d c b a
# http://www.linuxjournal.com/content/bash-brace-expansion
