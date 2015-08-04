#!/bin/bash

# The following are a set of tests that can be used to make sure
# sowhat is running correctly and provide examples 

# TEST1: Datatype = DNA, Model = GTRGAMMA, ML Software = RAxML
sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --raxml_model=GTRGAMMA --dir=test.output/test1 --name=test

# TEST2: Datatype = AA, Model = WAG, ML Software = RAxML
sowhat --constraint=examples/H0.tre --aln=examples/aa.phy --raxml_model=PROTGAMMAWAG --dir=test.output/test2 --name=test

# TEST3: Datatype = CHAR, Model = GTRGAMMA, ML Software = RAxML
sowhat --constraint=examples/H0.tre --aln=examples/char.phy --raxml_model=MULTIGAMMA --dir=test.output/test3 --name=test

# TEST4: Datatype = DNA, Model = GTRGAMMA, ML Software = RAxML, partitioned
sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --raxml_model=GTRGAMMA --dir=test.output/test4 --name=test --partition=examples/nt.partitions

# TEST5: Datatype = DNA, Model = GTRGAMMA, ML Software = GARLI
sowhat --constraint=examples/H0.garli.tre --aln=examples/nt.phy --usegarli --garli_conf=examples/garli.conf --dir=test.output/test5 --name=test

# TEST6: Datatype = AA, Model = WAG, ML Software = GARLI
sowhat --constraint=examples/H0.garli.tre --aln=examples/aa.phy --usegarli --garli_conf=examples/aa.garli.conf --dir=test.output/test6 --name=test

# TEST7: Datatype = AA, Model = WAG, ML Software = RAxML, nogaps
sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --raxml_model=GTRGAMMA --dir=test.output/test7 --name=test --nogaps

# TEST8: Datatype = DNA, Model = GTRGAMMA, ML Software = RAxML, rerun
sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --raxml_model=GTRGAMMA --dir=test.output/test8 --name=test --rerun

# TEST9: Datatype = DNA, Model = GTRGAMMA, ML Software = RAxML, resolved generating topology
sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --raxml_model=GTRGAMMA --dir=test.output/test9 --name=test --resolved

# TEST10: Datatype = DNA, Model (likelihood) = GTRGAMMA, Model (simulate) = CAT_GTR (PhyloBayes), ML Software = RAxML, usepb
sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --raxml_model=GTRGAMMA --dir=test.output/test10 --name=test --usepb

# TEST11: Datatype = DNA, Model (likelihood) = JC69, Model (simulate) = GTRGAMMAI, ML Software = GARLI, max
sowhat --constraint=examples/H0.garli.tre --aln=examples/nt.phy --usegarli --garli_conf=examples/jc69.garli.conf --dir=test.output/test11 --name=test --max

# TEST12: Datatype = DNA, Model = GTRGAMMA, ML Software = RAxML, number of tests = 10
sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --raxml_model=GTRGAMMA --dir=test.output/test12 --name=test --runs=10

# TEST13: Datatype = DNA, Model = GTRGAMMA, ML Software = RAxML, user model
sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --raxml_model=GTRGAMMA --dir=test.output/test13 --name=test --usegenmodel=examples/simulation.nucleotide.model

# TEST14: Datatype = DNA, Model = GTRGAMMA, ML Software = RAxML, two trees
sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --raxml_model=GTRGAMMA --dir=test.output/test14 --name=test --treetwo=examples/H1.tre --json


