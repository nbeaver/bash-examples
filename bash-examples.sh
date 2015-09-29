#!/usr/bin/env bash
	# ==============================================================================
	#  Bash examples, with output of commands.                                      
	# ==============================================================================
	# 
	# Conventions:
	# - Output is commented with # and a space, but not indented.
	# - Actual comments are indented and commented.
	# - Markdown-style backticks for quoting commands, e.g. `if`, not 'if' or `if'.

	# ------------------------------------------------------------------------------

	# Example of a bash function.
myfunc () 
{ 
    local num_args="$#";
    echo "Number of args: $num_args"
}
myfunc 1 2 3
# Number of args: 3

	# ------------------------------------------------------------------------------

	# Checking a variable's name and value using the `declare` shell builtin.
MYVAR=1; declare -p MYVAR
# declare -- MYVAR="1"

	# ------------------------------------------------------------------------------

	# Using `if` to check if a file exists.
file_exists () 
{ 
    local filename="$*";
    echo "Testing if file \`$filename\` exists...";
    if test -e "$filename"; then
        echo "\`$filename\` exists.";
        return 0;
    else
        echo "\`$filename\` does not exist.";
        return 1;
    fi
}
file_exists 'filename with spaces.txt'
# Testing if file `filename with spaces.txt` exists...
# `filename with spaces.txt` exists.

	# ------------------------------------------------------------------------------

	# Testing for string equality.
	# http://stackoverflow.com/questions/2600281/what-is-the-difference-between-operator-and-in-bash
string_equals_foo () 
{ 
    if test "$*" = 'foo'; then
        echo "$* = foo";
        return 0;
    else
        echo "$* != foo";
        return 1;
    fi
}
string_equals_foo 'foo'
# foo = foo
string_equals_foo 'bar'
# bar != foo
string_equals_foo 'foobar'
# foobar != foo

	# ------------------------------------------------------------------------------

	# Test if a variable is empty.
test_empty () 
{ 
    local VAR="";
    if test -z "$VAR"; then
        echo "VAR is empty.";
    else
        echo "VAR is not empty.";
    fi
}
test_empty
# VAR is empty.

	# This essentially means that:
	# test -z == ! test -n
	# http://timmurphy.org/2010/05/19/checking-for-empty-string-in-bash/

	# ------------------------------------------------------------------------------

	# Test if a variable is not empty.
not_empty () 
{ 
    local VAR="hello";
    if test -n "$VAR"; then
        echo "VAR is not empty.";
    else
        echo "VAR is empty.";
    fi
}
not_empty
# VAR is not empty.

	# ------------------------------------------------------------------------------

	# Using the if construct with arithmetic conditionals.
check_num_arguments () 
{ 
    if test $# -lt 1; then
        echo "No arguments.";
    else
        echo "Number of arguments: $#";
        echo "Arguments: $*";
    fi
}
check_num_arguments
# No arguments.
	# Integer comparison in `if` statements compared to C.
	#  Bash if: eq, ne, gt, ge, lt, le
	#     C if: ==, !=, > , >=, < , <=

	# ------------------------------------------------------------------------------

	# Using the `if` construct with an explicit process return value.
process_return_value_conditional () 
{ 
    local URL='localhost';
    if ping -c 1 "$URL" > /dev/null; then
        echo "Succesfully pinged $URL.";
    else
        echo "Cannot ping $URL.";
    fi
}
process_return_value_conditional
# Succesfully pinged localhost.
	# The `if` construct always tests the return value of a process,
	# since `[` is shorthand for the `test` command that must have a matching `]` bracket.
	# http://unix.stackexchange.com/a/99186

	# ------------------------------------------------------------------------------

strip_extensions () 
{ 
    for myfile in *.txt;
    do
        echo "Filename with extension: \`$myfile\`";
        myfile_no_extension="${myfile%.*}";
        echo "Filename without extension: \`$myfile_no_extension\`";
    done
}
strip_extensions
# Filename with extension: `bash-example-output.txt`
# Filename without extension: `bash-example-output`
# Filename with extension: `example.txt`
# Filename without extension: `example`
# Filename with extension: `filename with spaces.txt`
# Filename without extension: `filename with spaces`

	# ------------------------------------------------------------------------------

	# Simple text filter that reads stdin line by line.
	# In this case, it checks if the line is a path to an executable.
