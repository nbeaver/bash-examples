all:
	if test -f out.sh; then chmod +w out.sh; fi
	./bash-script.sh > out.sh 2>&1
	chmod -w out.sh
