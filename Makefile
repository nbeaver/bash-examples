all:
	chmod +w out.sh
	./bash-script.sh > out.sh 2>&1
	chmod -w out.sh
