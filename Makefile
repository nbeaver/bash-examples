.PHONY : all
all : bash-examples.sh bash-example-output.txt readme.html

bash-examples.sh : examples-generator.sh Makefile example.txt filename\ with\ spaces.txt
	if test -f examples-generator.sh; then chmod +w examples-generator.sh; fi
	bash examples-generator.sh > bash-examples.sh 2>&1
	chmod -w examples-generator.sh

bash-example-output.txt: bash-examples.sh Makefile example.txt filename\ with\ spaces.txt
	if test -f bash-example-output.txt; then chmod +w bash-example-output.txt; fi
	bash bash-examples.sh > bash-example-output.txt 2>&1
	chmod -w bash-example-output.txt

readme.html : readme.rst
	rst2html readme.rst readme.html

clean:
	rm -f bash-examples.sh
	rm -f bash-example-output.txt
	rm -f readme.html
