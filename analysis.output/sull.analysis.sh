#!/bin/bash

#SBATCH -n 4
#SBATCH -t 14-00:00:00

module load R/3.0.0;
module load phylobayes/3.3f;

#ANALYSIS 

#Test 1 - runs=100 reps=100

perl sowhat --constraint=published_datasets/Sullivan12S.t2.tre --aln=published_datasets/Sullivan12S.phy --model=GTRGAMMA --dir=test.output/sull.test1.sowh.t2 --name=sull.test1.sowh.t2 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.sull.test1.sowh.t2 --reps=100 --runs=100

#Check p-values

#Test 2 - runs=4 reps=500

perl sowhat --constraint=published_datasets/Sullivan12S.t2.tre --aln=published_datasets/Sullivan12S.phy --model=GTRGAMMA --dir=test.output/sull.test2.sowh.t2 --name=sull.test2.sowh.t2 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.sull.test2.sowh.t2 --reps=500 --runs=4

#Check convergence

#Test 3 - runs=100 reps=500

perl sowhat --constraint=published_datasets/Sullivan12S.t2.tre --aln=published_datasets/Sullivan12S.phy --model=GTRGAMMA --dir=test.output/sull.test3.sowh.t2 --name=sull.test3.sowh.t2 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.sull.test3.sowh.t2 --reps=500 --runs=100

#Check p-values

#Check heuristics

#Test 4 - runs=100 reps=500 rerun

perl sowhat --constraint=published_datasets/Sullivan12S.t2.tre --aln=published_datasets/Sullivan12S.phy --model=GTRGAMMA --dir=test.output/sull.test4.sowh.t2 --name=sull.test4.sowh.t2 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.sull.test4.sowh.t2 --reps=500 --runs=100 --rerun

#Check p-values

#Test 5 - runs=100 reps=500 usepb

perl sowhat --constraint=published_datasets/Sullivan12S.t2.tre --aln=published_datasets/Sullivan12S.phy --model=GTRGAMMA --dir=test.output/sull.test5.sowh.t2 --name=sull.test5.sowh.t2 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.sull.test5.sowh.t2 --reps=500 --runs=100 --usepb

#Check p-values

#Test 6 - runs=4 reps=500 usepb

perl sowhat --constraint=published_datasets/Sullivan12S.t2.tre --aln=published_datasets/Sullivan12S.phy --model=GTRGAMMA --dir=test.output/sull.test6.sowh.t2 --name=sull.test6.sowh.t2 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.sull.test6.sowh.t2 --reps=500 --runs=4 --usepb

#Check convergence

