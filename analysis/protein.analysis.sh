#!/bin/bash

#SBATCH -t 14-00:00:00

module load R/3.0.0;
module load phylobayes/3.3f;

#ANALYSIS 

#Test 1 - runs=100 reps=100

perl sowhat --constraint=published_datasets/protein.t1.tre --aln=published_datasets/proteic_M1384_11x391_2003.phy --model=PROTGAMMALG --dir=/users/shchurch/scratch/prot.test1 --name=prot.test1 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.prot.test1 --reps=100 --runs=100

#Plot p-values

grep p-value: /users/shchurch/scratch/prot.test1/sowhat.results.* >analysis/prot.test1.pvals
R CMD BATCH --no-save --no-restore '--args analysis/prot.test1' analysis/stats.r

#Test 2 - runs=4 reps=200

perl sowhat --constraint=published_datasets/protein.t1.tre --aln=published_datasets/proteic_M1384_11x391_2003.phy --model=PROTGAMMALG --dir=/users/shchurch/scratch/protein.t1.tre.test2 --name=prot.test2 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.prot.test2 --reps=200 --runs=4

#Test 3 - runs=100 reps=200

perl sowhat --constraint=published_datasets/protein.t1.tre --aln=published_datasets/proteic_M1384_11x391_2003.phy --model=PROTGAMMALG --dir=/users/shchurch/scratch/prot.test3 --name=prot.test3 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.prot.test3 --reps=200 --runs=100

#Plot p-values

grep p-value: /users/shchurch/scratch/prot.test3/sowhat.results.* >analysis/prot.test3.pvals
R CMD BATCH --no-save --no-restore '--args analysis/prot.test3' analysis/stats.r

#Test 4 - runs=100 reps=200 rerun

perl sowhat --constraint=published_datasets/protein.t1.tre --aln=published_datasets/proteic_M1384_11x391_2003.phy --model=PROTGAMMALG --dir=/users/shchurch/scratch/prot.test4 --name=prot.test4 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.prot.test4 --reps=200 --runs=100 --rerun

#Plot p-values

grep p-value: /users/shchurch/scratch/prot.test4/sowhat.results.* >analysisprot.test4.pvals
R CMD BATCH --no-save --no-restore '--args analysis/prot.test4' analysis/stats.r

#Test 5 - runs=100 reps=200 usepb

perl sowhat --constraint=published_datasets/protein.t1.tre --aln=published_datasets/proteic_M1384_11x391_2003.phy --model=PROTGAMMALG --dir=/users/shchurch/scratch/prot.test5 --name=prot.test5 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.prot.test5 --reps=200 --runs=100 --usepb

#Plot p-values

grep p-value: /users/shchurch/scratch/prot.test5/sowhat.results.* >analysisprot.test5.pvals
R CMD BATCH --no-save --no-restore '--args analysis/prot.test5' analysis/stats.r


