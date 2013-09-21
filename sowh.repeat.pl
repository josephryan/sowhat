use strict;
use warnings;
use Data::Dumper;
use Getopt::Long;

my $const = '';
my $aln = '';
my $model = '';
GetOptions(
    "const=s" => \$const,
    "model=s" => \$model,
    "aln=s" => \$aln);


run_sowh($const,$model,$aln);

sub run_sowh {
    my $const = shift;
    my $model = shift;
    my $aln = shift;
    my $cmd = ();
    for (my $i = 0; $i < 10; $i++) {
         $cmd = "perl sowh.pl --constraint=$const --aln=$aln --model=$model --dir=test.output/repeat$i --name=repeat$i >repeat$i";
        safe_system($cmd);
    }
}

sub safe_system {
    my $cmd = shift;
    warn "\$cmd = $cmd\n";
    my $error = system $cmd;
    warn "system call failed:\n$cmd\nerror code=$?" if ($error != 0);
}


