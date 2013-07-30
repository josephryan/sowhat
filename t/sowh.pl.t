# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Sowh.pl.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use Test::More tests => 1;
BEGIN { use_ok('Statistics::R') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

# MUST FIGURE THIS TEST OUT
#my $test = system "perl sowh.pl --constraint=examples/H1.tre --aln=examples/nt.phy --model=GTRGAMMA --dir=OUT_DIR.nt.H1 --name=nt.H1";
#use_ok($test);


