#!/usr/bin/env bash

# TODO: `declare -f' does not show comments. This is a bit of a problem.
# We can't use `set -v`,
# because we won't be able to comment all the output,
# and when we turn it off with `set +v`,
# that command will be echoed as well.
# DONE: Make output runnable as a shell command.

comment() {
    printf -- "\t# "
    printf -- "$*\n"
}
new_section() {
    printf -- '\n'
    comment '------------------------------------------------------------------------------'
    printf -- '\n'
}
inspect_run() {
    echo "$*"
    "$@" |& sed 's/^/# /'
}


comment '=============================================================================='
comment ' Bash examples, with output of commands.                                      '
comment '=============================================================================='
comment ''

comment "Conventions:"
comment '- Output is commented with # and a space, but not indented.'
comment '- Actual comments are indented and commented.'
comment "- Markdown-style backticks for quoting commands, e.g. \`if\`, not 'if' or \`if'."

# -----------------------------------------------------------------------------
new_section

comment 'Example of a bash function.'
myfunc() {
    local num_args="$#"
    echo "Number of args: $num_args"
}
declare -f myfunc
inspect_run myfunc 1 2 3

# -----------------------------------------------------------------------------
new_section

comment "Checking a variable's name and value using the \`declare\` shell builtin."

echo 'MYVAR=1'
MYVAR=1
# TODO: why does
# inspect_run export "MYVAR=1"
# throw "MYVAR: not found"?
inspect_run declare -p MYVAR

# -----------------------------------------------------------------------------
new_section
comment 'Using `if` to check if a file exists.'

file_exists() {
    local filename="$*"
    echo "Testing if file \`$filename\` exists..."
    if test -e "$filename"
    then
        echo "\`$filename\` exists."
        return 0
    else
        echo "\`$filename\` does not exist."
        return 1
    fi
}
declare -f file_exists
inspect_run file_exists 'filename with spaces.txt'

# -----------------------------------------------------------------------------
new_section
comment 'Test if a variable is empty.'
empty() {
    local VAR=""
    if test -z "$VAR"
    then
        echo "VAR is empty."
    else
        echo "VAR is not empty."
    fi
}
declare -f empty
inspect_run empty

echo ''
comment 'This essentially means:'
comment 'test -z == ! test -n'
comment "http://timmurphy.org/2010/05/19/checking-for-empty-string-in-bash/"

# -----------------------------------------------------------------------------

new_section
comment 'Test if a variable is not empty.'
not_empty() {
    local VAR="hello"
    if test -n "$VAR"
    then
        echo "VAR is not empty."
    else
        echo "VAR is empty."
    fi
}
declare -f not_empty
inspect_run not_empty

comment 'test -n == ! test -z'

# -----------------------------------------------------------------------------
new_section
comment 'Using the if construct with arithmetic conditionals.'
check_num_arguments() {
    if test $# -lt 1
    then
        echo "No arguments."
    else
        echo "Number of arguments: $#"
        echo "Arguments: $*"
    fi
}
declare -f check_num_arguments
inspect_run check_num_arguments

comment 'Integer comparison in `if` statements compared to C.'
comment ' Bash if: eq, ne, gt, ge, lt, le'
comment '    C if: ==, !=, > , >=, < , <='

# -----------------------------------------------------------------------------
new_section
comment 'Using the `if` construct with an explicit process return value.'
process_return_value_conditional() {
    local URL='localhost'
    if ping -c 1 "$URL" > /dev/null
    then
            echo "Succesfully pinged $URL."
    else
            echo "Cannot ping $URL."
    fi
}
declare -f process_return_value_conditional
inspect_run process_return_value_conditional

comment 'The `if` construct always tests the return value of a process,'
comment 'since `[` is shorthand for the `test` command that must have a matching `]` bracket.'
comment 'http://unix.stackexchange.com/a/99186'
# TODO: example of negating return value with `!'.

