sowh.pl
======

INSTALLATION
------------

To install this script and documentation type the following:

    perl Makefile.PL
    make
    make install

DEPENDENCIES
------------

    This program requires:
        Perl (comes with most operating systems)
        RAxML v7.7 or higher (https://github.com/stamatak/standard-RAxML)
        Seq-Gen (http://tree.bio.ed.ac.uk/software/seqgen/)
        Statistics::R  (can be installed by running: sudo cpan Statistics::R

EXAMPLES
---

    see Examples.txt and the examples directory 

RUN
---
    sowh.pl \
    --constraint=NEWICK_CONSTRAINT_TREE \
    --aln=PHYLIP_ALIGNMENT \
    --name=NAME_FOR_REPORT \
    --model=MODEL \
    [--reps=NUMBER_OF_REPLICATES] \
    [--dir=DIR] \
    [--partition=PARTITION_FILE] \
    [--help] \
    [--version]


FURTHER READING
------------
Goldman, Nick, Jon P. Anderson, and Allen G. Rodrigo. "Likelihood-based tests of topologies in phylogenetics." Systematic Biology 49.4 (2000): 652-670.

COPYRIGHT AND LICENSE
------------

Copyright (C) 2013 Samuel H. Church, Joseph F. Ryan, Casey W. Dunn

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program in the file gpl.txt.  If not, see
http://www.gnu.org/licenses/.
