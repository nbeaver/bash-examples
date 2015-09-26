.PHONY : all
all : bash-examples.sh bash-example-output.txt

bash-examples.sh : example-generator.sh Makefile example.txt filename\ with\ spaces.txt
	bash example-generator.sh > bash-examples.sh 2>&1

bash-example-output.txt: bash-examples.sh Makefile example.txt filename\ with\ spaces.txt
	bash bash-examples.sh > bash-example-output.txt 2>&1

clean:
	rm -f bash-examples.sh
	rm -f bash-example-output.txt
