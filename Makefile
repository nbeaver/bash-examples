SHELL := /bin/bash
all:
	./bash-script.sh &> out.txt
	./bash-script.sh |& less
