# SOWHAT


## DESCRIPTION

`sowhat` automates the SOWH phylogenetic topology test (described by the manuscripts listed in FURTHER READING below). It works on amino acid, nucleotide, and binary character state datasets. Partitions (including codon position partitioning) can be specified. 
 
A manuscript describing the `sowhat` and the SOWH is available at bioRxiv: http://biorxiv.org/content/early/2014/05/19/005264

`sowhat` includes several features that provide flexibility and aid in the interpretation and assessment of SOWH test results, including: 

- The test can be run with the adjustment suggested by Susko 2014 (http://dx.doi.org/10.1093/molbev/msu039), which is the default behavior, or as originally described.
- Gaps are propagated from the original dataset to the simulated dataset.
- Likelihood searches can be performed with RAxML or GARLI
- Boostrap replicate datasets can be simulated with Seq-Gen or PhyloBayes.
- Different models can be used for simulation and inference.
- Confidence intervals are estimated for the p-value, which helps the investigator assess if a sufficient number of bootstrap replicates have been sampled. 
- The option to account for variability in the maximum likelihood searches by estimating the test statistic and parameters for each new alignment.

`sowhat` is in active development. Please use with caution. We appreciate hearing about your experience with the program via the issue tracker.


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

We have tested `sowhat` on OS X 10.9, OS X 10.10, Ubuntu Server 10.04 (Amazon ami-d05e75b8), and Ubuntu Desktop 15.04. It will likely work on a variety of other Unix-like operating systems.

### DEPENDENCIES

The dependencies listed below are required by `sowhat`. They must be installed and 
available in the appropriate `PATH`. If they are not installed already, follow the 
installation instructions in the links provided for each tool. We have tested `sowhat` 
with the indicated dependency versions. Other versions may be incompatible, and should be 
used with caution. These external tools are the result of a considerable amount of work by other investigators, please also cite them when you cite `sowhat`.

Phylogenetic programs: 
- [GARLI](https://code.google.com/p/garli/), v2.01.1067
- [RAxML](https://github.com/stamatak/standard-RAxML), 8.1.20 
- [Seq-Gen](http://tree.bio.ed.ac.uk/software/seqgen/), v1.3.3
- [ape](http://cran.r-project.org/web/packages/ape/index.html), v3.2

General system tools:
- [Perl](http://www.cpan.org/), which comes with most operating systems
- [R](http://www.r-project.org/)
- The [Statistics::R](http://search.cpan.org/dist/Statistics-R/) Perl module. `Statistics::R` has additional requirements, as described at http://search.cpan.org/dist/Statistics-R/README. Use the `local::lib` option to install `Statistics::R` without `sudo`. Use the boostrap method found at http://search.cpan.org/~haarg/local-lib-2.000004/lib/local/lib.pm for installation information. Once local::lib has been installed, and with R installed,  install the Statistics::R package as you would normally. The use local::lib option must be activated in the program as well.
- The [IPC::Run](http://search.cpan.org/dist/IPC-Run/) Perl module is currently needed for `make test` to work correctly.

To use more complex models for simulation, you will need to install the following optional dependency:
- [PhyloBayes](http://www.phylobayes.org)

You can install SOWHAT and all the required dependencies listed above on a clean Ubuntu 15.04 
machine with the following commands (executables will be placed in `/usr/local/bin`):

    sudo apt-get update
    sudo apt-get install -y r-base-core cpanminus unzip gcc git
    sudo cpanm Statistics::R
    sudo Rscript -e "install.packages('ape', dependencies = T, repos='http://cran.rstudio.com/')"
    cd ~
    git clone https://github.com/josephryan/sowhat.git
    cd sowhat/
    # To work on the development branch (not recommended) execute: git checkout -b Development origin/Development
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

__Warning__: Many of the examples take a very long time (especially those that use Garli).  For a quick example run _make test_ and see the output in the _test.output_ directory.

## GETTING STARTED WITH YOUR OWN ANALYSES

### Preparation

#### 1. Alignment (DNA, AA, or binary characters)

__Format:__ non-interleaved PHYLIP format

Description: This can be DNA, amino acid, or binary characters. Usually, you would have performed phylogenetic analyses on this alignment and recovered a result that was in conflict with an _a priori_ hypothesis.  You will specify the _a priori_ hypothesis in a constraint tree (next section).

#### 2. Constraint tree

__Format:__ Newick format

The constraint tree represents a hypothesis that you would like to compare to the ML tree. In most cases you will want a tree that is mostly unresolved but includes the clade being tested.  For example if your ML tree showed a sister relationship between two taxa 'A' and 'B' and you want to compare this result to topology with a sister relationship between 'A' and 'C,' you would create the following constraint tree:

  ((A,C),B,D,E,F);

Note that B, D, E, and F are unresolved.

#### 3. Garli conf file

Example Garli configuration files are available (examples.garli.conf and examples/aa.garli.conf). For an in-depth explanation of all of the options, see the Garli manual available from: http://www.bio.utexas.edu/faculty/antisense/garli/garli.html

The nucleotide model specified in _examples/garli.conf_ is GTR+GAMMA. The amino acid model specified in _examples/aa.garli.conf_ is WAG+GAMMA. To adjust either of these the following parameters should be adjusted in garli.conf:

    _ratematrix_, _statefrequencies_, _ratehetmode_, _numratecats_, _invariantsites_

We highly recommend not adjusting other parameters in the garli conf files as this could cause sowhat to fail.

#### 4. For using RAxML in place of GARLI

RAxML is much faster than Garli and can use multiple processors, but as we report in our paper, Garli appears to be more suitable for the SOWH test. To use RAxML, you need to provide the option:

  _--useraxml_

The only other required parameter when using RAxML is

  _--raxml_model_

This option can specify any of the models that are available to RAxML. Running _raxmlHPC -h_ from the command line will give you a list of models available to RAxML.

Other RAxML parameters (including number of threads) can be specified with the option:

  _--rax_

for example:

  _--rax='/usr/local/bin/raxmlHPC-PTHREADS -T 20'

### Running sowhat

See examples.sh for examples of sowhat command lines

### Examining the results

The results of the SOWH test are included in a file called _sowhat.results_, which can be found in the directory specified with the _--dir_ option in the _sowhat_ command line.  The bottom of _sowhat.results_ includes a p-value representing the probability that the test statistic would be observed under the null hypothesis.

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


Copyright (C) 2015 Samuel H. Church, Joseph F. Ryan, Casey W. Dunn

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