filter_executables () 
{ 
    while read line; do
        if test -d "$line"; then
            continue;
        else
            if test -x "$line"; then
                printf -- "$line\n";
            fi;
        fi;
    done
}
test_filter_executables () 
{ 
    printf '/bin/\n/bin/ls\n/bin/blah' | filter_executables
}
test_filter_executables
# /bin/ls

	# ------------------------------------------------------------------------------

	# Run through each line of a text file.
readlines () 
{ 
    while read MYVAR; do
        echo "$MYVAR";
    done < ./example.txt
}
readlines
# 1st line.
# 2nd line.
# 3rd line.

	# ------------------------------------------------------------------------------

	# Read a text file into a shell variable.
store_file_into_variable () 
{ 
    echo 'Contents of "example.txt":';
    cat -- "./example.txt";
    TEXTFILE_CONTENTS=$(cat -- "./example.txt");
    echo 'Contents of $TEXTFILE_CONTENTS:';
    echo "$TEXTFILE_CONTENTS"
}
store_file_into_variable
# Contents of "example.txt":
# 1st line.
# 2nd line.
# 3rd line.
# Contents of $TEXTFILE_CONTENTS:
# 1st line.
# 2nd line.
# 3rd line.

	# ------------------------------------------------------------------------------

	# Single quotes.
	# These do not require any escaping, even for backslashes.
	# The drawback is that single quotes contain escaped single quotes.
	# To quote the `bash` manual:
	# "A single quote may not occur between single quotes, even when preceded by a backslash."
	# https://www.gnu.org/software/bash/manual/html_node/Single-Quotes.html#Single-Quotes
	# Trying to escape single quotes inside single quotes with a backslash will throw these errors:
	# bash: unexpected EOF while looking for matching `''
	# bash: syntax error: unexpected end of file
echo '$SHELL `echo hi` \ *'
# $SHELL `echo hi` \ *

	# ------------------------------------------------------------------------------

	# ANSI-C single quotes.
	# These allow escaping of `"` and `'` don't expand `$` or '`'.
	# This means they can be convenient when regular single quotes or double quotes are not.
	# https://www.gnu.org/software/bash/manual/html_node/ANSI_002dC-Quoting.html#ANSI_002dC-Quoting
printf $'$SHELL `echo hi`\n'
# $SHELL `echo hi`
printf $' \a \b \e \E \f \n \r \t \v \\ \' \033 \x1B \uA1 \uBE \u212B \U10000 \cI \n'
#       
#   	  \ '   ¡ ¾ Å 𐀀 	 
printf $'\\\\a \\\\b \\\\e \\\\E \\\\f \\\\n \\\\r \\\\t \\\\v \\\\\ \\\\\' \\\\033 \\\\x1B \\\\uA1 \\\\uBE \\\\u212B \\\\U212B \\\\cI \\n'
# \a \b \e \E \f \n \r \t \v \\ \' \033 \x1B \uA1 \uBE \u212B \U212B \cI 

	# ------------------------------------------------------------------------------

	# Double quotes.
	# https://www.gnu.org/software/bash/manual/html_node/Double-Quotes.html#Double-Quotes
	# These are the characters that need to be escaped when using double quotes:
echo "\$ \` \" \\ \!"
# $ ` " \ \!
	# An example of what happens when they aren't escaped:
echo "$SHELL `echo hi`"
# /bin/bash hi
!
	# The `!` is for history expansions,
	# and failing to escape it will lead to errors such as:
# bash: !: event not found
	# but only if the shell is interactive and `histexpand` option is set.
	# 
	# Also, single quotes do not nest inside double quotes.
echo "'$SHELL'"
# '/bin/bash'
	# One way around this is to use quote concatenation.
echo "'"'$SHELL'"'"
# '$SHELL'
	# Another way is to use ANSI-C single quotes and backslashes.

	# ------------------------------------------------------------------------------

	# Quoting URLs can be difficult,
	# because while double quotes are not allowed in URLs,
	# single quotes and dollar signs are allowed in some URI schemes.
	# https://stackoverflow.com/questions/18251399/why-doesnt-encodeuricomponent-encode-sinlge-quotes-apostrophes
	# https://bugzilla.mozilla.org/show_bug.cgi?id=434211
	# https://bugzilla.mozilla.org/show_bug.cgi?id=407172
	# http://www.brandonporter.com/mozilla_bug/test%272.html
	# http://www.brandonporter.com/mozilla_bug/test'2.html
	# http://perishablepress.com/stop-using-unsafe-characters-in-urls/

	# ------------------------------------------------------------------------------

	# Quoting and `eval`.
