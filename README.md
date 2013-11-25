# SOWHAT


## DESCRIPTION


`sowhat` has not been tested extensively and is being actively developed. Please use with caution. We appreciate hearing about your experience with the program.

`sowhat` automates the steps required for the SOWH phylogenetic topology test (described by the manuscripts listed in FURTHER READING below). `sowhat` depends on the freely available Seq-Gen and RAxML software packages. It works on amino acid, nucleotide, and binary character state datasets. Partitions (including codon position partitioning) can be specified. It is also possible to use PhyloBayes to generate the null distribution for nucleotide and amino acid data. 

`sowhat` includes several features that aid in the interpretation and assessment of SOWH test results, including: 

- The option to account for variability in the maximum likelihood searches by estimating the test statistic and parameters for each new alignment.
- Tools for assessing if a sufficient number of replicates have been run. 


## AVAILABILITY


https://github.com/josephryan/sowh.pl (click the "Download ZIP" button at the bottom of the right column).


## INSTALLATION

### INSTALLING DEPENDENCIES


This program requires that the following are installed and available: 
- Perl (comes with most operating systems)
- [RAxML](https://github.com/stamatak/standard-RAxML), v7.7 or higher 
- [Seq-Gen](http://tree.bio.ed.ac.uk/software/seqgen/), v1.3.3 or higher
- The [Statistics::R](http://search.cpan.org/dist/Statistics-R/) Perl module. `Statistics::R` has additional requirements, as described at http://search.cpan.org/dist/Statistics-R/README. Use the `local::lib` option to install `Statistics::R` without `sudo`. See http://search.cpan.org/~ether/local-lib-1.008018/lib/local/lib.pm for more information.

Optional programs:
- [PhyloBayes](http://www.phylobayes.org)


## INSTALLING sowhat


To install SOWHAT and documentation type the following:

    perl Makefile.PL
    make
    make test
    make install



## EXAMPLES


See `examples.s`h for commands and the `examples/` directory for data files.

## RUN

    sowh.pl \
    --constraint=NEWICK_CONSTRAINT_TREE \
    --aln=PHYLIP_ALIGNMENT \
    --name=NAME_FOR_REPORT \
    --model=MODEL \
    --dir=DIR \
    [--rax=RAXML_BINARY_OR_PATH_PLUS_OPTIONS] \
    [--seqgen=SEQGEN_BINARY_OR_PATH_PLUS_OPTIONS] \
    [--usepb] \
    [--pb=PB_BINARY_OR_PATH_PLUS_OPTIONS] \
    [--pb_burn=BURNIN_TO_USE_FOR_PB_TREE_SIMULATIONS] \
    [--reps=NUMBER_OF_REPLICATES] \
    [--tests=NUMBER_OF_TESTS] \
    [--partition=PARTITION_FILE] \
    [--sowhat] \
    [--debug] \
    [--help] \
    [--version]

## DOCUMENTATION


Extensive documentation is embedded inside of sowh.pl in POD format and
can be viewed by running any of the following:

        sowh.pl --help
        perldoc sowh.pl
        man sowh.pl  # available after installation


## CITING

A manuscript describing `sowhat` and the performance of the SOWH test is currently under preparation. In the mean time, cite this repository and the manuscripts describing raxml, seq-gen, and, if used, phylobayes.


## FURTHER READING


Goldman, Nick, Jon P. Anderson, and Allen G. Rodrigo. "Likelihood-based tests of topologies in phylogenetics." Systematic Biology 49.4 (2000): 652-670. [doi:10.1080/106351500750049752](http://dx.doi.org/10.1080/106351500750049752)

Swofford, David L., Gary J. Olsen, Peter J. Waddell, and David M. Hillis. Phylogenetic inference. (1996): 407-514. http://www.sinauer.com/molecular-systematics.html




## COPYRIGHT AND LICENSE


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
along with this program in the file LICENSE.  If not, see
http://www.gnu.org/licenses/.
