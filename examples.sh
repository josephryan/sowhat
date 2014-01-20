#!/bin/bash

# The following are a set of tests that can be used to make sure
# sowhat is running correctly and provide examples 
# 
# To make tests go faster add --reps=10
# or --rax='raxmlHPC-PTHREADS -T3'
# this is especially relevant to amino acid tests which take a while
# 

# Get set up
mkdir -p test.output


# TEST1: Nucleotide data under GTRGAMMA without partitions
# constraint tree is much less likely than tree w/highest likelihood
# p-value should be 0 or close to 0
sowhat --constraint=examples/H1.tre --aln=examples/nt.phy --model=GTRGAMMA --dir=test.output/test1 --name=nt.H1

# TEST2:
# constraint tree is a viable hypothesis but not the tree w/highest likelihood
# p-value should be > 0.05 
sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --model=GTRGAMMA --dir=test.output/test2 --name=nt.H0

# TEST3:
# this is a case where the SOWH test fails to provide a consistent answer
# as to whether the constraint tree is a viable hypothesis 
# p-value will vary (run several times and you will see)
sowhat --constraint=examples/H2.tre --aln=examples/nt.phy --model=GTRGAMMA --dir=test.output/test3 --name=nt.H2

# TEST4: Amino acid data under PROTGAMMAWAG with partitions
# constraint tree is much less likely than tree w/highest likelihood
# p-value should be 0 or close to 0
sowhat --constraint=examples/H1.tre --aln=examples/aa.phy --partition=examples/aa.partitions --model=PROTGAMMAWAG --dir=test.output/test4 --name=aa.H1.parts

# TEST5: Nucleotide data under GTRCAT with partitions
# constraint tree is much less likely than tree w/highest likelihood
# p-value should be 0 or close to 0
sowhat --constraint=examples/H1.tre --aln=examples/nt.phy --partition=examples/nt.partitions --model=GTRCAT --dir=test.output/test5 --name=nt.H1.parts

# TEST6: Binary character data 
# constraint tree is much less likely than tree w/highest likelihood
# p-value should be 0 or close to 0
sowhat --constraint=examples/H1.tre --aln=examples/char.phy --model=MULTIGAMMA --dir=test.output/test6 --name=char.H1

# TEST7: Nucleotide data using PhyloBayes for the null distribution
sowhat --constraint=examples/H1.tre --aln=examples/nt.phy --model=GTRGAMMA --dir=test.output/test1 --name=nt.H1.pb --usepb

# TEST8: CURRENT TEST - CHAINS and RECALCULATE:
sowhat --constraint=examples/H1.tre --aln=examples/nt.phy --model=GTRGAMMA --dir=test.output/test8 --name=nt.H1   --chains=2 --reps=100 --rerun