# -----------------------------------------------------------------------------
new_section
# Strip the file extension for e.g. generating the name of an output file.
strip_extensions() {
    for myfile in *.txt
    do
        echo "Filename with extension: \`$myfile\`"
        myfile_no_extension="${myfile%.*}"
        echo "Filename without extension: \`$myfile_no_extension\`"
    done
}
declare -f strip_extensions
inspect_run strip_extensions

# http://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
# -----------------------------------------------------------------------------
new_section
comment 'Run through each line of a text file.'
readlines() {
    while read MYVAR
    do
        echo "$MYVAR" #MYVAR holds the line.
    done < ./example.txt
}
declare -f readlines
inspect_run readlines
# http://stackoverflow.com/questions/1521462/looping-through-the-content-of-a-file-in-bash

# -----------------------------------------------------------------------------
new_section
comment 'Read a text file into a shell variable.'
store_file_into_variable() {
    echo 'Contents of "example.txt":'
    cat -- "./example.txt"
    TEXTFILE_CONTENTS=$(cat -- "./example.txt")
    echo 'Contents of $TEXTFILE_CONTENTS:'
    echo "$TEXTFILE_CONTENTS"
}
declare -f store_file_into_variable
inspect_run store_file_into_variable

# -----------------------------------------------------------------------------
new_section

comment 'Quoting and eval.'

using_eval() {
    local temp='echo $SHELL'
    declare -p temp
    echo $temp
    echo "$temp"
    echo '$temp'
    eval $temp
    eval "$temp"
    eval '$temp'
}
declare -f using_eval
inspect_run using_eval

# -----------------------------------------------------------------------------
new_section

comment 'Indirect expansion.'

indirect_expansion() {
    local temp='SHELL'
    declare -p temp
    echo "$temp"
    echo "${temp}"
    echo "${!temp}"
}
declare -f indirect_expansion
inspect_run indirect_expansion

comment "http://wiki.bash-hackers.org/syntax/pe#indirection"
# -----------------------------------------------------------------------------
new_section

comment 'Shell arguments and the difference between `$*` and `$@`.'

split1() { for word in  $*;  do echo $word;   done }
split2() { for word in  $*;  do echo "$word"; done }
split3() { for word in "$*"; do echo $word;   done }
split4() { for word in "$*"; do echo "$word"; done }
split5() { for word in  $@;  do echo $word;   done }
split6() { for word in  $@;  do echo "$word"; done }
split7() { for word in "$@"; do echo $word;   done }
split8() { for word in "$@"; do echo "$word"; done }
for i in {1..8}
do
    declare -f split$i
