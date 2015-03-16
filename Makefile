.PHONY : all
all : out.sh out-out.log
out.sh : bash-script.sh Makefile example.txt filename\ with\ spaces.txt
	if test -f out.sh; then chmod +w out.sh; fi
	bash bash-script.sh > out.sh 2>&1
	chmod -w out.sh
out-out.log: out.sh Makefile example.txt filename\ with\ spaces.txt
	bash out.sh > out-out.log 2>&1
