# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Sowh.pl.t'

#########################

use strict;
use warnings;

use Test::More tests => 2;
BEGIN { use_ok('Statistics::R') };

#########################

diag("\nNow running a SOWH test. This usually takes less than a minute...");
my $cmd = "perl sowhat --constraint=examples/H1.tre --aln=examples/nt.phy --model=GTRGAMMA --dir=test.output --name=sowh_test --reps=20 > /dev/null ";
my $test = system $cmd;
is($test, 0, "was able to run example 1");

