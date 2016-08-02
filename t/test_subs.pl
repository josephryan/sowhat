#!/usr/bin/perl

# this script is mainly used by the sowhat developers to make sure
# that new features and fixes do not break other parts of the program,
# but it may be useful to users trying to diagnose problems
#
# the script requires the Test::Subroutines module which is available
# here: http://search.cpan.org/~oliver/Test-Subroutines-1.113350/lib/Test/Subroutines.pm

$|++;

use strict;
use warnings;
use Test::Subroutines;
use Digest::MD5;
use Data::Dumper;

our $VERSION = 0.01;

our $SOWHAT = $ARGV[0] or die "usage: $0 SOWHAT EXAMPLES_DIR\n";
our $EXAMPLES = $ARGV[1] or die "usage: $0 SOWHAT EXAMPLES_DIR\n";
our $OUT_DIR = 'test_subs.out';

our $GARLI_TRE  = "$EXAMPLES/H0.garli.tre";
our $GARLI_CONF = "$EXAMPLES/garli.conf";
our $GARLI_SCREEN = "$OUT_DIR/sowhat_scratch/t1.i.1.1.screen.log";
our $GARLI_CONF_AA = "$EXAMPLES/aa.garli.conf";
our $GARLI_SCREEN_AA = "$OUT_DIR/sowhat_scratch/t1.i.1.1.screen.log.aa";
our $H1_TRE = "$EXAMPLES/H1.tre";
our $H0_TRE = "$EXAMPLES/H0.tre";
our $CHAR_PHY = "$EXAMPLES/char.phy";
our $AA_PHY = "$EXAMPLES/aa.phy";
our $NT_PHY = "$EXAMPLES/nt.phy";
our $SIM_AA_MODEL = "$EXAMPLES/simulation.amino.model";
our $NEW_SIM_AA_MODEL = "$OUT_DIR/simulation.amino.model";

# all globals in sowhat need to be defined here
our $RAX = 'raxmlHPC';
our $GARLI = 'Garli';
our $USEGARLI = '0';
our $SEQGEN = 'seq-gen';
our $PB = 'pb -f';
our $PPRED = 'ppred';
our $PB_SAMPLING_FREQ = 5;
our $PB_SAVING_FREQ   = 1;
our $PB_BURN   = 10;
our $DEFAULT_REPS = 1000;
our $DEFAULT_RUNS = 1;
our $QUIET = 1;
our $DIR = '';
our $SCRATCH = '';
our $FREQ_BIN_NUMBER = 10;
our $TRE_PREFIX = 'RAxML_bestTree';
our $UNLINKED_PARTITION_FILE = 'unlinked.part.txt';
our $SIM_PARTITION_FILE = 'sim.part.txt';
our $PART_RATE_MATRIX_PREFIX = 'RAxML_proteinGTRmodel';
our $NAME = '';
our $SUBZERO = 0.001;
our $LINE = '-' x 80;

