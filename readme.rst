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

When showing examples of bash scripts,
there tend to be two different styles:
.. the commandline prompt style, [#prompt_style]_
.. and the inline output style. [#inline_style]_

The commandline/prompt style like this::

    $ echo {01..09}
    01 02 03 04 05 06 07 08 09

It is intended to resemble the output from a commandline.

The inline output style looks like this::

    echo {01..09} # 01 02 03 04 05 06 07 08 09

It is intended to resemble comments in a shell script.

They both have advantages and disadvantages;
the prompt style is usually used for one-liners,
the inline is tends to be used for longer scripts.

However, for saving examples to work from later,
neither of these options are ideal.
The prompt style has to be run manually,
and the inline is has to be done by hand.

To get around this,
I wrote a bunch of bash examples as functions,
show the code using ``declare -f``
(this loses comments, unfortunately),
run it with another function and ``"$@"``,
and finally display the output as commented text.

Comments are shown as well,
but are indented by a tab.

See `<examples-generator.sh>`_ for how this is accomplished.

--------------------
Questions & answers.
--------------------

:Q: Wouldn't the `IPython bash kernel`_ accomplish the same thing?

:A: Probably, but it would also store everything as JSON,
    which requires escaping double quotes and newlines.
    I wanted to keep this a simple text file
    that could be used as raw material in larger bash scripts.

:Q: Wouldn't `xiki`_ do a better job of this?

:A: Possibly, but this doesn't require specialized software, just ``bash``.

.. _xiki: http://xiki.org/
.. _IPython bash kernel: http://jeroenjanssens.com/2015/02/19/ibash-notebook.html

.. [#prompt_style]
   Examples of the prompt style:

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
