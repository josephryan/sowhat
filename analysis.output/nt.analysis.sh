#!/bin/bash

#SBATCH -n 4
#SBATCH -t 14-00:00:00

module load R/3.0.0;
module load phylobayes/3.3f;

#ANALYSIS 

#Test 1 - runs=100 reps=100

perl sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --model=GTRGAMMA --dir=test.output/nt.test1 --name=nt.test1 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.nt.test1 --reps=100 --runs=100

#Check p-values

grep p-value: ~/data/shchurch/SOWH/sowhat/test.output/nt.test1/sowhat.results.* >nt.test1.pvals

#Test 2 - runs=4 reps=500

perl sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --model=GTRGAMMA --dir=test.output/nt.test2 --name=nt.test2 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.nt.test2 --reps=500 --runs=4

#Test 3 - runs=100 reps=500

perl sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --model=GTRGAMMA --dir=test.output/nt.test3 --name=nt.test3 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.nt.test3 --reps=500 --runs=100

#Check p-values

grep p-value: ~/data/shchurch/SOWH/sowhat/test.output/nt.test3/sowhat.results.* >nt.test3.pvals

#Check heuristics

#Test 4 - runs=100 reps=500 rerun

perl sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --model=GTRGAMMA --dir=test.output/nt.test4 --name=nt.test4 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.nt.test4 --reps=500 --runs=100 --rerun

#Check p-values

grep p-value: ~/data/shchurch/SOWH/sowhat/test.output/nt.test4/sowhat.results.* >nt.test4.pvals

#Test 5 - runs=100 reps=500 usepb

perl sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --model=GTRGAMMA --dir=test.output/nt.test5 --name=nt.test5 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.nt.test5 --reps=500 --runs=100 --usepb

#Check p-values

grep p-value: ~/data/shchurch/SOWH/sowhat/test.output/nt.test5/sowhat.results.* >nt.test5.pvals