done
comment "The split8() function is probably the one you want."
comment "See below for the reason why."
show_arguments() {
    echo 'Number of arguments $# = `'$#\`
    echo 'All arguments $*   = `'$*\`
    echo 'All arguments $@   = `'$@\`
    echo 'All arguments "$*" = `'"$*"\`
    echo 'All arguments "$@" = `'"$@"\`
    echo 'Script name $0 = `'$0\`
    echo 'Arguments 1 to '"$#"':'
    for arg in "$@"
    do
        # Use backticks to make whitespace visible.
        echo "\`$arg\`"
    done
    for i in {1..8}
    do
        echo "Running split$i():"
        split$i "$@"
    done
}
declare -f show_arguments
# Alternative methods to achive this:
# printf -- "show_arguments '-e' '*' '~' '\$HOME' '\\\\' '\`pwd\`' '\$(pwd)'  '   . .. ... .....    ' \n"
# echo show_arguments\ \'-e\'\ \'\*\'\ \'\~\'\ \'\$HOME\'\ \'\\\'\ \'\`pwd\`\'\ \'\$\(pwd\)\'\ \ \'\ \ \ \.\ \.\.\ \.\.\.\ \.\.\.\.\.\ \ \ \ \'\ 
# "A single quote may not occur between single quotes, even when preceded by a backslash."
# https://www.gnu.org/software/bash/manual/html_node/Single-Quotes.html#Single-Quotes

comment "This is how it looks in the script before the shell does quote removal and expansion and such:"
echo "show_arguments '-e \n' '{a..z}' '*' '~' '\$HOME' '\\' '\`pwd\`' '\$(pwd)'  '   . .. ... .....    ' "
comment "Now let's run the command with those arguments:"
inspect_run show_arguments '-e \n' '{a..z}' '$((2+2))' '*' '~' '$HOME' '\' '`pwd`' '$(pwd)'  '   . .. ... .....    ' 
comment "http://stackoverflow.com/questions/12314451/accessing-bash-command-line-args-vs"
comment "http://www.gnu.org/software/bash/manual/bashref.html#Special-Parameters"
comment "http://stackoverflow.com/questions/255898/how-to-iterate-over-arguments-in-bash-script"
comment "http://qntm.org/bash"

# -----------------------------------------------------------------------------
new_section
comment "Debug a function using the \`FUNCNAME\` array."

this_function() {
    echo "From function \`${FUNCNAME[0]}\` in \`$0\` on line $LINENO:"
    # If we used "${FUNCNAME[@]}"
    # we would get all the elements,
    # but we only want the second one onward.
    for func in "${FUNCNAME[@]:1}"
    do
        echo "called by \`$func\`"
    done
}
declare -f this_function

caller_1() {
    this_function
}
caller_2() {
    caller_1
}
caller_3() {
    caller_2
}
for i in {1..3}
do
    declare -f caller_$i
done
# We have to do this manually,
# or the inspect_run function will show up in the output.
echo 'caller_3'
caller_3 |& sed 's/^/# /'

comment "http://stackoverflow.com/questions/9146623/in-bash-is-it-possible-to-get-the-function-name-in-function-body"
comment "http://www.tldp.org/LDP/abs/html/arrays.html"

# -----------------------------------------------------------------------------
new_section
comment "Testing a command's return value."
example_error() {
    echo "From ${FUNCNAME[0]}: Returning error code 1."
    return 1;
}
declare -f example_error

check_exit_code() {
    printf "From ${FUNCNAME[0]}: Running this:\n$*\n"
    "$@"
    ERROR_CODE=$?
    if [ $ERROR_CODE -ne 0 ]; then
        echo "From ${FUNCNAME[0]}: The command \`$*' failed with return code $ERROR_CODE."
        return 1
    fi
}
declare -f check_exit_code

inspect_run check_exit_code example_error "unnecessary" "arguments"

# -----------------------------------------------------------------------------
new_section
comment "Testing if an external program is installed."

is_wget_installed() {
    if ! hash wget
    then
        echo "Error: Please install wget."
        return 1
    fi
}

comment "https://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script"

# -----------------------------------------------------------------------------
new_section
comment "Testing piped commands for errors."
no_error(){
    echo "${FUNCNAME[0]}: returning 0"
    return 0
}
another_error() {
    echo "${FUNCNAME[0]}: returning 42"
    return 42;
}
print_pipe_errors() {
    printf "${FUNCNAME[0]}: Running this:\n$*\n"
    eval "$*"'; RETURN_CODE_ARRAY=(${PIPESTATUS[@]})'
    # DANGER: this is for demonstration purposes only.
    # http://mywiki.wooledge.org/BashFAQ/050
    # Also, yes, that really is the best way to copy a Bash array.
    # https://stackoverflow.com/questions/6565694/left-side-failure-on-pipe-in-bash/6566171

    declare -p RETURN_CODE_ARRAY
    for INDEX in ${!RETURN_CODE_ARRAY[*]}
    do
        echo "$INDEX return code: ${RETURN_CODE_ARRAY[$INDEX]}"
    done
    echo 'Extracted all return values.'
    echo ''
    # http://www.linuxjournal.com/content/bash-arrays
}
declare -f print_pipe_errors
declare -f no_error
declare -f another_error

inspect_run print_pipe_errors 'no_error'

inspect_run print_pipe_errors 'example_error | another_error'

inspect_run print_pipe_errors 'no_error | no_error | example_error'

inspect_run print_pipe_errors 'no_error | example_error | another_error'

inspect_run print_pipe_errors 'echo "Hello, world." | tr . !'

# -----------------------------------------------------------------------------
new_section

comment "Check if an item is in an array."

#TODO: check for empty array
in_array() {
    local item="$1"
    local array="$2[@]"
    for i in "${!array}"
    do
        if [ "$item" == "$i" ]
        then
            echo "\`$item\` in ${array[@]}"
            return 0
        fi
    done
    echo "\`$item\` not in ${array[@]}"
    return 1
}
declare -f in_array

MY_ARRAY=("first" "second" "third")

declare -p MY_ARRAY

inspect_run in_array "second" MY_ARRAY

inspect_run in_array "fourth" MY_ARRAY

comment "https://raymii.org/s/snippets/Bash_Bits_Check_If_Item_Is_In_Array.html"
comment "http://stackoverflow.com/questions/14366390/bash-if-condition-check-if-element-is-present-in-array"
comment "http://stackoverflow.com/questions/3685970/check-if-an-array-contains-a-value"

# -----------------------------------------------------------------------------
new_section

comment "Associative arrays."

declare -A long_option
long_option[a]=allexport
long_option[B]=braceexpand

declare -p long_option

echo 'echo ${long_option["a"]}'
eval 'echo ${long_option["a"]}'
# We can't use inspect_run here,
# because the shell will expand it too soon,
# and it will just be this:
# echo allexport

comment "http://www.linuxjournal.com/content/bash-associative-arrays"

# -----------------------------------------------------------------------------
new_section

comment "Shell options."

check_short_option() {
    # e.g. $- = himBH
    if [[ $- =~ $* ]]
    then
        echo "Short option \`$*\` is enabled: \$- = $-"
        return 0
    else
        echo "Short option \`$*\` is disabled: \$- = $-"
        return 1
    fi
}

check_long_option() {
    local TMP="$IFS"
    local IFS=':'
    local LONG_OPTS
    read -ra LONG_OPTS <<< "$SHELLOPTS"
    # http://stackoverflow.com/questions/918886/how-do-i-split-a-string-on-a-delimiter-in-bash
    local IFS="$TMP"
    if in_array "$*" LONG_OPTS
    then
        echo "Long option \`$*' is enabled: \$SHELLOPTS=$SHELLOPTS"
        return 0
    else
        echo "Long option \`$*' is disabled: \$SHELLOPTS=$SHELLOPTS"
        return 1
    fi
}

check_option() {
    local args="$*"
    local num_characters=${#args}
    if [ $num_characters -gt 1 ]
    then
        check_long_option "$*"
        return $?
    elif [ $num_characters -eq 1 ]
    then
        check_short_option "$*"
        return $?
    else
        echo 'Usage: check_option <option-name>'
        return 2
    fi
}

# -----------------------------------------------------------------------------
new_section

comment "Turn on verbose mode, so each line (including comments) is echoed, then run."
set -v
# Turn on verbose mode.
set -v
# This is a comment.
echo "# Hello."
# Turn off verbose mode.
set +v


# -----------------------------------------------------------------------------
new_section

comment 'Make unset variables (and parameters other than the special parameters "@" and "*")'
comment "produce an 'unbound variable' error."

set -u
check_option nounset
check_option u
set -o nounset # equivalent longer version
# Go back to the default of ignoring unset variables.
set +u
set +o nounset

echo "\$UNBOUND_VARIABLE = $UNBOUND_VARIABLE"
declare -p UNBOUND_VARIABLE

# Terminate immediately as soon as anything returns a non-zero status.
# set -e
set -o errexit
if [[ $- =~ e ]]
then
    echo 'errexit option is set.'
else
    echo 'errexit option is not set.'
fi
# Undo that.
set +e
set +o errexit

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
