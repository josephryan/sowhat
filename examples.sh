#!/bin/bash

####################################
### TYPICAL ANALYSES WITH SOWHAT

# TEST1: Datatype = DNA, Model = GTRGAMMA, ML Software = RAxML
sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --raxml_model=GTRGAMMA --dir=test.output/test1 --name=test

# TEST2: Datatype = AA, Model = WAG, ML Software = RAxML
sowhat --constraint=examples/H0.tre --aln=examples/aa.phy --raxml_model=PROTGAMMAWAG --dir=test.output/test2 --name=test

# TEST3: Datatype = CHAR, Model = GTRGAMMA, ML Software = RAxML
sowhat --constraint=examples/H0.tre --aln=examples/char.phy --raxml_model=MULTIGAMMA --dir=test.output/test3 --name=test

# TEST4: Datatype = DNA, Model = GTRGAMMA, ML Software = RAxML, partitioned
sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --raxml_model=GTRGAMMA --dir=test.output/test4 --name=test --partition=examples/nt.partitions

####################################
### PARALLELIZED ANALYSIS, 3 steps 

# step 1:
sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --raxml_model=GTRGAMMA --dir=test.output/test5 --name=test --print_tree_scripts --reps=100

# step 2:
# outside of sowhat, run all tree search scripts printed to test.output/test4/sowhat_scratch/tree_scripts/

# step 3:
# sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --raxml_model=GTRGAMMA --dir=test.output/test5 --name=test --print_tree_scripts --reps=100 --restart


####################################
### MORE COMPLEX MODELS AND OPTIONS

# TEST5: Datatype = DNA, Model = GTRGAMMA, ML Software = GARLI
sowhat --constraint=examples/H0.garli.tre --aln=examples/nt.phy --usegarli --garli_conf=examples/garli.conf --dir=test.output/test6 --name=test

# TEST6: Datatype = AA, Model = WAG, ML Software = GARLI
sowhat --constraint=examples/H0.garli.tre --aln=examples/aa.phy --usegarli --garli_conf=examples/aa.garli.conf --dir=test.output/test7 --name=test

# TEST7: Datatype = DNA, Model = GTRGAMMA, ML Software = RAxML, no gaps in simulated alignments
sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --raxml_model=GTRGAMMA --dir=test.output/test8 --name=test --nogaps

# TEST8: Datatype = DNA, Model = GTRGAMMA, ML Software = RAxML, rerun the tree searches on observed data each iteration
sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --raxml_model=GTRGAMMA --dir=test.output/test9 --name=test --rerun

# TEST9: Datatype = DNA, Model = GTRGAMMA, ML Software = RAxML, resolved generating topology (no Susko correction)
sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --raxml_model=GTRGAMMA --dir=test.output/test10 --name=test --resolved

# TEST10: Datatype = DNA, Model (likelihood) = GTRGAMMA, Model (simulate) = CAT_GTR (PhyloBayes), ML Software = RAxML, usepb
sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --raxml_model=GTRGAMMA --dir=test.output/test11 --name=test --usepb

# TEST11: Datatype = DNA, Model (likelihood) = JC69, Model (simulate) = GTRGAMMAI, ML Software = GARLI, maximize the free parameters used for simulation
sowhat --constraint=examples/H0.garli.tre --aln=examples/nt.phy --usegarli --garli_conf=examples/jc69.garli.conf --dir=test.output/test12 --name=test --max

# TEST12: Datatype = DNA, Model = GTRGAMMA, ML Software = RAxML, run multiple (n=10) SOWH tests simultaneously 
sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --raxml_model=GTRGAMMA --dir=test.output/test13 --name=test --runs=10

# TEST13: Datatype = DNA, Model = GTRGAMMA, ML Software = RAxML, specify a custom model for simulation
sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --raxml_model=GTRGAMMA --dir=test.output/test14 --name=test --usegenmodel=examples/simulation.nucleotide.model

# TEST14: Datatype = DNA, Model = GTRGAMMA, ML Software = RAxML, compare two trees, neither of which is the most likely topology (not a typical SOWH test)
sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --raxml_model=GTRGAMMA --dir=test.output/test15 --name=test --treetwo=examples/H1.tre --json


