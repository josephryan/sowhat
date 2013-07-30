# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Sowh.pl.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use Test::More tests => 1;
BEGIN { use_ok('Statistics::R') };

#########################

my $cmd = "perl sowh.pl --constraint=examples/H1.tre --aln=examples/nt.phy --model=GTRGAMMA --dir=test.output --name=nt.H1 > /dev/null ";
my $test = system $cmd;
is($test, 0, "was able to run example 1");