using_eval () 
{ 
    local temp='echo $SHELL';
    declare -p temp;
    echo $temp;
    echo "$temp";
    echo '$temp';
    eval $temp;
    eval "$temp";
    eval '$temp'
}
using_eval
# declare -- temp="echo \$SHELL"
# echo $SHELL
# echo $SHELL
# $temp
# /bin/bash
# /bin/bash
# $SHELL

	# ------------------------------------------------------------------------------

	# Indirect expansion.
	# http://wiki.bash-hackers.org/syntax/pe#indirection
indirect_expansion () 
{ 
    local temp='SHELL';
    declare -p temp;
    echo "$temp";
    echo "${temp}";
    echo "${!temp}"
}
indirect_expansion
# declare -- temp="SHELL"
# SHELL
# SHELL
# /bin/bash

	# ------------------------------------------------------------------------------

	# The difference between the positional parameters `*` and `@` in a `for` loop.
	# http://stackoverflow.com/questions/12314451/accessing-bash-command-line-args-vs
	# http://www.gnu.org/software/bash/manual/bashref.html#Special-Parameters
IFS=$' \t\n'
split1 () 
{ 
    echo '$*='$*;
    for arg in $*;
    do
        echo "$arg";
    done
}
split1 '  -e  \n  ' '  *  '
# $*= -e \n bash-example-output.txt bash-examples.sh example examples-generator.sh example.txt filename with spaces.txt Makefile readme.rst
# 
# \n
# bash-example-output.txt
# bash-examples.sh
# example
# examples-generator.sh
# example.txt
# filename with spaces.txt
# Makefile
# readme.rst
split2 () 
{ 
    echo '$@='$@;
    for arg in $@;
    do
        echo "$arg";
    done
}
split2 '  -e  \n  ' '  *  '
# $@= -e \n bash-example-output.txt bash-examples.sh example examples-generator.sh example.txt filename with spaces.txt Makefile readme.rst
# 
# \n
# bash-example-output.txt
# bash-examples.sh
# example
# examples-generator.sh
# example.txt
# filename with spaces.txt
# Makefile
# readme.rst
split3 () 
{ 
    echo '"$*"='"$*";
    for arg in "$*";
    do
        echo "$arg";
    done
}
split3 '  -e  \n  ' '  *  '
# "$*"=  -e  \n     *  
#   -e  \n     *  
split4 () 
{ 
    echo '"$@"='"$@";
    for arg in "$@";
    do
        echo "$arg";
    done
}
split4 '  -e  \n  ' '  *  '
# "$@"=  -e  \n     *  
#   -e  \n  
#   *  
	# The split4() function is almost certainly the one you want.

	# ------------------------------------------------------------------------------

	# Shell arguments.
