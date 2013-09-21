#!perl

use strict;
use warnings;
use Data::Dumper;
use Getopt::Long;
#use local lib if installing Statistics::R without sudeo cpan
#use local::lib;
use Statistics::R;

MAIN : {
my $const = '';
my $aln = '';
my $model = '';
my $reps = '';
my $dir = '';
my $output = '';
my $usepb = '';
my $rax = '';
my $seqgen = '';

GetOptions(
    "constraint=s" => \$const,
    "model=s" => \$model,
    "aln=s" => \$aln,
    "reps=i" => \$reps,
    "dir=s" => \$dir,
    "output=s" => \$output,
    "usepb" => \$usepb,
    "rax=s" => \$rax,
    "seqgen=s" => \$seqgen);

    for (my $i = 0; $i < $reps; $i++) {
        mkdir $output;
        mkdir $dir;
        run_sowh($const,$model,$aln,$reps,$dir,$output,$usepb,$rax,$seqgen,$i);
        
        my $ra_delta_dist = [ ];
        my $ra_delt_prime_dist = [ ];        
        ($ra_delta_dist,$ra_delt_prime_dist)=get_deltas($output,$i);
        
        my $rh_stats = [ ];
        $rh_stats=get_stats($ra_delta_dist,$ra_delt_prime_dist,$i);
    
        print "================================\n";
        print "current sample size = $i \n";
        print "$rh_stats\n";
    }
}

sub run_sowh {
    my $const = shift;
    my $model = shift;
    my $aln = shift;
    my $reps = shift;
    my $dir = shift;
    my $output = shift;
    my $usepb = shift;
    my $rax = shift;
    my $seqgen =shift;
    my $i = shift;
    my $cmd = ();
    $cmd = "perl sowh.pl --constraint=$const --aln=$aln --model=$model --dir=$dir/repeat.$i --name=repeat.$i --reps=1 ";
    $cmd .= "--usepb " if($usepb);
    $cmd .= "--rax=$rax " if($rax);
    $cmd .= "--seqgen=$seqgen " if($seqgen);
    $cmd .= "> $output/repeat.$i";
    safe_system($cmd);
}

sub safe_system {
    my $cmd = shift;
# warn "\$cmd = $cmd\n";
    my $error = system $cmd;
    warn "system call failed:\n$cmd\nerror code=$?" if ($error != 0);
}

sub get_deltas {
    my $output = shift;
    my $i = shift;
    my @deltadist = ();
    my @deltprimedist = ();
    for (my $j = 0; $j <= $i; $j++) {
        my $file = '';
        $file = $output . "/repeat.$j";
        open IN, $file or die "cannot open $file:$!";
        while (my $line = <IN>) {
            if ($line =~ m/delta\s=\s(-?[0-9.]+)/) {
                my $delta = $1;
                $deltadist[$j] = $delta;
            } if ($line =~ m/deltprime\s=\s(-?[0-9.]+)/) {
                my $deltprime = $1;
                $deltprimedist[$j] = $deltprime;
            }
            chomp $line;
        }
     }
     return (\@deltadist,\@deltprimedist);
}

sub get_stats {
    my $ra_delta_dist = shift;
    my $ra_delt_prime_dist = shift;
    my $i = scalar(@{$ra_delt_prime_dist});
    my $delta_string = @{$ra_delta_dist};
    my $delt_prime_string = @{$ra_delt_prime_dist};
    my $R = Statistics::R->new();
    if($i > 1) {
        $delta_string = join ', ', @{$ra_delta_dist};
        $delt_prime_string = join ', ', @{$ra_delt_prime_dist};
     }
     $R->startR();

    my $cmds = <<EOF;
delta <- c($delta_string)
deltaprime <- c($delt_prime_string)
a <- var(deltaprime)
b <- ks.test(delta,deltaprime)

b
print(paste("Variance of Null Distribution=",a))
EOF
    my $r_out = $R->run($cmds);
    $R->stopR();
    return $r_out;
}

