# SOWHAT


## DESCRIPTION


`sowhat` is being actively developed. Please use with caution. We appreciate hearing about your experience with the program.

`sowhat` automates the steps required for the SOWH phylogenetic topology test (described by the manuscripts listed in FURTHER READING below). `sowhat` depends on the freely available Seq-Gen and RAxML software packages. It works on amino acid, nucleotide, and binary character state datasets. Partitions (including codon position partitioning) can be specified. It is also possible to use PhyloBayes to generate the null distribution for nucleotide and amino acid data. 
A manuscript describing the `sowhat` and the SOWH test has been released to the bioRxiv: http://biorxiv.org/content/early/2014/05/19/005264

`sowhat` includes several features that aid in the interpretation and assessment of SOWH test results, including: 

- The option to account for variability in the maximum likelihood searches by estimating the test statistic and parameters for each new alignment.
- Tools for assessing if a sufficient number of replicates have been run. 


## AVAILABILITY


https://github.com/josephryan/sowhat (click the "Download ZIP" button at the bottom of the right column).


## INSTALLATION

### QUICK

To install `sowhat` and documentation, type the following:

    perl Makefile.PL
    make
    make test
    sudo make install

To install without root privelages try:

    perl Makefile.PL PREFIX=/home/myuser/scripts
    make
    make test
    sudo make install

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
- The [Statistics::R](http://search.cpan.org/dist/Statistics-R/) Perl module. `Statistics::R` has additional requirements, as described at http://search.cpan.org/dist/Statistics-R/README. Use the `local::lib` option to install `Statistics::R` without `sudo`. Use the boostrap method found at http://search.cpan.org/~haarg/local-lib-2.000004/lib/local/lib.pm for installation information. Once local::lib has been installed, and with R installed,  install the Statistics::R package as you would normally. The use local::lib option must be activated in the program as well.
- The [IPC::Run](http://search.cpan.org/dist/IPC-Run/) Perl module is currently needed for `make test` to work correctly.

To use more complex models, you will need to install the following optional dependency:
- [PhyloBayes](http://www.phylobayes.org)

You can install SOWHAT and all the required dependencies listed above on a clean Ubuntu 14.04 
machine with the following commands (executables will be placed in `/usr/local/bin`):

    sudo apt-get update
    sudo apt-get install -y r-base-core cpanminus unzip gcc git
    sudo cpanm Statistics::R
    cd ~
    git clone https://github.com/josephryan/sowhat.git
    cd sowhat/
    sudo ./build_3rd_party.sh
    perl Makefile.PL
    make
    make test
    sudo make install
    

Note that `build_3rd_party.sh` installs some dependencies from versions that are cached in 
this repository. They may be out of date.



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
    [--stop] \
    [--pb=PB_BINARY_OR_PATH_PLUS_OPTIONS] \
    [--pb_burn=BURNIN_TO_USE_FOR_PB_TREE_SIMULATIONS] \
    [--reps=NUMBER_OF_REPLICATES] \
    [--runs=NUMBER_OF_RUNS] \
    [--partition=PARTITION_FILE] \
    [--rerun] \
    [--restart] \
    [--gaps] \
    [--debug] \
    [--help] \
    [--version] \

## DOCUMENTATION


Extensive documentation is embedded inside of `sowhat` in POD format and
can be viewed by running any of the following:

        sowhat --help
        perldoc sowhat
        man sowhat  # available after installation


## CITING

A manuscript describing `sowhat` and the performance of the SOWH test has been posted to the bioRxiv:

Automation and Evaluation of the SOWH Test of Phylogenetic Topologies with SOWHAT
Samuel H. Church, Joseph F. Ryan, Casey W. Dunn
bioRxivdoi: http://dx.doi.org/10.1101/005264

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
