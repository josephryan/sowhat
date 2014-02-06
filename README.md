# SOWHAT


## DESCRIPTION


`sowhat` has not been tested extensively and is being actively developed. Please use with caution. We appreciate hearing about your experience with the program.

`sowhat` automates the steps required for the SOWH phylogenetic topology test (described by the manuscripts listed in FURTHER READING below). `sowhat` depends on the freely available Seq-Gen and RAxML software packages. It works on amino acid, nucleotide, and binary character state datasets. Partitions (including codon position partitioning) can be specified. It is also possible to use PhyloBayes to generate the null distribution for nucleotide and amino acid data. 

`sowhat` includes several features that aid in the interpretation and assessment of SOWH test results, including: 

- The option to account for variability in the maximum likelihood searches by estimating the test statistic and parameters for each new alignment.
- Tools for assessing if a sufficient number of replicates have been run. 


## AVAILABILITY


https://github.com/josephryan/sowhat (click the "Download ZIP" button at the bottom of the right column).


## INSTALLATION

### SYSTEM REQUIREMENTS

We have tested `sowhat` on OS X 10.9 and Ubuntu 13.04. It will likely work on a variety 
of other Unix-like operating systems.

### DEPENDENCIES

The dependencies listed below are required by `sowhat`. They must be installed and 
available in the appropriate PATH. If they are not installed already, follow the 
installation instructions in the links provided for each tool. We have tested `sowhat` 
with the indicated dependency versions. Other versions may be incompatible, and should be 
used with caution.

Phylogenetic programs: 
- [RAxML](https://github.com/stamatak/standard-RAxML), v7.7 
- [Seq-Gen](http://tree.bio.ed.ac.uk/software/seqgen/), v1.3.3

General system tools:
- [Perl](http://www.cpan.org/), which comes with most operating systems
- [R](http://www.r-project.org/)
- The [Statistics::R](http://search.cpan.org/dist/Statistics-R/) Perl module. `Statistics::R` has additional requirements, as described at http://search.cpan.org/dist/Statistics-R/README. Use the `local::lib` option to install `Statistics::R` without `sudo`. See http://search.cpan.org/~ether/local-lib-1.008018/lib/local/lib.pm for more information.

To use more complex models, you will need to install the following optional dependency:
- [PhyloBayes](http://www.phylobayes.org)

You can install all the required dependencies listed above on Ubuntu 13.04 with the 
following commands (executables will be placed in `/usr/local/bin`):

    sudo ./build_3rd_party.sh
    sudo apt-get install r-base-core
    sudo apt-get install cpanminus
    sudo cpanm Statistics::R

Note that `build_3rd_party.sh` installs some dependencies from versions that are cached in 
this repository. They may be out of date.

## INSTALLATION

To install `sowhat` and documentation, type the following:

    perl Makefile.PL
    make
    make test
    sudo make install



## EXAMPLE ANALYSES

Several test datasets are provided in the `examples/` directory. To run example analyses 
on these datasets, execute:

    ./examples.sh
    

See `examples.sh` and the resulting `test.output/` directory for more on the specifics of 
`sowhat` use.

## RUN

    sowhat \
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
    [--runs=NUMBER_OF_RUNS] \
    [--partition=PARTITION_FILE] \
    [--rerun] \
    [--debug] \
    [--help] \
    [--version]

## DOCUMENTATION


Extensive documentation is embedded inside of `sowhat` in POD format and
can be viewed by running any of the following:

        sowhat --help
        perldoc sowhat
        man sowhat  # available after installation


## CITING

A manuscript describing `sowhat` and the performance of the SOWH test is currently under 
preparation. In the mean time, cite this repository and the manuscripts describing raxml, 
seq-gen, and, if used, phylobayes.

Church SH, Ryan JF, Dunn CW, Sowhat, (2014), GitHub repository, https://github.com/josephryan/sowhat

Also see the file sowhat.bibtex

## FURTHER READING


Goldman, Nick, Jon P. Anderson, and Allen G. Rodrigo. "Likelihood-based tests of 
topologies in phylogenetics." Systematic Biology 49.4 (2000): 652-670. 
[doi:10.1080/106351500750049752](http://dx.doi.org/10.1080/106351500750049752)

Swofford, David L., Gary J. Olsen, Peter J. Waddell, and David M. Hillis. Phylogenetic 
inference. (1996): 407-514. http://www.sinauer.com/molecular-systematics.html




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
