==========================
Bash examples with output.
==========================

-------------
What is this?
-------------

See `<bash-examples.sh>`_.

----------
Motivation
----------

In examples of shell command usage,
there tend to be two different styles:
the commandline typescript style [#typescript_style]_
and the inline output style. [#inline_style]_

The typescript style looks like this::

    $ echo {01..09}
    01 02 03 04 05 06 07 08 09

It is intended to resemble the actual text in a terminal.

The inline output style looks like this::

    echo {01..09} # 01 02 03 04 05 06 07 08 09

It is intended to resemble comments in a shell script.

They both have advantages and disadvantages;
the typescript style is usually used for one-liners,
the inline tends to be used for longer scripts.

However, for saving examples to work from later,
neither of these options are ideal.
The typescript style is verbose and varies with the environment,
and the inline has to be done by hand.

To get around this,
I wrote a bunch of bash examples as functions,
showing the code via ``declare -f``
run it with another function and ``"$@"``,
and finally display the output as commented text.

This method has the undesirable side-effect
of stripping comments from the function,
but comments before and after the example
are passed through
and differentiated from the output
by indenting with a tab character (``\t``).

See `<examples-generator.sh>`_ for how this is accomplished.

--------------------
Questions & answers.
--------------------

:Q: Wouldn't the `IPython bash kernel`_ accomplish roughly the same thing?

:A: Probably, but it would also store everything as JSON,
    which requires escaping double quotes and newlines.
    I wanted to keep this a simple text file
    that could be used as raw material in larger bash scripts.

:Q: Wouldn't `xiki`_ do a better job of this?

:A: Possibly, but this doesn't require specialized software, just ``bash``.

.. _xiki: http://xiki.org/
.. _IPython bash kernel: http://jeroenjanssens.com/2015/02/19/ibash-notebook.html

.. [#typescript_style]

        The typescript—an intermingling of textual commands and their
        output—originates with the scrolls of paper on teletypes.

        --- Rob Pike, "Acme: A User Interface for Programmers"

    http://plan9.bell-labs.com/sys/doc/acme.html

   Examples of the typescript style:

   Official Bash documentation::

       bash$ echo a{d,c,b}e
       ade ace abe

   https://www.gnu.org/software/bash/manual/html_node/Brace-Expansion.html

   The Linux Documentation Project::

       franky ~> echo sp{el,il,al}l
       spell spill spall

   http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_03_04.html

   nixCraft:

       To view $RANDOM, enter::

           $ echo $RANDOM

       Sample outputs::

           11799

.. [#inline_style]
   Examples of the inline style:

   Wikipedia Bash page::

       echo {1..10}        # expands to 1 2 3 4 5 6 7 8 9 10

   Linux Journal::

       {aa,bb,cc,dd}  => aa bb cc dd
       {0..12}        => 0 1 2 3 4 5 6 7 8 9 10 11 12
       {3..-2}        => 3 2 1 0 -1 -2
       {a..g}         => a b c d e f g
       {g..a}         => g f e d c b a

   http://www.linuxjournal.com/content/bash-brace-expansion
