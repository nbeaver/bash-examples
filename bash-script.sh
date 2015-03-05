#!/usr/bin/env bash

comment() {
    printf -- "    # "
    printf -- "$*\n"
}
new_section() {
    printf -- '\n'
    printf -- '-------------------------------------------------------------------------------\n'
    printf -- '\n'
}
inspect_run() {
    comment "Function name:"
    comment "$1"
    comment "Function definition:"
    declare -f "$1"
    comment "Invocation:"
    comment "\$ $*"
    comment "Output of command:"
    "$@"
}
# Make output come out as comments.
alias echo='echo # '

echo '#=============================================================================='
echo '# Bash examples, with output of commands.'
echo '#=============================================================================='
echo ''

myfunc() {
    local num_args="$#"
    echo "number of args: $num_args"
}
comment 'Example of a bash function.'
inspect_run myfunc 1 2 3

# -----------------------------------------------------------------------------
new_section
comment "Checking a variable's name and value using the \`declare' shell builtin."
comment "$ MYVAR=1"
MYVAR=1
declare -p MYVAR

# -----------------------------------------------------------------------------
new_section

comment 'Shell arguments and quoting.'

split1() { for word in  $*;  do echo "\`$word\`";   done }
split2() { for word in  $*;  do echo "\`"$word"\`"; done }
split3() { for word in "$*"; do echo "\`$word\`";   done }
split4() { for word in "$*"; do echo "\`"$word"\`"; done }
split5() { for word in  $@;  do echo "\`$word\`";   done }
split6() { for word in  $@;  do echo "\`"$word"\`"; done }
split7() { for word in "$@"; do echo "\`$word\`";   done }
split8() { for word in "$@"; do echo "\`"$word"\`"; done }
show_arguments() {
    comment '# Number of arguments $# = `'$#\`
    comment '# All arguments $*   = `'$*\`
    comment '# All arguments $@   = `'$@\`
    comment '# All arguments "$*" = `'"$*"\`
    comment '# All arguments "$@" = `'"$@"\`
    comment '# Script name $0 = `'$0\`
    comment '# 1st argument $1   = `'$1\`
    comment '# 2nd argument $2   = `'$2\`
    comment '# 3rd argument $3   = `'$3\`
    comment '# 4th argument $4   = `'$4\`
    comment '# 1st argument "$1" = `'"$1"\`
    comment '# 2nd argument "$2" = `'"$2"\`
    comment '# 3rd argument "$3" = `'"$3"\`
    comment '# 4th argument "$4" = `'"$4"\`
    # TODO: make a for loop to do this?
    declare -f split1
    comment "Output of split1:"
    split1 "$@"
    declare -f split2
    comment "Output of split2:"
    split2 "$@"
    declare -f split3
    comment "Output of split3:"
    split3 "$@"
    declare -f split4
    comment "Output of split4:"
    split4 "$@"
    declare -f split5
    comment "Output of split5:"
    split5 "$@"
    declare -f split6
    comment "Output of split6:"
    split6 "$@"
    declare -f split7
    comment "Output of split7:"
    split7 "$@"
    declare -f split8
    comment "Output of split8:"
    comment "(This is probably the one you want.)"
    split8 "$@"
}
inspect_run show_arguments '*' '~' '$HOME' '   . .. ... .....    ' 
# http://stackoverflow.com/questions/12314451/accessing-bash-command-line-args-vs
# http://www.gnu.org/software/bash/manual/bashref.html#Special-Parameters
# http://stackoverflow.com/questions/255898/how-to-iterate-over-arguments-in-bash-script
# http://qntm.org/bash

# -----------------------------------------------------------------------------
new_section
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
comment "$ MYFILE='example.txt'"
MYFILE='example.txt'
comment "$ file_exists $MYFILE"
file_exists $MYFILE

# -----------------------------------------------------------------------------
new_section
comment "Testing a command's return value."
example_error() {
    echo "returning 1"
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
declare -f example_error
declare -f check_exit_code
comment "$ check_exit_code example_error"
check_exit_code example_error

# -----------------------------------------------------------------------------
new_section
comment "Testing piped commands for errors."
no_error(){
    echo "returning 0"
    return 0
}
another_error() {
    echo "returning 42"
    return 42;
}
print_pipe_errors() {
    printf "Running this:\n\t$*\n"
    eval "$*"'; RETURN_CODE_ARRAY=(${PIPESTATUS[@]})'
    # DANGER: this is for demonstration purposes only.
    # http://mywiki.wooledge.org/BashFAQ/050
    # Also, yes, that really is the best way to copy a Bash array.
    # https://stackoverflow.com/questions/6565694/left-side-failure-on-pipe-in-bash/6566171

    declare -p RETURN_CODE_ARRAY
    for INDEX in ${!RETURN_CODE_ARRAY[*]}
    do
        echo "#$INDEX return code: ${RETURN_CODE_ARRAY[$INDEX]}"
    done
    # http://www.linuxjournal.com/content/bash-arrays
}
print_pipe_errors 'no_error'
print_pipe_errors 'example_error | another_error'
print_pipe_errors 'no_error | no_error | example_error'
print_pipe_errors 'no_error | example_error | another_error'
print_pipe_errors 'echo "Hello, world." | tr . !'

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

# Terminate immediately as soon as anything returns a non-zero status.
set -e
# Undo that.
set +e

# Get error code of first command to fail in a pipeline,
# instead of the last one.
echo '	example_error | no_error'
example_error | no_error
echo '$? = '$?
set -o pipefail
echo '	example_error | no_error'
example_error | no_error
echo '$? = '$?
# Undo.
set +o pipefail

# All at the same time.
set -euo pipefail
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

# Undo all at the same time.
set +euo pipefail

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

# Integer comparison in if statements compared to C.
# Bash if: eq, ne, gt, ge, lt, le
#    C if: ==, !=, > , >=, < , <=

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

echo '-------------------------------------------------------------------------------'
echo 'Example of using the `if` construct with an explicit process return value.'
echo 'This is not unusual; in face, `if` construct always tests the return value of a process,'
echo 'since [ ] is shorthand for the `test` command.'
process_return_value_conditional() {
    if ping -c 1 google.com > /dev/null
    then
            echo '-------------------------------------------------------------------------------'
            echo 'Succesfully pinged google.com.'
    else
            echo '-------------------------------------------------------------------------------'
            echo 'Cannot ping google.com.'
    fi
}
# Put it in background in case it takes a while to return.
process_return_value_conditional &

echo '-------------------------------------------------------------------------------'
# http://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
strip_extensions() {
    for myfile in *.txt
    do
        echo "Filename with extension: $myfile"
        myfile_no_extension="${myfile%.*}"
        echo "Filename without extension: $myfile_no_extension"
    done
}
declare -f strip_extensions
strip_extensions

echo '-------------------------------------------------------------------------------'
echo '# Run through each line of a text file.'
readlines() {
    while read MYVAR
    do
        echo "$MYVAR" #MYVAR holds the line.
    done < ./example.txt
}
declare -f readlines
readlines
# http://stackoverflow.com/questions/1521462/looping-through-the-content-of-a-file-in-bash

echo '-------------------------------------------------------------------------------'
echo 'Read-only (immutable or constant) variables.'

function onetime_function {
    readonly local readonly_local_path="/tmp/"
    echo "$readonly_local_path"
}
declare -f onetime_function

echo "Unfortunately, these are inconvenient for shell functions,"
echo "because readonly variables can only be assigned once,"
echo "so this function can only be run once."
onetime_function
onetime_function

echo '-------------------------------------------------------------------------------'
echo 'Read a text file into a shell variable.'
TEXTFILE_CONTENTS=$(cat -- "./example.txt")
declare -p TEXTFILE_CONTENTS

echo '-------------------------------------------------------------------------------'
echo 'Before using cd(1) on a relative path,'
echo 'make sure to unset $CDPATH in case another script set it.'
CDPATH="/tmp/"
declare -p CDPATH
cd example/
unset CDPATH
cd example/
pwd
cd -
# https://bosker.wordpress.com/2012/02/12/bash-scripters-beware-of-the-cdpath/

echo '-------------------------------------------------------------------------------'
echo 'Splitting piplines with comments on each line.'
cat ./example.txt | # Output the file.
sort -n |           # Sort it numerically.
uniq |              # Remove repeats.
head -n 1           # Get the line beginning with the first (smallest) number.

echo '-------------------------------------------------------------------------------'
echo "Find directory script was called from, even if it's called from a symlink."
DIR="$(dirname "$0")"
declare -p DIR
# more robust for e.g. calling from a symlink:
FULL_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
declare -p FULL_PATH
# https://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in

echo '-------------------------------------------------------------------------------'
echo "Brace expansion examples."
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