show_arguments () 
{ 
    echo 'Number of arguments $# = `'$#\`;
    echo 'All arguments $*   = `'$*\`;
    echo 'All arguments $@   = `'$@\`;
    echo 'All arguments "$*" = `'"$*"\`;
    echo 'All arguments "$@" = `'"$@"\`;
    echo 'Script name $0 = `'$0\`;
    echo 'Arguments 1 to '"$#"':';
    for arg in "$@";
    do
        echo "\`$arg\`";
    done
}
show_arguments '-e \n' '{a..z}' '!!' '$((2+2))' '*' '~' '$HOME' '\' '`pwd`' '$(pwd)'  '   . .. ... .....    '
# Number of arguments $# = `11`
# All arguments $*   = `-e \n {a..z} !! $((2+2)) bash-example-output.txt bash-examples.sh example examples-generator.sh example.txt filename with spaces.txt Makefile readme.rst ~ $HOME \ `pwd` $(pwd) . .. ... ..... `
# All arguments $@   = `-e \n {a..z} !! $((2+2)) bash-example-output.txt bash-examples.sh example examples-generator.sh example.txt filename with spaces.txt Makefile readme.rst ~ $HOME \ `pwd` $(pwd) . .. ... ..... `
# All arguments "$*" = `-e \n {a..z} !! $((2+2)) * ~ $HOME \ `pwd` $(pwd)    . .. ... .....    `
# All arguments "$@" = `-e \n {a..z} !! $((2+2)) * ~ $HOME \ `pwd` $(pwd)    . .. ... .....    `
# Script name $0 = `examples-generator.sh`
# Arguments 1 to 11:
# `-e \n`
# `{a..z}`
# `!!`
# `$((2+2))`
# `*`
# `~`
# `$HOME`
# `\`
# ``pwd``
# `$(pwd)`
# `   . .. ... .....    `
show_arguments  '-e \n' '{a..z}' '!!' '$((2+2))' '*' '~' '$HOME' '\' '`pwd`' '$(pwd)' '   . .. ... .....    '
# Number of arguments $# = `11`
# All arguments $*   = `-e \n {a..z} !! $((2+2)) bash-example-output.txt bash-examples.sh example examples-generator.sh example.txt filename with spaces.txt Makefile readme.rst ~ $HOME \ `pwd` $(pwd) . .. ... ..... `
# All arguments $@   = `-e \n {a..z} !! $((2+2)) bash-example-output.txt bash-examples.sh example examples-generator.sh example.txt filename with spaces.txt Makefile readme.rst ~ $HOME \ `pwd` $(pwd) . .. ... ..... `
# All arguments "$*" = `-e \n {a..z} !! $((2+2)) * ~ $HOME \ `pwd` $(pwd)    . .. ... .....    `
# All arguments "$@" = `-e \n {a..z} !! $((2+2)) * ~ $HOME \ `pwd` $(pwd)    . .. ... .....    `
# Script name $0 = `examples-generator.sh`
# Arguments 1 to 11:
# `-e \n`
# `{a..z}`
# `!!`
# `$((2+2))`
# `*`
# `~`
# `$HOME`
# `\`
# ``pwd``
# `$(pwd)`
# `   . .. ... .....    `
	# http://stackoverflow.com/questions/255898/how-to-iterate-over-arguments-in-bash-script
	# http://qntm.org/bash

	# ------------------------------------------------------------------------------

	# Debug a function using the `FUNCNAME` array.
this_function () 
{ 
    echo "From function \`${FUNCNAME[0]}\` in \`$0\` on line $LINENO:";
    for func in "${FUNCNAME[@]:1}";
    do
        echo "called by \`$func\`";
    done
}
caller_1 () 
{ 
    this_function
}
caller_2 () 
{ 
    caller_1
}
caller_3 () 
{ 
    caller_2
}
caller_3
# From function `this_function` in `examples-generator.sh` on line 435:
# called by `caller_1`
# called by `caller_2`
# called by `caller_3`
# called by `main`
	# http://stackoverflow.com/questions/9146623/in-bash-is-it-possible-to-get-the-function-name-in-function-body
	# http://www.tldp.org/LDP/abs/html/arrays.html

	# ------------------------------------------------------------------------------

	# Testing a command's return value.
example_error () 
{ 
    echo "From ${FUNCNAME[0]}: Returning error code 1.";
    return 1
}
check_exit_code () 
{ 
    printf "From ${FUNCNAME[0]}: Running this:\n$*\n";
    "$@";
    ERROR_CODE=$?;
    if [ $ERROR_CODE -ne 0 ]; then
        echo "From ${FUNCNAME[0]}: The command \`$*' failed with return code $ERROR_CODE.";
        return 1;
    fi
}
check_exit_code example_error "unnecessary" "arguments"
# From check_exit_code: Running this:
# example_error unnecessary arguments
# From example_error: Returning error code 1.
# From check_exit_code: The command `example_error unnecessary arguments' failed with return code 1.

	# ------------------------------------------------------------------------------

	# Testing if an external program is installed.
	# https://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script

	# ------------------------------------------------------------------------------

	# Testing piped commands for errors.
	# http://www.linuxjournal.com/content/bash-arrays
print_pipe_errors () 
{ 
    printf "${FUNCNAME[0]}: Running this:\n$*\n";
    eval "$*"'; RETURN_CODE_ARRAY=(${PIPESTATUS[@]})';
    declare -p RETURN_CODE_ARRAY;
    for INDEX in ${!RETURN_CODE_ARRAY[*]};
    do
        echo "$INDEX return code: ${RETURN_CODE_ARRAY[$INDEX]}";
    done;
    echo 'Extracted all return values.';
    echo ''
}
	# DANGER: this is for demonstration purposes only.
	# http://mywiki.wooledge.org/BashFAQ/050
	# And yes, this really is the best way to copy a Bash array:
	# RETURN_CODE_ARRAY=(${PIPESTATUS[@]})
	# https://stackoverflow.com/questions/6565694/left-side-failure-on-pipe-in-bash/6566171
error_42 () 
{ 
    echo "${FUNCNAME[0]}: returning 42";
    return 42
}
print_pipe_errors 'true'
# print_pipe_errors: Running this:
# true
# declare -a RETURN_CODE_ARRAY='([0]="0")'
# 0 return code: 0
# Extracted all return values.
# 
print_pipe_errors 'false | error_42'
# print_pipe_errors: Running this:
# false | error_42
# error_42: returning 42
# declare -a RETURN_CODE_ARRAY='([0]="1" [1]="42")'
# 0 return code: 1
# 1 return code: 42
# Extracted all return values.
# 
print_pipe_errors 'true | true | false'
# print_pipe_errors: Running this:
# true | true | false
# declare -a RETURN_CODE_ARRAY='([0]="0" [1]="0" [2]="1")'
# 0 return code: 0
# 1 return code: 0
# 2 return code: 1
# Extracted all return values.
# 
print_pipe_errors 'true | false | error_42'
# print_pipe_errors: Running this:
# true | false | error_42
# error_42: returning 42
# declare -a RETURN_CODE_ARRAY='([0]="0" [1]="1" [2]="42")'
# 0 return code: 0
# 1 return code: 1
# 2 return code: 42
# Extracted all return values.
# 
print_pipe_errors 'echo "Hello, world." | tr . !'
# print_pipe_errors: Running this:
# echo "Hello, world." | tr . !
# Hello, world!
# declare -a RETURN_CODE_ARRAY='([0]="0" [1]="0")'
# 0 return code: 0
# 1 return code: 0
# Extracted all return values.
# 

	# ------------------------------------------------------------------------------

	# Check if an item is in an array.
	# https://raymii.org/s/snippets/Bash_Bits_Check_If_Item_Is_In_Array.html
	# http://stackoverflow.com/questions/14366390/bash-if-condition-check-if-element-is-present-in-array
	# http://stackoverflow.com/questions/3685970/check-if-an-array-contains-a-value
in_array () 
{ 
    local item="$1";
    local array="$2[@]";
    for i in "${!array}";
    do
        if [ "$item" == "$i" ]; then
            echo "\`$item\` in ${array[@]}";
            return 0;
        fi;
    done;
    echo "\`$item\` not in ${array[@]}";
    return 1
}
declare -a MY_ARRAY='([0]="first" [1]="second" [2]="third")'
in_array "second" MY_ARRAY
# `second` in MY_ARRAY[@]
in_array "fourth" MY_ARRAY
# `fourth` not in MY_ARRAY[@]

	# ------------------------------------------------------------------------------

	# Associative arrays.
	# http://www.linuxjournal.com/content/bash-associative-arrays
declare -A long_option='([B]="braceexpand" [a]="allexport" )'
echo ${long_option["a"]}
# allexport

	# ------------------------------------------------------------------------------

	# Shell options.

	# ------------------------------------------------------------------------------

	# Turn on verbose mode, so each line (including comments) is echoed, then run.
set -v
# This is a comment.
echo "# Hello."
# Hello.
# Turn off verbose mode.
set +v

	# ------------------------------------------------------------------------------

	# Make accessing unset variables produce an 'unbound variable' error and exit the script.
	# Also works for parameters other than the special parameters "@" and "*"
	# https://unix.stackexchange.com/questions/56837/how-to-test-if-a-variable-is-defined-at-all-in-bash-prior-to-version-4-2-with-th
set -u
	# or
set -o nounset
	# read as `no unset`, not `noun set`.
enable_nounset () 
{ 
    echo "nounset disabled";
    echo "$-";
    echo "$SHELLOPTS";
    set -u;
    echo "nounset enabled";
    echo "$-";
    echo "$SHELLOPTS";
    set +o nounset;
    echo "nounset disabled again";
    echo "$-";
    echo "$SHELLOPTS"
}
enable_nounset
# nounset disabled
# hB
# braceexpand:hashall:interactive-comments
# nounset enabled
# huB
# braceexpand:hashall:interactive-comments:nounset
# nounset disabled again
# hB
# braceexpand:hashall:interactive-comments
nounset_error () 
{ 
    local MYVAR="test";
    set -o nounset;
    declare -p MYVAR;
    echo "$MYVAR";
    MYVAR="";
    declare -p MYVAR;
    echo "$MYVAR";
    unset MYVAR;
    echo "$MYVAR";
    set +o nounset;
    echo "$MYVAR"
}
	# We won't actually run `test_nounset` since it would crash the script.
#nounset_error
# declare -- MYVAR="test"
# test
# declare -- MYVAR=""
# 
# examples-generator.sh: line 732: MYVAR: unbound variable
	# Check if nounset is enabled.
check_nounset () 
{ 
    if [[ $- =~ u ]]; then
        echo 'nounset option is set.';
        return 0;
    else
        echo 'nounset option is not set.';
        return 1;
    fi
}
check_nounset
# nounset option is not set.
	# Testing a variable without crashing the script when `nounset` is enabled.
	# This method requires bash version 4.2 or later.
	# https://stackoverflow.com/questions/25032910/how-to-check-if-a-environment-variable-is-set-with-set-o-nounset
	# https://unix.stackexchange.com/questions/56837/how-to-test-if-a-variable-is-defined-at-all-in-bash-prior-to-version-4-2-with-th
test_unset_var () 
{ 
    local var1='blah';
    unset var1;
    if test -v var1; then
        echo "var1 is set.";
    else
        echo "var1 is unset.";
    fi
}
test_unset_var
# var1 is unset.

	# ------------------------------------------------------------------------------

	# Terminate immediately as soon as anything returns a non-zero status.
enable_errexit () 
{ 
    echo "$-";
    echo "$SHELLOPTS";
    set -e;
    echo "$-";
    echo "$SHELLOPTS";
    set +o errexit;
    echo "$-";
    echo "$SHELLOPTS"
}
enable_errexit
# hB
# braceexpand:hashall:interactive-comments
# ehB
# braceexpand:errexit:hashall:interactive-comments
# hB
# braceexpand:hashall:interactive-comments
test_errexit () 
{ 
    set +o errexit;
    echo "errexit disabled";
    false;
    set -o errexit;
    echo "errexit enabled";
    true;
    set +e;
    echo "errexit disabled again"
}
test_errexit
# errexit disabled
# errexit enabled
# errexit disabled again

	# ------------------------------------------------------------------------------

	# Get error code of first command to fail in a pipeline,
	# instead of the last one.
pipefail_example () 
{ 
    false | true;
    echo $?;
    set -o pipefail;
    false | true;
    echo $?;
    set +o pipefail;
    false | true;
    echo $?
}
pipefail_example
# 0
# 1
# 0

	# ------------------------------------------------------------------------------

	# Enable multiple options at once.
	# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
	# Disable multiple options at once.
set +euo pipefail

	# ------------------------------------------------------------------------------

	# Read-only (immutable or constant) variables.
readonly_var () 
{ 
    readonly local path="/tmp/";
    path="/usr/"
}
readonly_var
# examples-generator.sh: line 838: path: readonly variable
	# Unfortunately, this can be inconvenient for shell functions,
	# because readonly variables can only be assigned once even if the function is called many times.
onetime_func () 
{ 
    readonly local arg1="$1";
    echo "$arg1"
}
onetime_func\ first\ time
# first time
onetime_func\ second\ time
# second time

	# ------------------------------------------------------------------------------

	# Before using `cd` on a relative path,
	# make sure to `unset CDPATH` in case another script set it,
	# or you may get a puzzling 'No such file or directory' error.
	# https://bosker.wordpress.com/2012/02/12/bash-scripters-beware-of-the-cdpath/
cdpath_example () 
{ 
    mkdir -p ./example/;
    CDPATH="/tmp/";
    declare -p CDPATH;
    cd example/;
    unset CDPATH;
    cd example/
}
cdpath_example
# declare -- CDPATH="/tmp/"
# examples-generator.sh: line 870: cd: example/: No such file or directory

	# ------------------------------------------------------------------------------

	# Splitting piplines with comments on each line.
comment_pipeline() {
    cat ./example.txt | # Output the file.
    sort -n |           # Sort it numerically.
    uniq |              # Remove repeats.
    head -n 1           # Get the line beginning with the first (smallest) number.
}
set +v
comment_pipeline
# 1st line.

	# ------------------------------------------------------------------------------

	# Find directory script was called from, even if it's called from a symlink.
	# https://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
	# 
	# Note that there are often better solutions.
	# http://mywiki.wooledge.org/BashFAQ/028
DIR="$(dirname "$0")"; declare -p DIR
# declare -- DIR="."
	# A more robust method for e.g. calling from a symlink:
FULL_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd );

	# ------------------------------------------------------------------------------

	# Brace expansion examples.
	# http://www.linuxjournal.com/content/bash-brace-expansion
echo {aa,bb,cc,dd}
# aa bb cc dd
echo {0..12}
# 0 1 2 3 4 5 6 7 8 9 10 11 12
echo {3..-2}
# 3 2 1 0 -1 -2
echo {3..-2}
# 3 2 1 0 -1 -2
echo {a..g}
# a b c d e f g
echo {g..a}
# g f e d c b a
