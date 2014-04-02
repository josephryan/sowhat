#!/bin/bash

#SBATCH -t 14-00:00:00

module load R/3.0.0;
module load phylobayes/3.3f;

#ANALYSIS 

#Test 1 - runs=100 reps=100

perl sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --model=GTRGAMMA --dir=/users/shchurch/scratch/nt.test1 --name=nt.test1 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.nt.test1 --reps=100 --runs=100

#Plot p-values

grep p-value: /users/shchurch/scratch/nt.test1/sowhat.results.* >analysis/nt.test1.pvals
R CMD BATCH --no-save --no-restore '--args analysis/nt.test1' analysis/stats.r

#Test 2 - runs=4 reps=500

perl sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --model=GTRGAMMA --dir=/users/shchurch/scratch/nt.test2 --name=nt.test2 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.nt.test2 --reps=500 --runs=4

#Test 3 - runs=100 reps=500

perl sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --model=GTRGAMMA --dir=/users/shchurch/scratch/nt.test3 --name=nt.test3 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.nt.test3 --reps=500 --runs=100

#Plot p-values

grep p-value: /users/shchurch/scratch/nt.test3/sowhat.results.* >analysis/nt.test3.pvals
R CMD BATCH --no-save --no-restore '--args analysis/nt.test3' analysis/stats.r

#Test 4 - runs=100 reps=500 rerun

perl sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --model=GTRGAMMA --dir=/users/shchurch/scratch/nt.test4 --name=nt.test4 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.nt.test4 --reps=500 --runs=100 --rerun

#Plot p-values

grep p-value: /users/shchurch/scratch/nt.test4/sowhat.results.* >analysis/nt.test4.pvals
R CMD BATCH --no-save --no-restore '--args analysis/nt.test4' analysis/stats.r

#Test 5 - runs=100 reps=500 usepb

perl sowhat --constraint=examples/H0.tre --aln=examples/nt.phy --model=GTRGAMMA --dir=/users/shchurch/scratch/nt.test5 --name=nt.test5 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.nt.test5 --reps=500 --runs=100 --usepb

#Plot p-values

grep p-value: /users/shchurch/scratch/nt.test5/sowhat.results.* >analysis/nt.test5.pvals
R CMD BATCH --no-save --no-restore '--args analysis/nt.test5' analysis/stats.r


