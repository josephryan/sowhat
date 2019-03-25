# SOWHAT

[![Build Status](https://travis-ci.org/josephryan/sowhat.svg?branch=master)](https://travis-ci.org/josephryan/sowhat)

## TABLE OF CONTENTS
- [DESCRIPTION](#description)
- [AVAILABILITY](#availability)
- [INSTALLATION](#installation)
- [EXAMPLE ANALYSES](#example-analyses)
- [GETTING STARTED](#getting-started)
- [RUN](#run)
- [DOCUMENTATION](#documentation)
- [CITING](#citing)
- [FURTHER READING](#further-reading)
- [COPYRIGHT AND LICENSE](#copyright-and-license)

## DESCRIPTION

`sowhat` automates the SOWH test, a statistical test of  phylogenetic topologies using a parametric bootstrap. It works on amino acid, nucleotide, and binary character state datasets.
 
A peer-reviewed manuscript describing `sowhat` is available at Systematic Biology: http://sysbio.oxfordjournals.org/content/early/2015/07/30/sysbio.syv055.abstract

`sowhat` includes several features that provide flexibility and aid in the interpretation and assessment of SOWH test results, including: 

- The test is performed with the adjustment suggested by Susko 2014 (http://dx.doi.org/10.1093/molbev/msu039).
- Partitions, including partitions by codon position, can be used.
- Missing data (gaps in alignment) are propagated from the original dataset to the simulated dataset.
- Confidence intervals are estimated for the p-value, which helps the investigator assess if a sufficient number of bootstrap replicates have been sampled.

`sowhat` is in active development. Please use with caution. We appreciate hearing about your experience with the program via the issue tracker.

## AVAILABILITY

https://github.com/josephryan/sowhat (click the "Download ZIP" button at the bottom of the right column).

## INSTALLATION

### DOCKER

`sowhat` is available in a docker conatiner (thanks to @xqua for troublshooting). To load a container with `sowhat` and the required dependencies, use the following:

    docker pull shchurch/sowhat

### QUICK

To install `sowhat` and documentation, use the following:

    perl Makefile.PL
    make
    make test
    sudo make install

To install without root privelages try:

    perl Makefile.PL PREFIX=/home/myuser/scripts
    make
    make test
    sudo make install

### INSTALL WITH DEPENDENCIES

You can install SOWHAT and all the required dependencies listed above on a clean Ubuntu 15.04 
machine with the following commands (executables will be placed in `/usr/local/bin`):

    sudo apt-get update
    sudo apt-get install -y r-base-core cpanminus unzip gcc git
    sudo cpanm Statistics::R
    sudo cpanm JSON
    sudo Rscript -e "install.packages('ape', dependencies = T, repos='http://cran.rstudio.com/')"
    cd ~
    git clone https://github.com/josephryan/sowhat.git
    cd `sowhat`/
    # To work on the development branch (not recommended) execute: git checkout -b Development origin/Development
    sudo ./build_3rd_party.sh
    perl Makefile.PL
    make
    make test
    sudo make install
    

Note that `build_3rd_party.sh` installs some dependencies from versions that are cached in 
this repository. They may be out of date.

Additional information on [system requirements](#system-requirements) and [dependencies](#dependencies) are listed below.

## EXAMPLE ANALYSES

Several test datasets are provided in the `examples/` directory. To run example analyses 
on these datasets, execute:

    ./examples.sh
    

See `examples.sh` and the resulting `test.output/` directory for more on the specifics of 
`sowhat` use.

__Warning__: Some of the examples take time (especially those that use Garli).  For a quick example run `make test` and see the output in the `test.output` directory.

## GETTING STARTED

### Preparation

#### 1. Alignment (DNA, AA, or binary characters)

__Format:__ non-interleaved PHYLIP format

This can be DNA, amino acid, or binary characters. Often, you would have performed phylogenetic analyses on this alignment and recovered a result that was in conflict with an _a priori_ hypothesis.

#### 2. Constraint tree

__Format:__ Newick format

The constraint tree represents a hypothesis that you would like to compare to the ML tree or some alternative hypothesis. In most cases you will want a tree that is mostly unresolved except for the clade being tested. 

For example if your ML tree showed a sister relationship between two taxa 'A' and 'B' and you want to compare this result to topology with a sister relationship between 'A' and 'C,' you would create the following constraint tree:

  `((A,C),B,D,E,F);`

Note that the relationship `B`, `D`, `E`, and `F` is unresolved.

#### 3. RAxML model

The only other required parameter when using RAxML is

  `--raxml_model`

This option can specify any of the models that are available to RAxML. Running `sowhat` with the option `--raxml_model=available` will provide a list of all possible models.

Other RAxML parameters (including number of threads) can be specified with the option:

  `--rax`

for example:

  `--rax='/usr/local/bin/raxmlHPC-PTHREADS -T 20'`

### Running `sowhat`

See `examples.sh` for examples of `sowhat` commands.

By default `sowhat` samples 1000 bootstrap replicates. This can be adjusted with `--reps=[sample size]`. A sufficient sample size can be assessed by checking the reported confidence interval around the p-value.

### Examining the results

The results of the SOWH test are included in a file called `sowhat.results.txt`, which can be found in the directory specified with the `--dir` option.

At the bottom of `sowhat.results.txt` is a p-value representing the probability that the test statistic would be observed under the null hypothesis.

A run that has been cut short can be restarted using the `--restart` option. In this case the null distribution will be recalculated iteratively using the previously simulated samples in the null distributions. Only the most recent two generations of sequence simulation and tree estimation will be reperformed to prevent any errors from an unfinished tree estimation.

Additional outputs include 
- detailed information on the model used for simulating new alignments in the file `sowhat.model.txt`
- information on the null distribution in `sowhat.distribution.txt`
- the trace file for the run is printed to `sowhat.trace.txt`
- program files printed to a directory `sowhat_scratch`. Within this directory, the files ending in `...i.0.0` represent the initial search of the empirical alignment file. 

Results can be printed to a file `sowhat.results.json` using the option 

  `--json`

### Running large analyses

The SOWH test can take a lot of time, especially on datasets where a single tree search can take many hours. Threads can be incorporated into raxml as described above with the `--rax options`, which can speed up the tree searches considerably.

In some cases, though, the user may want to further parallelize the `sowhat` test. The following option allows a user to run the tree searches on simulated datasets simultaneously, for example on a cluster.

To use this option, you must specify the following options:

  `--print_tree_scripts --reps=[sample size, default=1000]`

The initial two tree searches on the observed data will be performed. Subsequently `sowhat` will generate simulated alignments and print a series of scripts to execute the tree searches to the folder `[--dir]/sowhat_scratch/tree_scripts/`.

Each of these scripts must be executed externally, and can be run simultaneously. After they have all been completed, the user reruns `sowhat` with the following options:

  `--print_tree_scripts --reps=[same number of reps] --restart`

One note: if the inital sample size is too low (the confidence interval around the p-value indicates that the results are not definitive), the user can generate additional tree scripts by rerunning the `sowhat` command with the following options:

  `--print_tree_scripts --reps=[some higher number of reps] --restart`

sowhat will not calculate the statistics until the number of tree scripts specified in the number of reps have been executed successfully.

### Additional options

See [this page](additional_options.md) for descriptions of additional options and how to use more complex models.

## RUN

```
   sowhat 
   --constraint=NEWICK_CONSTRAINT_TREE 
   --aln=PHYLIP_ALIGNMENT 
   --name=NAME_FOR_REPORT 
   --dir=DIR 
   [--debug] 
   [--garli=GARLI_BINARY_OR_PATH_PLUS_OPTIONS] 
   [--garli_conf=PATH_TO_GARLI_CONF_FILE] 
   [--help] 
   [--initial] 
   [--json] 
   [--max] 
   [--raxml_model=MODEL_FOR_RAXML] 
   [--nogaps] 
   [--partition=PARTITION_FILE] 
   [--pb=PB_BINARY_OR_PATH_PLUS_OPTION
   [--pb_burn=BURNIN_TO_USE_FOR_PB_TREE_SIMULATIONS] 
   [--plot] 
   [--ppred=PPRED_BINARY_OR_PATH_PLUS_OPTIONS] 
   [--print_tree_scripts]
   [--rax=RAXML_BINARY_OR_PATH_PLUS_OPTIONS] 
   [--reps=NUMBER_OF_REPLICATES] 
   [--resolved] 
   [--rerun] 
   [--restart]
   [--runs=NUMBER_OF_TESTS_TO_RUN] 
   [--seqgen=SEQGEN_BINARY_OR_PATH_PLUS_OPTIONS] 
   [--treetwo=NEWICK_ALTERNATIVE_TO_CONST_TREE] 
   [--usepb] 
   [--usegarli] 
   [--usegentree=NEWICK_TREE_FOR_SIMULATING_DATA] 
   [--version] 
```

## DOCUMENTATION

Extensive documentation is embedded inside of `sowhat` in POD format and
can be viewed by running any of the following:

        `sowhat` --help
        perldoc `sowhat`
        man `sowhat`  # available after installation

## CITING


A peer-reviewed manuscript describing `sowhat` is available at Systematic Biology:

Church, Samuel H., Joseph F. Ryan, and Casey W. Dunn. "Automation and Evaluation of the SOWH Test with SOWHAT"
Systematic Biology 2015 Nov;64(6):1048-58.
doi: 10.1093/sysbio/syv055

Also see the file `sowhat`.bibtex

## FURTHER READING


Goldman, Nick, Jon P. Anderson, and Allen G. Rodrigo. "Likelihood-based tests of 
topologies in phylogenetics." Systematic Biology 49.4 (2000): 652-670. 
[doi:10.1080/106351500750049752](http://dx.doi.org/10.1080/106351500750049752)

Swofford, David L., Gary J. Olsen, Peter J. Waddell, and David M. Hillis. Phylogenetic 
inference. (1996): 407-514. http://www.sinauer.com/molecular-systematics.html


### SYSTEM REQUIREMENTS

We have tested `sowhat` on OS X 10.9, OS X 10.10, Ubuntu Server 10.04 (Amazon ami-d05e75b8), and Ubuntu Desktop 15.04. It will likely work on a variety of other Unix-like operating systems.


### DEPENDENCIES

The dependencies listed below are required by `sowhat`. They must be installed and 
available in the appropriate `PATH`. If they are not installed already, follow the 
installation instructions in the links provided for each tool. We have tested `sowhat` 
with the indicated dependency versions. Other versions may be incompatible, and should be 
used with caution. These external tools are the result of a considerable amount of work by other investigators, please also cite them when you cite `sowhat`.

Phylogenetic programs: 
- [RAxML](https://github.com/stamatak/standard-RAxML), 8.2.12 
- [Seq-Gen](http://tree.bio.ed.ac.uk/software/seqgen/), v1.3.4
- [ape](http://cran.r-project.org/web/packages/ape/index.html), v3.2

General system tools:
- [Perl](http://www.cpan.org/), which comes with most operating systems
- [R](http://www.r-project.org/)
- The [Statistics::R](http://search.cpan.org/dist/Statistics-R/) Perl module. `Statistics::R` has additional requirements, as described at http://search.cpan.org/dist/Statistics-R/README. Use the `local::lib` option to install `Statistics::R` without `sudo`. Use the boostrap method found at http://search.cpan.org/~haarg/local-lib-2.000004/lib/local/lib.pm for installation information. Once local::lib has been installed, and with R installed,  install the Statistics::R package as you would normally. The use local::lib option must be activated in the program as well.
- The [IPC::Run](http://search.cpan.org/dist/IPC-Run/) Perl module is currently needed for `make test` to work correctly (optional).

To use more alternative models, you will need to install the following optional dependency:
- [GARLI](https://code.google.com/p/garli/), v2.01.1067  (optional)
- [PhyloBayes](http://www.phylobayes.org)

To print results to a json file, you will need to install the following optional dependency:
- The [JSON](http://search.cpan.org/~makamaka/JSON-2.90/) Perl module.

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