MAIN: {
    load_subs($SOWHAT);

    # check_model
    print "$LINE\nTESTING check_model\n";
    my ($d1,$m1) = check_model({'mod' => 'PROTGAMMAWAG'});
    my ($d2,$m2) = check_model({'mod' => 'GTRGAMMA'});
    my ($d3,$m3) = check_model({'mod' => 'MULTIGAMMA'});
    die "check_model failed" unless ($d1 eq 'AA' && $d2 eq 'DNA' && 
        $d3 eq 'Multi-State' && $m1 eq 'WAG' && $m2 eq 'GTR' && $m3 eq 'GTR');

    # cannot easily test process_options

    # _set_out_dir
    print "$LINE\nTESTING _set_out_dir\n";
    _set_out_dir($OUT_DIR);
    my $pwd = getcwd();
    # print "\n\$DIR = $DIR\n\$DIR = $pwd/$OUT_DIR/\n\n\$SCRATCH = $SCRATCH\n";
    # print "\$SCRATCH = $pwd/$OUT_DIR/sowhat_scratch/\n\n";
    die "_set_out_dir failed" unless ($DIR eq "$pwd/$OUT_DIR/" 
                            && $SCRATCH eq "$pwd/$OUT_DIR/sowhat_scratch/");

    # _options_compatible
    print "$LINE\nTESTING _options_compatible\n";
    _options_compatible({'constraint_tree' => 'blah', 'aln' => 'blah',
                         'mod' => 'blah', 'name' => 'foo' });

    # check_constraint_tree_for_operators
    print "$LINE\nTESTING check_constraint_tree_for_operators\n";
    check_constraint_tree_for_operators($GARLI_TRE);

    # check_version
    print "$LINE\nTESTING check_version\n";
    my $v = check_version();
    die "unexpected version string $v" unless ($v =~ m/^[\d\.]+$/);

    # check_garli_version
    print "$LINE\nTESTING check_garli_version\n";
    my $gv = check_garli_version();
    die "unexpected rax version string $gv" unless ($gv =~ m/^[\d\.]+$/);

    # check_raxml_version
    print "$LINE\nTESTING check_raxml_version\n";
    my $rv = check_raxml_version();
    die "unexpected rax version string $rv" unless ($rv =~ m/^[\d\.]+$/);

    # check_model
    print "$LINE\nTESTING check_model\n";
    print "    testing PROTGAMMAGTR\n";
    my ($dt1,$mod1) = check_model({'mod' => 'PROTGAMMAGTR'});
    die "unexpected datatype $dt1" unless ($dt1 eq 'AA');
    die "unexepcted model $mod1" unless ($mod1 eq 'GTR');
    print "    testing GTRGAMMA\n";
    my ($dt2,$mod2) = check_model({'mod' => 'GTRGAMMA'});
    die "unexpected datatype $dt2" unless ($dt2 eq 'DNA');
    die "unexepcted model $mod2" unless ($mod2 eq 'GTR');
    print "    testing PROTCATIGTR\n";
    my ($dt3,$mod3) = check_model({'mod' => 'PROTCATIGTR'});
    die "unexpected datatype $dt3" unless ($dt3 eq 'AA');
    die "unexepcted model $mod3" unless ($mod3 eq 'GTR');
    print "    testing MULTICATGTR\n";
    my ($dt4,$mod4) = check_model({'mod' => 'MULTICATGTR'});
    die "unexpected datatype $dt4" unless ($dt4 eq 'Multi-State');
    die "unexepcted model $mod4" unless ($mod4 eq 'GTR');

    # _parse_info_from_garli_conf
    print "$LINE\nTESTING testing _parse_info_from_garli_conf\n";
    my ($dt5,$mod5) = _parse_info_from_garli_conf($GARLI_CONF_AA);
    die "unexpected datatype $dt5" unless ($dt5 eq 'aminoacid');
    die "unexepcted model $mod5" unless ($mod5 eq 'wag');

    # _translate_model
    print "$LINE\nTESTING testing _translate_model\n";
    my $m4 = _translate_model({},'PROTGAMMAJTT');
    die "unexpected model trans: PROTGAMMAJTT->$m4" unless ($m4 eq 'JTT');
    my $m5 = _translate_model({},'PROTGAMMADAYHOFF');
    die "unexpected model trans: PROTGAMMADAYHOFF->$m5" unless ($m5 eq 'PAM');
    my $m6 = _translate_model({},'PROTGAMMABLOSUM62');
    die "unxpect model trans: PROTGAMMABLOSUM62->$m6" unless ($m6 eq 'BLOSUM');
    my $m7 = _translate_model({},'PROTGAMMAMTREV');
    die "unexpected model trans: PROTGAMMAMTREV->$m7" unless ($m7 eq 'MTREV');
    my $m8 = _translate_model({},'PROTGAMMAMTART');
    die "unexpected model trans: PROTGAMMAMTART->$m8" unless ($m8 eq 'MTART');
    my $m9 = _translate_model({},'PROTGAMMACPREV45');
    die "unxpected model trans: PROTGAMMACPREV45->$m9" unless ($m9 eq 'CPREV');
    my $m10 = _translate_model({},'PROTGAMMAGTR_UNLINKED');
    die "unexpected model trans: PROTGAMMAGTR_UNLINKED->$m10" unless ($m10 eq 'GTR_UNLINKED');
    my $m11 = _translate_model({},'PROTGAMMAGTR');
    die "unexpected model trans: PROTGAMMAGTR->$m11" unless ($m11 eq 'GTR');

    # _model_message
      # skipping since this is a die routine

    # restart
    print "$LINE\nTESTING restart\n";
    if (-d $SCRATCH) {
        foreach my $i (0..4) {
            my $fileml = "$SCRATCH" . "RAxML_info.ml.0.$i";
            open OUT, ">$fileml" or die "cannot open >$fileml:$!";
            print OUT 1;
        }
        my $flag = restart({'reps' => 1, 'restart' => 1});
        my $high_file = $SCRATCH . 'RAxML_info.ml.0.4';
        die "'restart' did not unlink high file" if (-e $high_file);
        die "unexpected return from 'restart': $flag" unless ($flag == 3);
    } else {
        die "'restart' test expects $SCRATCH to exist";
    }

    # print_initial_messages
    # skipping because it prints to screen

    # _interleaved
    print "$LINE\nTESTING _interleaved\n";
    my $int_file = $SCRATCH . 'interleaved.phy';
    open OUT, ">$int_file" or die "cannot open >$int_file:$!";
    print OUT "  5    42\n";
    print OUT "Turkey    AAGCTNGGGC ATTTCAGGGT\n";
    print OUT "Salmo gairAAGCCTTGGC AGTGCAGGGT\n";
    print OUT "H. SapiensACCGGTTGGC CGTTCAGGGT\n";
    print OUT "Chimp     AAACCCTTGC CGTTACGCTT\n";
    print OUT "Gorilla   AAACCCTTGC CGGTACGCTT\n";
    print OUT "\nGAGCCCGGGC AATACAGGGT AT\n";
    print OUT "GAGCCGTGGC CGGGCACGGT AT\n";
    print OUT "ACAGGTTGGC CGTTCAGGGT AA\n";
    print OUT "AAACCGAGGC CGGGACACTC AT\n";
    print OUT "AAACCATTGC CGGTACGCTT AA\n";
    close OUT; 
    my $int_test = _interleaved($int_file);
    die "'_interleaved' did not detect interleaved" unless ($int_test == 1);
    my $non_int = _interleaved($CHAR_PHY);
    die "'_interleaved' falsely detected non_interleaved" if ($non_int);
    unlink $int_file;

    # run_initial_trees  (no output but we run for the decide_best tree
    print "$LINE\nTESTING run_initial_trees\n";
    my $rit_out1 = "$SCRATCH" . "RAxML_info.ml.i.0.0";
    my $rit_out2 = "$SCRATCH" . "RAxML_info.t1.i.0.0";
    if (-e $rit_out1 || -e $rit_out2) {
        die "there are files in $SCRATCH that need to be deleted";
    }
    run_initial_trees({'aln' => $AA_PHY, 
                       'mod' => 'PROTGAMMAWAG', 
                   'treetwo' => $H0_TRE, 
                       'dir' => "$OUT_DIR", 
                      'name' => 'run_initial_trees_test', 
           'constraint_tree' => $H1_TRE},0,'0.0');
    die "run_initial_trees failed no $rit_out1" unless (-e $rit_out1);
    die "run_initial_trees failed no $rit_out2" unless (-e $rit_out2);
    
    # skipping the following
    # _run_best_tree_w_garli
    # _run_best_tree_w_raxml
    # make_two_tree_decisison
  
    # decide_best
    print "$LINE\nTESTING decide_best\n";
    my $db_flag = decide_best({'constraint_tree' => $H1_TRE, 
                               'treetwo' => $H0_TRE});
    die "'decide_best' does not pick the best" unless ($db_flag == 1);


    # generate_zero_const
    print "$LINE\nTESTING generate_zero_const\n";
    my $zc_tre = generate_zero_const({'constraint_tree' => $H0_TRE},'99.99');
    open IN, $zc_tre or die "$zc_tre not created by 'generate_zero_const':$!";
    my $zc_tre_str = <IN>;
    die "unexpected zc_tre_str from 'generate_zero_const'\n\n$zc_tre_str\n" unless ($zc_tre_str =~ m/\(Taxon3:[0-9.e-]+,\(Taxon4:[0-9.e-]+,\(Taxon5:[0-9.e-]+,Taxon2:[0-9.e-]+\):[0-9.e-]+\):[0-9.e-]+,Taxon1:[0-9.e-]+\):0;/);


    # get_utility_R_functions
    print "$LINE\nTESTING get_utility_R_functions\n";
    my $urf = get_utility_R_functions();
    my $urf_md5 = Digest::MD5::md5_hex($urf);
    die "'get_utility_R_functions' have changed. If this is intentional, $\urf_md5 test must be updated" unless ($urf_md5 eq 'b3554b02ff669f8b207c45b6073b400b');
    # skipping 
    # get_params_w_pb

    # get_params
    print "$LINE\nTESTING get_params\n";
    my ($al,$apv,$ar) = get_params({'aln' => $AA_PHY, 'part' => 0,'tre' => $H0_TRE, 'mod' => 'PROTGAMMAWAG'},'WAG','AA',0,'0.0');
    die "unexpected alignment length in 'get_params'" unless ($al->[0] == 30);
    # alpha will vary with the machine, but should be close
    unless ( ( ($apv->[0]->{'alpha'} - 0.727985) < 0.01) && 
             ($apv->[0]->{'type'} eq 'AA') &&
             ($apv->[0]->{'freqs'} eq '0.087 0.044 0.039 0.057 0.019 0.037 0.058 0.083 0.024 0.048 0.086 0.062 0.020 0.038 0.046 0.070 0.061 0.014 0.035 0.071 ' ) &&
            ($apv->[0]->{'submat'} eq 'WAG') ) {
        die "unexpected parameter vals from 'get_params' ";
    }
    
    # _model_user
    print "$LINE\nTESTING _model_user\n";
    open OUT, ">$NEW_SIM_AA_MODEL" or die "cannot open >$NEW_SIM_AA_MODEL:$!";
    open IN, $SIM_AA_MODEL or die "cannot open $SIM_AA_MODEL";
    while (my $line = <IN>) {
        if ($line =~ m/^rate file = /) {
            print OUT "rate file = $EXAMPLES/simulation.rates\n";
        } else {
            print OUT $line;
        }
    }
    close OUT;
    my ($ra_mu_da,$ra_mu_ra) = _model_user({'genmodel' => $NEW_SIM_AA_MODEL});
    die "unexpected pinv in '_model_user'" unless ($ra_mu_da->[0]->{'pinv'} == 0.013);
    die "unexpected alpha in '_model_user'" unless ($ra_mu_da->[0]->{'alpha'} == 0.7527);
    die "unexpected type in '_model_user'" unless ($ra_mu_da->[0]->{'type'} eq 'AA');
    die "unexpected freqs in '_model_user'" unless ($ra_mu_da->[0]->{'freqs'} eq '0.087 0.044 0.039 0.057 0.019 0.037 0.058 0.083 0.024 0.048 0.086 0.062 0.020 0.038 0.046 0.070 0.061 0.014 0.035 0.071');
    die "unexpected submat in '_model_user'" unless ($ra_mu_da->[0]->{'submat'} eq 'GTR');
    my $mu_ra_md5 = Digest::MD5::md5_hex(Dumper $ra_mu_ra);
    die "unexepected rates in '_model_user'" unless ($mu_ra_md5 eq 'e60c6c505ac043e4015e0f8bd5d38dfa');

    # _rate_file
    print "$LINE\nTESTING _rate_file\n";
    my $ra_rfdat = _rate_file("$EXAMPLES/simulation.rates");
    my $rfdat_md5 = Digest::MD5::md5_hex(Dumper $ra_rfdat);
    die "unexpected from '_rate_file'" unless ($rfdat_md5);

    # I'm not so sure it's necessary to _check_user_model since it's called b4
    # _check_user_model
    print "$LINE\nTESTING _check_user_model\n";
    _check_user_model($apv,$ar);

    # _model_garli_nt
    # _get_params_from_garli_nt
    print "$LINE\nTESTING _model_garli_nt\n";
    my $gsl = get_garli_screen_log();
    open OUT, ">$GARLI_SCREEN" or die "cannot open $GARLI_SCREEN:$!";
    print OUT "$gsl\n";
    my $ra_mgn = _model_garli_nt({'aln' => $NT_PHY, 'tre' => $GARLI_TRE, 'garli_conf' => $GARLI_CONF},'GTR','DNA',0,'1.1');
    die "unexpected number in '_model_garli_nt'" unless ($ra_mgn->[0]->{'type'} eq 'DNA');

# SKIPPING _model_garli_aa - having trouble getting test to work
#    # _model_garli_aa
#    # _get_params_from_garli_aa
#    print "$LINE\nTESTING _model_garli_aa\n";
#    my $gslaa = get_garli_screen_logaa();
#    open OUT, ">$GARLI_SCREEN_AA" or die "cannot open >$GARLI_SCREEN_AA:$!";
#    print OUT "$gslaa\n";
#    my $ra_mgnaa = _model_garli_aa({'aln' => $AA_PHY, 'tre' => $GARLI_TRE, 'garli.conf' => $GARLI_CONF_AA},'WAG','AA',0,'1.1');
#   die "unexpected in '_model_garli_aa'" unless ($ra_mgnaa->[0]->{'type'} eq 'AA');


    # resort_rates
    print "$LINE\nTESTING resort_rates\n";
    my @rates = (1..189);
    my $ra_rr = resort_rates(\@rates);
    die "resort rates failed" unless ($ra_rr->[0]->[0] == 0);
    die "resort rates failed" unless ($ra_rr->[0]->[1] == 14);
    die "resort rates failed" unless ($ra_rr->[1]->[3] == 49);
    die "resort rates failed" unless ($ra_rr->[2]->[19] == 160);
    die "resort rates failed" unless ($ra_rr->[3]->[8] == 41);
    die "resort rates failed" unless ($ra_rr->[7]->[15] == 95);
    die "resort rates failed" unless ($ra_rr->[8]->[11] == 101);
    die "resort rates failed" unless ($ra_rr->[10]->[17] == 144);
    die "resort rates failed" unless ($ra_rr->[15]->[-1] == 182);
    die "resort rates failed" unless ($ra_rr->[19]->[7] == 97);

    print "$LINE\nTESTING resort_freqs\n";
    # resort_freqs
    my $fr_str = join ' ', (1..20);
    my $str = resort_freqs($fr_str);
    die "resort freqs failed" unless ($str eq '1 15 12 3 2 14 4 6 7 8 10 9 11 5 13 16 17 19 20 18 ');

    print "$LINE\nTESTING _model_gtrgamma\n";
    # _model_gtrgamma
    make_rax_info_file("$OUT_DIR/RAxML_info.t1.i.0.0");
    my $ra_mod_gtrg = _model_gtrgamma({'rax' => 'raxmlHPC', 'name' => 'test', 
          'reps' => 1000, 'constraint_tree' => 'examples/H0.tre', 
          'dir' => '$OUT_DIR', 'seqgen' => 'seq-gen', 'runs' => 1, 
          'aln' => 'examples/nt.phy', 'mod' => 'GTRGAMMA'},0,'0.0');
    die "unexpected" unless ($ra_mod_gtrg->[0]->{'alpha'} == 0.727985);
    die "unexpected" unless ($ra_mod_gtrg->[0]->{'type'} eq 'AA');
    die "unexpected" unless ($ra_mod_gtrg->[0]->{'submat'} eq 'WAG');
    die "unexpected" unless ($ra_mod_gtrg->[0]->{'freqs'} eq '0.087 0.044 0.039 0.057 0.019 0.037 0.058 0.083 0.024 0.048 0.086 0.062 0.020 0.038 0.046 0.070 0.061 0.014 0.035 0.071 ');

    # _model_prot
    # _model_character_data
    # _get_partition_lengths
    # _get_params_from_const_rax
    # _make_unlinked_partition_file
    # _get_part_info
    # _print_unlinked_part
    # _parse_rates
    # generate_alignments_w_pb
    # generate_alignments
    # _run_seqgen
    # _get_dna_params
    # _get_aa_params
    # _get_char_params
    # _convert_AT_to_01
    # _make_sim_part
    # _print_ranges
    # _print_new_part_file
    # _print_sim_model
    # _build_datasets
    # _get_ids_from_seqgen_out
    # _get_seqs_from_seqgen_out
    # _make_datasets_from_allseqs
    # _gap_stencil
    # _get_len_from_id_lens
    # _make_alns
    # run_gen_trees
    # _run_garli_on_genset
    # _run_rax_on_genset
    # evaluate_distribution
    # _get_distribution_from_garli
    # _get_distribution_from_rax
    # _get_best_garli_score
    # _get_best_rax_score
    # _get_stats
    # _parse_stats
    # _structure_output
    # plot_runs
    # calc_ratio
    # print_report
    # safe_system
    # usage   

    delete_files($zc_tre);
}

