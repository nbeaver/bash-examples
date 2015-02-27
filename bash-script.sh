#!/usr/bin/env bash

show_arguments() {
    echo 'Number of arguments $# = `'$#\'
    echo 'All arguments $*   = `'$*\'
    for word in $*; do echo "\`$word'"; done
    for word in $*; do echo "\`"$word"'"; done
    echo 'All arguments $@   = `'$@\'
    for word in $@; do echo "\`$word'"; done
    for word in $@; do echo "\`"$word"'"; done
    echo 'All arguments "$*" = `'"$*"\'
    for word in "$*"; do echo "\`$word'"; done
    for word in "$*"; do echo "\`"$word"'"; done
    echo 'All arguments "$@" = `'"$@"\'
    for word in "$@"; do echo "\`$word'"; done
    for word in "$@"; do echo "\`"$word"'"; done
    echo 'Script name $0 = `'$0\'
    echo '1st argument $1   = `'$1\'
    echo '2nd argument $2   = `'$2\'
    echo '3rd argument $3   = `'$3\'
    echo '4th argument $4   = `'$4\'
    echo '1st argument "$1" = `'"$1"\'
    echo '2nd argument "$2" = `'"$2"\'
    echo '3rd argument "$3" = `'"$3"\'
    echo '4th argument "$4" = `'"$4"\'
}
show_arguments '*' '~' '$HOME' ' . .. ... .....    ' 
# http://stackoverflow.com/questions/12314451/accessing-bash-command-line-args-vs
# http://www.gnu.org/software/bash/manual/bashref.html#Special-Parameters

echo '-------------------------------------------------------------------------------'
# Make unset variables (and parameters other than the special parameters "@" and "*")
# produce an 'unbound variable' error.
set -u
set -o nounset # equivalent longer version

# Go back to the default of ignoring unset variables.
set +u
set +o nounset
echo "\$UNBOUND_VARIABLE = $UNBOUND_VARIABLE"
declare -p UNBOUND_VARIABLE

# Terminate as soon as any command fails.
set -e
# Undo that.
set +e

# Get error code of first command to fail in a pipeline.
set -o pipefail

# All at the same time.
set -euo pipefail
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

# Undo all at the same time.
set +euo pipefail

echo '-------------------------------------------------------------------------------'
echo "Checking a variable's name and value using the \`declare' shell builtin."
MYVAR=1
declare -p MYVAR

echo '-------------------------------------------------------------------------------'
file_exists() {
    echo "Testing if '"$MYFILE"' exists."
    if test -e example.txt
    then
        echo "$MYFILE exists."
        return 0
    else
        echo "$MYFILE does not exist."
        return 1
    fi
}
MYFILE='example.txt'
file_exists $MYFILE

echo '-------------------------------------------------------------------------------'
echo "Testing a command's return value."
example_error() {
    return 1;
}
check_exit_code() {
    printf "Running this:\n\t$*\n"
    $*
    ERROR_CODE=$?
    if [ $ERROR_CODE -ne 0 ]; then
        echo 'The command `'$*"' failed with return code $ERROR_CODE."
    fi
}
check_exit_code example_error

echo '-------------------------------------------------------------------------------'
printf "Testing piped commands for errors.\n"
no_error(){
    return 0
}
another_error() {
    return 42;
}
print_pipe_errors() {
    printf "Running this:\n\t$*\n"
    $*
    TEMP=("${PIPESTATUS[@]}")
    # Yes, that really is the best way to copy an array.
    # https://stackoverflow.com/questions/6565694/left-side-failure-on-pipe-in-bash/6566171
    declare -p TEMP
    echo "TEMP: ${TEMP[@]}"
    echo "PIPESTATUS: ${PIPESTATUS[@]}"
    if [ ${TEMP[0]} -ne 0 ]; then
        echo "1st command error: ${TEMP[0]}"
    elif [ ${TEMP[1]} -ne 0 ]; then
        echo "2nd command error: ${TEMP[1]}"
    elif [ ${TEMP[1]} -ne 0 ]; then
        echo "3rd command error: ${TEMP[2]}"
    else
        echo "TEMP: ${TEMP[@]}"
        echo "PIPESTATUS: ${PIPESTATUS[@]}"
        echo "Both return codes = 0."
    fi
}
print_pipe_errors 'no_error | no_error | example_error'
print_pipe_errors 'no_error | example_error | another_error'
print_pipe_errors 'echo "Hello, world." | tr . !'


echo '-------------------------------------------------------------------------------'
echo 'Using the if construct with arithmetic conditionals.'
check_num_arguments() {
    if [ $# -lt 1 ]; then
        echo "No arguments."
    else
        echo "Number of arguments: $#"
        echo "Arguments: $*"
    fi
}
check_num_arguments

echo '-------------------------------------------------------------------------------'
echo 'Test if a string is not empty.'
VAR="hello"
declare -p VAR
if [ -n "$VAR" ]; then
    echo "VAR is not empty"
fi

echo '-------------------------------------------------------------------------------'
echo 'Test if a variable is empty.'
VAR2=""
declare -p VAR2
if [ -z "$EMPTY" ]; then
    echo "VAR is empty"
fi
# http://timmurphy.org/2010/05/19/checking-for-empty-string-in-bash/


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
