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

our $GARLI_TRE  = "$EXAMPLES/H0.garli.tre";
our $GARLI_CONF = "$EXAMPLES/aa.garli.conf";
our $H1_TRE = "$EXAMPLES/H1.tre";
our $H0_TRE = "$EXAMPLES/H0.tre";
our $CHAR_PHY = "$EXAMPLES/char.phy";
our $AA_PHY = "$EXAMPLES/aa.phy";
our $OUT_DIR = 'test_subs.out';

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
    my ($dt5,$mod5) = _parse_info_from_garli_conf($GARLI_CONF);
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
                       'dir' => "test_subs.outputdir", 
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
    die "unexpected zc_tre_str from 'generate_zero_const'\n\n$zc_tre_str\n" unless ($zc_tre_str =~ m/\(Taxon3:1.218239737e-06,\(Taxon4:0.08634773991,\(Taxon5:0.03570754325,Taxon2:13.15228651\):0.04415664468\):1.218239737e-06,Taxon1:13.77030449\):0;/);


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
    unless ( ($apv->[0]->{'alpha'} == 0.727985) && 
             ($apv->[0]->{'type'} eq 'AA') &&
             ($apv->[0]->{'freqs'} eq '0.087 0.044 0.039 0.057 0.019 0.037 0.058 0.083 0.024 0.048 0.086 0.062 0.020 0.038 0.046 0.070 0.061 0.014 0.035 0.071 ' ) &&
            ($apv->[0]->{'submat'} eq 'WAG') ) {
        die "unexpected parameter vals from 'get_params' ";
    }
    
    unlink $zc_tre;
    delete_files();

    # _model_user
    # _rate_file
    # _check_user_model
    # _model_garli_nt
    # _model_garli_aa
    # _get_params_from_garli_nt
    # _get_params_from_garli_aa
    # resort_rates
    # resort_freqs
    # _model_gtrgamma
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
   
}

sub delete_files {
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