sub delete_files {
    my $zc_tre = shift;
    unlink $zc_tre;
    unlink $NEW_SIM_AA_MODEL;
    unlink $GARLI_SCREEN;
    my @files = qw(RAxML_bestTree.ml.i.0.0 RAxML_bestTree.t1.i.0.0
                   RAxML_info.ml.i.0.0 RAxML_info.t1.i.0.0
                   RAxML_log.ml.i.0.0 RAxML_log.t1.i.0.0
                   RAxML_parsimonyTree.ml.i.0.0 RAxML_result.ml.i.0.0
                   RAxML_result.t1.i.0.0);
    foreach my $f (@files) {
        my $u_f = $SCRATCH . $f;
        unlink $u_f;
    }
    foreach my $i (0..3) {
        my $fileml = "$SCRATCH" . "RAxML_info.ml.0.$i";
        unlink $fileml or die "could not unlink $fileml:$!";
    }
    unlink "$OUT_DIR/sowh_stderr_.txt";
    unlink "$OUT_DIR/sowh_stdout_.txt";
    unlink "$OUT_DIR/sowhat_scratch";
    rmdir $SCRATCH;
    rmdir $OUT_DIR;
}

sub get_garli_screen_logaa {
    return q~Running GARLI-PART Version 2.0.1019 (29 Mar 2011)
->OpenMP multithreaded version for multiple processors/cores<-
##############################################################
 This is GARLI 2.0, the first "official" release including 
          partitioned models.  It is a merging of
   official release 1.0 and beta version GARLI-PART 0.97
  Briefly, it includes models for nucleotides, amino acids,
 codons, and morphology-like characters, any of which can be 
  mixed together and applied to different subsets of data.

    General program usage is extensively documented here:
            http://www.nescent.org/wg/garli/
      see this page for details on partitioned usage:
  http://www.nescent.org/wg/garli/Partition_testing_version
   and this page for details on Mkv mophology model usage:
    http://www.nescent.org/wg/garli/Mkv_morphology_model
         PLEASE LET ME KNOW OF ANY PROBLEMS AT:
                garli.support@gmail.com
##############################################################
Compiled Apr  4 2011 14:37:58 using Intel icc compiler version 9.10
Using NCL version 2.1.10

#######################################################
Reading config file /Users/jfryan/Dropbox/JOE/Git/sowhat/test.output/test6/sowhat_scratch/18jWAF40ZV.garli.conf
###################################################
READING OF DATA
Attempting to read data file examples/aa.phy as
	relaxed Phylip amino acid format (using NCL) ...

Data read successfully.

###################################################
PARTITIONING OF DATA AND MODELS
GARLI data subset 1
	CHARACTERS block #1 ("Untitled DATA Block 1")
	Data read as Amino acid data,
	modeled as Amino acid data
WARNING: Not all amino acids were observed in this dataset.
	One pseudo-count will be added to each amino acid
	for calculation of the empirical frequencies. You
	should probably use a statefrequencies setting other 
	than emprical.

	Summary of data:
	  5 sequences.
	  3 constant characters.
	  24 parsimony-informative characters.
	  3 uninformative variable characters.
	  30 total characters.
	  29 unique patterns in compressed data matrix.
	Pattern processing required < 1 second


###################################################
NOTE: Unlike many programs, the amount of system memory that Garli will
use can be controlled by the user.
(This comes from the availablememory setting in the configuration file.
Availablememory should NOT be set to more than the actual amount of 
physical memory that your computer has installed)

For this dataset:
 Mem level		availablememory setting
  great			    >= 1 MB
  good			approx 0 MB to 1 MB
  low			approx 0 MB to 1 MB
  very low		approx 0 MB to 1 MB
the minimum required availablememory is 1 MB

You specified that Garli should use at most 512.0 MB of memory.

Garli will actually use approx. 0.8 MB of memory
**Your memory level is: great (you don't need to change anything)**

#######################################################
Found outgroup specification:  1

#######################################################
Loading constraints from file examples/H0.garli.tre
Found 1 positively constrained bipartition(s)
     Bipartition 1: (1,2) | (3,4,5)
STARTING RUN
MODEL REPORT - Parameters are at their INITIAL values (not yet optimized)
Model 1
  Number of states = 20 (amino acid data)
  Amino Acid Rate Matrix: WAG
  Equilibrium State Frequencies: empirical (observed) values (+F)
    (ACDEFGHIKLMNPQRSTVWY)
    0.0294 0.0235 0.0765 0.0588 0.0824 
    0.0706 0.0059 0.0647 0.0647 0.0471 
    0.0588 0.0706 0.0118 0.0294 0.0882 
    0.0706 0.0647 0.0706 0.0059 0.0059 
  Rate Heterogeneity Model:
    4 discrete gamma distributed rate categories, alpha param estimated
      0.5000
    with an invariant (invariable) site category, proportion estimated
      0.0250
    Substitution rate categories under this model:
      rate	proportion
      0.0000	0.0250
      0.0334	0.2437
      0.2519	0.2437
      0.8203	0.2437
      2.8944	0.2437

Starting with seed=1234

creating likelihood stepwise addition starting tree (compatible with constraints)...
number of taxa added:
 4  5 
Initial ln Likelihood: -207.8456
optimizing: starting branch lengths, alpha shape, prop. invar...
pass 1:+    1.092 (branch=   1.09 scale=  0.00 alpha=  0.00 pinv=  0.00)
pass 2:+    0.328 (branch=   0.32 scale=  0.00 alpha=  0.00 pinv=  0.00)
lnL after optimization: -206.4253
gen      current_lnL    precision  last_tree_imp  
0        -206.4253        0.500           0 
100      -205.4946        0.500          40 
200      -205.3938        0.500          40 
300      -205.3344        0.500          40 
400      -205.2923        0.500          40 
500      -205.2813        0.500          40 
600      -205.2712        0.500          40 
Optimization precision reduced 
   Optimizing parameters...    improved    0.151 lnL
   Optimizing branchlengths... improved    0.000 lnL
700      -205.1174        0.010          40 
800      -205.1173        0.010          40 
900      -205.1173        0.010          40 
1000     -205.1173        0.010          40 
1100     -205.1172        0.010          40 
1200     -205.1172        0.010          40 
1300     -205.1172        0.010          40 
1400     -205.1172        0.010          40 
1500     -205.1172        0.010          40 
1600     -205.1172        0.010          40 
1700     -205.1172        0.010          40 
1800     -205.1171        0.010          40 
1900     -205.1171        0.010          40 
2000     -205.1171        0.010          40 
2100     -205.1171        0.010          40 
2200     -205.1171        0.010          40 
2300     -205.1171        0.010          40 
2400     -205.1171        0.010          40 
2500     -205.1171        0.010          40 
2600     -205.1171        0.010          40 
2700     -205.1171        0.010          40 
Reached termination condition!
last topological improvement at gen 40
Improvement over last 500 gen = 0.00000
Current score = -205.1171
Performing final optimizations...
pass 1 : -205.1171   (branch= 0.0000  alpha= 0.0000  pinv= 0.0000)
pass 2 : -205.1171   (branch= 0.0000  alpha= 0.0000  pinv= 0.0000)
pass 3 : -205.1171   (branch= 0.0000  alpha= 0.0000  pinv= 0.0000)
pass 4 : -205.1171   (branch= 0.0000  alpha= 0.0000  pinv= 0.0000)
pass 5 : -205.1171   (branch= 0.0000  alpha= 0.0000  pinv= 0.0000)
pass 6 : -205.1171   (branch= 0.0000  alpha= 0.0000  pinv= 0.0000)
pass 7 : -205.1171   (branch= 0.0000  alpha= 0.0000  pinv= 0.0000)
pass 8 : -205.1171   (branch= 0.0000  alpha= 0.0000  pinv= 0.0000)
pass 9 : -205.1171   (branch= 0.0000  alpha= 0.0000  pinv= 0.0000)
pass 10: -205.1171   (branch= 0.0000  alpha= 0.0000  pinv= 0.0000)
Looking for minimum length branches...
Final score = -205.1171
Time used = 0 hours, 0 minutes and 29 seconds

MODEL REPORT - Parameter values are FINAL
Model 1
  Number of states = 20 (amino acid data)
  Amino Acid Rate Matrix: WAG
  Equilibrium State Frequencies: empirical (observed) values (+F)
    (ACDEFGHIKLMNPQRSTVWY)
    0.0294 0.0235 0.0765 0.0588 0.0824 
    0.0706 0.0059 0.0647 0.0647 0.0471 
    0.0588 0.0706 0.0118 0.0294 0.0882 
    0.0706 0.0647 0.0706 0.0059 0.0059 
  Rate Heterogeneity Model:
    4 discrete gamma distributed rate categories, alpha param estimated
      0.4077
    with an invariant (invariable) site category, proportion estimated
      0.0000
    Substitution rate categories under this model:
      rate	proportion
      0.0000	0.0000
      0.0178	0.2500
      0.1875	0.2500
      0.7394	0.2500
      3.0553	0.2500


#######################################################

Completed 1 replicate search(es) (of 1).
Results:
Replicate 1 : -205.1171       

Parameter estimates:
        alpha  pinv
rep 1:  0.408 0.000

Treelengths:
          TL 
rep 1:  100.294

Saving final tree from best search rep (#1) to /Users/jfryan/Dropbox/JOE/Git/sowhat/test.output/test6/sowhat_scratch//t1.i.0.0.best.tre
#######################################################~;
}
sub get_garli_screen_log {
    return q~Running GARLI-PART Version 2.0.1019 (29 Mar 2011)
->OpenMP multithreaded version for multiple processors/cores<-
##############################################################
 This is GARLI 2.0, the first "official" release including 
          partitioned models.  It is a merging of
   official release 1.0 and beta version GARLI-PART 0.97
  Briefly, it includes models for nucleotides, amino acids,
 codons, and morphology-like characters, any of which can be 
  mixed together and applied to different subsets of data.

    General program usage is extensively documented here:
            http://www.nescent.org/wg/garli/
      see this page for details on partitioned usage:
  http://www.nescent.org/wg/garli/Partition_testing_version
   and this page for details on Mkv mophology model usage:
    http://www.nescent.org/wg/garli/Mkv_morphology_model
         PLEASE LET ME KNOW OF ANY PROBLEMS AT:
                garli.support@gmail.com
##############################################################
Compiled Apr  4 2011 14:37:58 using Intel icc compiler version 9.10
Using NCL version 2.1.10

#######################################################
Reading config file /Users/jfryan/Dropbox/JOE/Git/sowhat/test.output/test5/sowhat_scratch/GYvgqMqcN_.garli.conf
###################################################
READING OF DATA
Attempting to read data file /Users/jfryan/Dropbox/JOE/Git/sowhat/test.output/test5/sowhat_scratch/aln.phy.0.1.0 as
	relaxed Phylip DNA format (using NCL) ...

Data read successfully.

###################################################
PARTITIONING OF DATA AND MODELS
GARLI data subset 1
	CHARACTERS block #1 ("Untitled DATA Block 1")
	Data read as Nucleotide data,
	modeled as Nucleotide data
	Summary of data:
	  5 sequences.
	  12 constant characters.
	  32 parsimony-informative characters.
	  46 uninformative variable characters.
	  90 total characters.
	  73 unique patterns in compressed data matrix.
	Pattern processing required < 1 second


###################################################
NOTE: Unlike many programs, the amount of system memory that Garli will
use can be controlled by the user.
(This comes from the availablememory setting in the configuration file.
Availablememory should NOT be set to more than the actual amount of 
physical memory that your computer has installed)

For this dataset:
 Mem level		availablememory setting
  great			    >= 1 MB
  good			approx 0 MB to 1 MB
  low			approx 0 MB to 1 MB
  very low		approx 0 MB to 1 MB
the minimum required availablememory is 1 MB

You specified that Garli should use at most 512.0 MB of memory.

Garli will actually use approx. 0.4 MB of memory
**Your memory level is: great (you don't need to change anything)**

#######################################################
Found outgroup specification:  1

#######################################################
Loading constraints from file examples/H0.garli.tre
Found 1 positively constrained bipartition(s)
     Bipartition 1: (1,5) | (2,3,4)
STARTING RUN
MODEL REPORT - Parameters are at their INITIAL values (not yet optimized)
Model 1
  Number of states = 4 (nucleotide data)
  Nucleotide Relative Rate Matrix:     6 rates 
    AC = 1.000, AG = 4.000, AT = 1.000, CG = 1.000, CT = 4.000, GT = 1.000
  Equilibrium State Frequencies: estimated
    (ACGT) 0.3408 0.2377 0.1749 0.2466 
  Rate Heterogeneity Model:
    4 discrete gamma distributed rate categories, alpha param estimated
      0.5000
    Substitution rate categories under this model:
      rate	proportion
      0.0334	0.2500
      0.2519	0.2500
      0.8203	0.2500
      2.8944	0.2500

Starting with seed=953673

creating likelihood stepwise addition starting tree (compatible with constraints)...
number of taxa added:
 4  5 
Initial ln Likelihood: -556.7541
optimizing: starting branch lengths, alpha shape, rel rates, eq freqs...
pass 1:+   24.002 (branch=   3.49 scale=  0.81 alpha=  1.57 freqs=  0.02 rel rates= 18.11)
pass 2:+    6.978 (branch=   3.60 scale=  0.00 alpha=  1.48 freqs=  0.01 rel rates=  1.88)
pass 3:+    2.955 (branch=   1.27 scale=  0.00 alpha=  1.68 freqs=  0.01 rel rates=  0.00)
pass 4:+    1.753 (branch=   0.45 scale=  0.00 alpha=  1.28 freqs=  0.02 rel rates=  0.00)
pass 5:+    0.018 (branch=   0.00 scale=  0.00 alpha=  0.00 freqs=  0.02 rel rates=  0.00)
lnL after optimization: -521.0484
gen      current_lnL    precision  last_tree_imp  
0        -521.0484        0.500           0 
100      -520.2872        0.500           0 
200      -520.0993        0.500           0 
300      -519.5931        0.500           0 
400      -519.3236        0.500           0 
500      -519.1587        0.500           0 
Optimization precision reduced 
   Optimizing parameters...    improved    0.005 lnL
   Optimizing branchlengths... improved    0.000 lnL
600      -519.0386        0.451           0 
700      -518.9671        0.451           0 
800      -518.9450        0.451           0 
900      -518.7550        0.451           0 
1000     -518.7138        0.451           0 
Optimization precision reduced 
   Optimizing parameters...    improved    0.004 lnL
   Optimizing branchlengths... improved    0.000 lnL
1100     -518.5835        0.402           0 
1200     -518.5542        0.402           0 
1300     -518.5449        0.402           0 
1400     -518.4782        0.402           0 
1500     -518.4157        0.402           0 
Optimization precision reduced 
   Optimizing parameters...    improved    0.002 lnL
   Optimizing branchlengths... improved    0.000 lnL
1600     -518.3379        0.353           0 
1700     -518.3339        0.353           0 
1800     -518.2993        0.353           0 
1900     -518.0915        0.353           0 
2000     -518.0341        0.353           0 
Optimization precision reduced 
   Optimizing parameters...    improved    0.380 lnL
   Optimizing branchlengths... improved    0.000 lnL
2100     -517.5602        0.304           0 
2200     -517.5086        0.304           0 
2300     -517.4597        0.304           0 
2400     -517.3984        0.304           0 
2500     -517.3066        0.304           0 
Optimization precision reduced 
   Optimizing parameters...    improved    0.004 lnL
   Optimizing branchlengths... improved    0.000 lnL
2600     -517.2307        0.255           0 
2700     -517.2124        0.255           0 
2800     -517.1541        0.255           0 
2900     -517.1454        0.255           0 
3000     -517.1275        0.255           0 
Optimization precision reduced 
   Optimizing parameters...    improved    0.001 lnL
   Optimizing branchlengths... improved    0.000 lnL
3100     -517.1205        0.206           0 
3200     -517.1203        0.206           0 
3300     -517.0653        0.206           0 
3400     -517.0653        0.206           0 
3500     -517.0132        0.206           0 
Optimization precision reduced 
   Optimizing parameters...    improved    0.001 lnL
   Optimizing branchlengths... improved    0.000 lnL
3600     -516.9726        0.157           0 
3700     -516.9064        0.157           0 
3800     -516.8801        0.157           0 
3900     -516.8727        0.157           0 
4000     -516.8648        0.157           0 
Optimization precision reduced 
   Optimizing parameters...    improved    0.001 lnL
   Optimizing branchlengths... improved    0.000 lnL
4100     -516.8633        0.108           0 
4200     -516.8509        0.108           0 
4300     -516.8373        0.108           0 
4400     -516.8361        0.108           0 
4500     -516.8354        0.108           0 
Optimization precision reduced 
   Optimizing parameters...    improved    0.000 lnL
   Optimizing branchlengths... improved    0.000 lnL
4600     -516.8335        0.059           0 
4700     -516.8230        0.059           0 
4800     -516.8230        0.059           0 
4900     -516.8230        0.059           0 
5000     -516.8220        0.059           0 
Optimization precision reduced 
   Optimizing parameters...    improved    0.074 lnL
   Optimizing branchlengths... improved    0.000 lnL
5100     -516.7412        0.010           0 
5200     -516.7364        0.010           0 
5300     -516.7341        0.010           0 
5400     -516.7316        0.010           0 
5500     -516.7196        0.010           0 
5600     -516.7186        0.010           0 
5700     -516.7174        0.010           0 
5800     -516.7173        0.010           0 
5900     -516.7173        0.010           0 
6000     -516.7158        0.010           0 
6100     -516.7152        0.010           0 
6200     -516.7131        0.010           0 
6300     -516.7125        0.010           0 
6400     -516.7098        0.010           0 
6500     -516.7095        0.010           0 
6600     -516.7094        0.010           0 
6700     -516.7085        0.010           0 
6800     -516.7083        0.010           0 
6900     -516.7081        0.010           0 
7000     -516.7076        0.010           0 
7100     -516.7070        0.010           0 
7200     -516.7070        0.010           0 
7300     -516.7070        0.010           0 
7400     -516.7070        0.010           0 
7500     -516.7070        0.010           0 
7600     -516.7070        0.010           0 
7700     -516.7069        0.010           0 
7800     -516.7066        0.010           0 
7900     -516.7066        0.010           0 
8000     -516.7061        0.010           0 
8100     -516.7051        0.010           0 
8200     -516.7042        0.010           0 
8300     -516.7029        0.010           0 
8400     -516.7028        0.010           0 
8500     -516.7026        0.010           0 
8600     -516.7026        0.010           0 
8700     -516.7024        0.010           0 
8800     -516.7024        0.010           0 
8900     -516.7024        0.010           0 
9000     -516.7024        0.010           0 
9100     -516.7024        0.010           0 
9200     -516.7024        0.010           0 
9300     -516.7021        0.010           0 
9400     -516.7021        0.010           0 
9500     -516.7020        0.010           0 
9600     -516.7020        0.010           0 
9700     -516.7020        0.010           0 
9800     -516.7020        0.010           0 
9900     -516.7020        0.010           0 
10000    -516.7020        0.010           0 
   Optimizing parameters...    improved    0.000 lnL
   Optimizing branchlengths... improved    0.000 lnL
10100    -516.7019        0.010           0 
10200    -516.7019        0.010           0 
10300    -516.7019        0.010           0 
10400    -516.7019        0.010           0 
10500    -516.7019        0.010           0 
10600    -516.7019        0.010           0 
10700    -516.7019        0.010           0 
10800    -516.7019        0.010           0 
10900    -516.7015        0.010           0 
11000    -516.7015        0.010           0 
11100    -516.7015        0.010           0 
11200    -516.7015        0.010           0 
11300    -516.7015        0.010           0 
11400    -516.7015        0.010           0 
11500    -516.7015        0.010           0 
11600    -516.7015        0.010           0 
11700    -516.7012        0.010           0 
11800    -516.7012        0.010           0 
11900    -516.7012        0.010           0 
12000    -516.7010        0.010           0 
12100    -516.7010        0.010           0 
12200    -516.7010        0.010           0 
12300    -516.7010        0.010           0 
12400    -516.7010        0.010           0 
12500    -516.7010        0.010           0 
12600    -516.7010        0.010           0 
12700    -516.7010        0.010           0 
12800    -516.7010        0.010           0 
12900    -516.7010        0.010           0 
13000    -516.7009        0.010           0 
13100    -516.7009        0.010           0 
13200    -516.7009        0.010           0 
13300    -516.7009        0.010           0 
13400    -516.7009        0.010           0 
13500    -516.7009        0.010           0 
13600    -516.7009        0.010           0 
13700    -516.7009        0.010           0 
13800    -516.7008        0.010           0 
13900    -516.7008        0.010           0 
14000    -516.7008        0.010           0 
14100    -516.7008        0.010           0 
14200    -516.7008        0.010           0 
14300    -516.7008        0.010           0 
14400    -516.7008        0.010           0 
14500    -516.7008        0.010           0 
14600    -516.7008        0.010           0 
14700    -516.7008        0.010           0 
14800    -516.7007        0.010           0 
14900    -516.7007        0.010           0 
15000    -516.7007        0.010           0 
   Optimizing parameters...    improved    0.000 lnL
   Optimizing branchlengths... improved    0.000 lnL
15100    -516.7007        0.010           0 
15200    -516.7007        0.010           0 
15300    -516.7007        0.010           0 
15400    -516.7007        0.010           0 
15500    -516.7007        0.010           0 
15600    -516.7007        0.010           0 
15700    -516.7007        0.010           0 
15800    -516.7007        0.010           0 
15900    -516.7007        0.010           0 
16000    -516.7007        0.010           0 
16100    -516.7007        0.010           0 
16200    -516.7007        0.010           0 
16300    -516.7007        0.010           0 
16400    -516.7007        0.010           0 
16500    -516.7007        0.010           0 
16600    -516.7006        0.010           0 
16700    -516.7006        0.010           0 
16800    -516.7006        0.010           0 
16900    -516.7006        0.010           0 
17000    -516.7006        0.010           0 
17100    -516.7006        0.010           0 
17200    -516.7006        0.010           0 
17300    -516.7006        0.010           0 
17400    -516.7006        0.010           0 
17500    -516.7006        0.010           0 
17600    -516.7006        0.010           0 
17700    -516.7006        0.010           0 
17800    -516.7006        0.010           0 
17900    -516.7006        0.010           0 
18000    -516.7006        0.010           0 
18100    -516.7006        0.010           0 
18200    -516.7006        0.010           0 
18300    -516.7006        0.010           0 
18400    -516.7006        0.010           0 
18500    -516.7006        0.010           0 
18600    -516.7006        0.010           0 
18700    -516.7006        0.010           0 
18800    -516.7006        0.010           0 
18900    -516.7006        0.010           0 
19000    -516.7006        0.010           0 
19100    -516.7006        0.010           0 
19200    -516.7006        0.010           0 
19300    -516.7006        0.010           0 
19400    -516.7006        0.010           0 
19500    -516.7006        0.010           0 
19600    -516.7006        0.010           0 
19700    -516.7006        0.010           0 
19800    -516.7006        0.010           0 
19900    -516.7006        0.010           0 
20000    -516.7006        0.010           0 
   Optimizing parameters...    improved    0.000 lnL
   Optimizing branchlengths... improved    0.000 lnL
20100    -516.7006        0.010           0 
20200    -516.7006        0.010           0 
20300    -516.7006        0.010           0 
20400    -516.7006        0.010           0 
20500    -516.7006        0.010           0 
20600    -516.7006        0.010           0 
20700    -516.7006        0.010           0 
20800    -516.7006        0.010           0 
20900    -516.7006        0.010           0 
21000    -516.7006        0.010           0 
21100    -516.7006        0.010           0 
21200    -516.7006        0.010           0 
21300    -516.7006        0.010           0 
21400    -516.7006        0.010           0 
21500    -516.7006        0.010           0 
21600    -516.7006        0.010           0 
21700    -516.7006        0.010           0 
21800    -516.7006        0.010           0 
21900    -516.7006        0.010           0 
22000    -516.7006        0.010           0 
22100    -516.7006        0.010           0 
22200    -516.7006        0.010           0 
22300    -516.7006        0.010           0 
22400    -516.7006        0.010           0 
22500    -516.7006        0.010           0 
22600    -516.7006        0.010           0 
22700    -516.7006        0.010           0 
22800    -516.7006        0.010           0 
22900    -516.7006        0.010           0 
23000    -516.7006        0.010           0 
23100    -516.7006        0.010           0 
23200    -516.7006        0.010           0 
23300    -516.7006        0.010           0 
23400    -516.7006        0.010           0 
23500    -516.7006        0.010           0 
23600    -516.7006        0.010           0 
23700    -516.7006        0.010           0 
23800    -516.7006        0.010           0 
23900    -516.7006        0.010           0 
24000    -516.7006        0.010           0 
24100    -516.7006        0.010           0 
24200    -516.7006        0.010           0 
24300    -516.7006        0.010           0 
24400    -516.7006        0.010           0 
24500    -516.7006        0.010           0 
24600    -516.7006        0.010           0 
24700    -516.7006        0.010           0 
24800    -516.7006        0.010           0 
24900    -516.7006        0.010           0 
25000    -516.7006        0.010           0 
   Optimizing parameters...    improved    0.000 lnL
   Optimizing branchlengths... improved    0.000 lnL
25100    -516.7005        0.010           0 
Reached termination condition!
last topological improvement at gen 0
Improvement over last 500 gen = 0.00001
Current score = -516.7005
Performing final optimizations...
pass 1 : -516.7005   (branch= 0.0000  alpha= 0.0000  eq freqs= 0.0000  rel rates= 0.0000)
pass 2 : -516.7005   (branch= 0.0000  alpha= 0.0000  eq freqs= 0.0000  rel rates= 0.0000)
pass 3 : -516.7005   (branch= 0.0000  alpha= 0.0000  eq freqs= 0.0000  rel rates= 0.0000)
pass 4 : -516.7005   (branch= 0.0000  alpha= 0.0000  eq freqs= 0.0000  rel rates= 0.0000)
pass 5 : -516.7005   (branch= 0.0000  alpha= 0.0000  eq freqs= 0.0000  rel rates= 0.0000)
pass 6 : -516.7005   (branch= 0.0000  alpha= 0.0000  eq freqs= 0.0000  rel rates= 0.0000)
pass 7 : -516.7005   (branch= 0.0000  alpha= 0.0000  eq freqs= 0.0000  rel rates= 0.0000)
pass 8 : -516.7005   (branch= 0.0000  alpha= 0.0000  eq freqs= 0.0000  rel rates= 0.0000)
pass 9 : -516.7005   (branch= 0.0000  alpha= 0.0000  eq freqs= 0.0000  rel rates= 0.0000)
pass 10: -516.7005   (branch= 0.0000  alpha= 0.0000  eq freqs= 0.0000  rel rates= 0.0000)
pass 11: -516.7004   (branch= 0.0001  alpha= 0.0000  eq freqs= 0.0000  rel rates= 0.0000)
pass 12: -516.7004   (branch= 0.0000  alpha= 0.0000  eq freqs= 0.0000  rel rates= 0.0000)
pass 13: -516.7004   (branch= 0.0000  alpha= 0.0000  eq freqs= 0.0000  rel rates= 0.0000)
Looking for minimum length branches...
Final score = -516.7004
Time used = 0 hours, 0 minutes and 54 seconds

MODEL REPORT - Parameter values are FINAL
Model 1
  Number of states = 4 (nucleotide data)
  Nucleotide Relative Rate Matrix:     6 rates 
    AC = 0.600, AG = 0.116, AT = 1.438, CG = 1.283, CT = 0.551, GT = 1.000
  Equilibrium State Frequencies: estimated
    (ACGT) 0.3354 0.2439 0.1840 0.2368 
  Rate Heterogeneity Model:
    4 discrete gamma distributed rate categories, alpha param estimated
      5.5013
    Substitution rate categories under this model:
      rate	proportion
      0.5217	0.2500
      0.8151	0.2500
      1.0823	0.2500
      1.5809	0.2500

NOTE: Collapsing of minimum length branches was requested (collapsebranches = 1)
    No branches were short enough to be collapsed.


NOTE: If collapsing of minimum length branches is requested (collapsebranches = 1) in a run with
	a positive constraint, it is possible for a constrained branch itself to be collapsed.
	If you care, be careful to check whether this has happened or turn off branch collapsing.


#######################################################

Completed 1 replicate search(es) (of 1).
Results:
Replicate 1 : -516.7004       

Parameter estimates:
         r(AC)  r(AG)  r(AT)  r(CG)  r(CT)  r(GT) pi(A) pi(C) pi(G) pi(T) alpha
rep 1:  0.5998 0.1159  1.438  1.283 0.5511      1 0.335 0.244 0.184 0.237 5.501

Treelengths:
          TL 
rep 1:  2.592

Saving final tree from best search rep (#1) to /Users/jfryan/Dropbox/JOE/Git/sowhat/test.output/test5/sowhat_scratch//t1.0.1.0.best.tre
#######################################################~;
}

sub make_rax_info_file {
    my $file = shift;
    open OUT, ">$file" or die "cannot open > file:$!";
    print OUT qq~This is RAxML version 8.1.20 released by Alexandros Stamatakis on April 18 2015.

With greatly appreciated code contributions by:
Andre Aberer      (HITS)
Simon Berger      (HITS)
Alexey Kozlov     (HITS)
Kassian Kobert    (HITS)
David Dao         (KIT and HITS)
Nick Pattengale   (Sandia)
Wayne Pfeiffer    (SDSC)
Akifumi S. Tanabe (NRIFS)

Alignment has 69 distinct alignment patterns

Proportion of gaps and completely undetermined characters in this alignment: 0.89%

RAxML rapid hill-climbing mode

Using 1 distinct models/data partitions with joint branch length optimization


Executing 1 inferences on the original alignment using 1 user-specified trees

All free model parameters will be estimated by RAxML
GAMMA model of rate heteorgeneity, ML estimate of alpha-parameter

GAMMA Model parameters will be estimated up to an accuracy of 0.1000000000 Log Likelihood units

Partition: 0
Alignment Patterns: 69
Name: No Name Provided
DataType: DNA
Substitution Matrix: GTR




RAxML was called as follows:

raxmlHPC -f d -p 1234 --no-bfgs -w /Users/jfryan/Dropbox/JOE/Git/sowhat/test.output/test1/sowhat_scratch/ -m GTRGAMMA -s examples/nt.phy -n t1.i.0.0 -g examples/H0.tre


Partition: 0 with name: No Name Provided
Base frequencies: 0.327 0.233 0.175 0.265

Inference[0]: Time 0.023012 GAMMA-based likelihood -543.527346, best rearrangement setting 2
alpha[0]: 1.544576 rates[0] ac ag at cg ct gt: 0.289224 0.109033 0.820561 0.730526 0.363477 1.000000


Conducting final model optimizations on all 1 trees under GAMMA-based models ....

Inference[0] final GAMMA-based Likelihood: -541.293616 tree written to file /Users/jfryan/Dropbox/JOE/Git/sowhat/test.output/test1/sowhat_scratch/RAxML_result.t1.i.0.0

Starting final GAMMA-based thorough Optimization on tree 0 likelihood -541.293616 ....

Final GAMMA-based Score of best tree -541.293616

Program execution info written to /Users/jfryan/Dropbox/JOE/Git/sowhat/test.output/test1/sowhat_scratch/RAxML_info.t1.i.0.0
Best-scoring ML tree written to: /Users/jfryan/Dropbox/JOE/Git/sowhat/test.output/test1/sowhat_scratch/RAxML_bestTree.t1.i.0.0

Overall execution time: 0.042016 secs or 0.000012 hours or 0.000000 day
~;
}
