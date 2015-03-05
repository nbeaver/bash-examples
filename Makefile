SHELL := /bin/bash
all:
	./bash-script.sh &> out.sh
	less out.sh
