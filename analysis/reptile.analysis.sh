#!/bin/bash

#SBATCH -t 14-00:00:00

module load R/3.0.0;
module load phylobayes/3.3f;

#ANALYSIS 

#Test 1 - runs=20 reps=100

perl sowhat --constraint=published_datasets/castoe.t1.tre --aln=published_datasets/castoe2009.phy --partition=published_datasets/castoe.parts.txt --model=GTRGAMMA --dir=/users/shchurch/scratch/castoe.test1 --name=castoe.test1 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.castoe.test1 --reps=100 --runs=20

#Plot p-values

grep p-value: /users/shchurch/scratch/castoe.test1/sowhat.results.* >analysis/castoe.test1.pvals
R CMD BATCH --no-save --no-restore '--args analysis/castoe.test1' analysis/stats.r

#Test 2 - runs=4 reps=200

perl sowhat --constraint=published_datasets/castoe.t1.tre --aln=published_datasets/castoe2009.phy --partition=published_datasets/castoe.parts.txt --model=GTRGAMMA --dir=/users/shchurch/scratch/castoe.test2 --name=castoe.test2 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.castoe.test2 --reps=200 --runs=4

#Test 3 - runs=20 reps=200

perl sowhat --constraint=published_datasets/castoe.t1.tre --aln=published_datasets/castoe2009.phy --partition=published_datasets/castoe.parts.txt --model=GTRGAMMA --dir=/users/shchurch/scratch/castoe.test3 --name=castoe.test3 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.castoe.test3 --reps=200 --runs=20

#Plot p-values

grep p-value: ~/data/shchurch/SOWH/sowhat//users/shchurch/scratch/castoe.test3/sowhat.results.* >analysis/castoe.test3.pvals
R CMD BATCH --no-save --no-restore '--args analysis/castoe.test3' analysis/stats.r

#Test 4 - runs=20 reps=200 rerun

perl sowhat --constraint=published_datasets/castoe.t1.tre --aln=published_datasets/castoe2009.phy --partition=published_datasets/castoe.parts.txt --model=GTRGAMMA --dir=/users/shchurch/scratch/castoe.test4 --name=castoe.test4 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.castoe.test4 --reps=200 --runs=20 --rerun

#Plot p-values

grep p-value: ~/data/shchurch/SOWH/sowhat//users/shchurch/scratch/castoe.test4/sowhat.results.* >analysis/castoe.test4.pvals
R CMD BATCH --no-save --no-restore '--args analysis/castoe.test4' analysis/stats.r

#Test 5 - runs=20 reps=200 usepb

perl sowhat --constraint=published_datasets/castoe.t1.tre --aln=published_datasets/castoe2009.phy --partition=published_datasets/castoe.parts.txt --model=GTRGAMMA --dir=/users/shchurch/scratch/castoe.test5 --name=castoe.test5 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.castoe.test5 --reps=200 --runs=20 --usepb

#Plot p-values

grep p-value: ~/data/shchurch/SOWH/sowhat//users/shchurch/scratch/castoe.test5/sowhat.results.* >analysis/castoe.test5.pvals
R CMD BATCH --no-save --no-restore '--args analysis/castoe.test5' analysis/stats.r


