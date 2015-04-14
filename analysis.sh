#!/bin/bash

#SBATCH -t 14-00:00:00

module load R/3.0.0;
module load phylobayes/3.3f;

# ANALYSIS: Rodent Dataset

# TEST 1: sample size using GTRGAMMA

perl sowhat --constraint=published_datasets/Sullivan12S.t2.tre --aln=published_datasets/Sullivan12S.phy --model=GTRGAMMA --dir=/users/shchurch/scratch/sull.test1 --name=sull.test1 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.sull.test1 --reps=500 --runs=100

#Plot p-values

grep p-value: /users/shchurch/scratch/sull.test1/sowhat.results.* >analysis/sull.test1.pvals
R CMD BATCH --no-save --no-restore '--args analysis/sull.test1' analysis/stats.r

# TEST 2: model effects, using CAT model with PhyloBayes for simulation

perl sowhat --constraint=published_datasets/Sullivan12S.t2.tre --aln=published_datasets/Sullivan12S.phy --model=GTRGAMMA --dir=/users/shchurch/scratch/sull.test2 --name=sull.test2 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.sull.test2 --reps=500 --usepb

# TEST 3: RAxML consistent optimization

perl sowhat --constraint=published_datasets/Sullivan12S.t2.tre --aln=published_datasets/Sullivan12S.phy --model=GTRGAMMA --dir=/users/shchurch/scratch/sull.test3 --name=sull.test3 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.sull.test3 --reps=500 --rerun

# ANALYSIS: Reptile Dataset

# TEST 1: sample size using GTRGAMMA

perl sowhat --constraint=published_datasets/castoe.t1.tre --aln=published_datasets/castoe2009.phy --partition=published_datasets/castoe.parts.txt --model=GTRGAMMA --dir=/users/shchurch/scratch/castoe.test1 --name=castoe.test1 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.castoe.test1 --reps=500 --runs=20

#Plot p-values

grep p-value: /users/shchurch/scratch/castoe.test1/sowhat.results.* >analysis/castoe.test1.pvals
R CMD BATCH --no-save --no-restore '--args analysis/castoe.test1' analysis/stats.r

# TEST 2: model effects, using CAT model with PhyloBayes for simulation
#		 partition effects as well

perl sowhat --constraint=published_datasets/castoe.t1.tre --aln=published_datasets/castoe2009.phy.reduced --partition=published_datasets/castoe.parts.txt.reduced --model=GTRGAMMA --dir=/users/shchurch/scratch/castoe.test2.0 --name=castoe.test2.0 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.castoe.test2.0 --reps=500 --usepb

perl sowhat --constraint=published_datasets/castoe.t1.tre --aln=published_datasets/castoe2009.phy --model=GTRGAMMA --dir=/users/shchurch/scratch/castoe.test2.1 --name=castoe.test2.1 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.castoe.test2.1 --reps=500

perl sowhat --constraint=published_datasets/castoe.t1.tre --aln=published_datasets/castoe2009.phy --model=GTRGAMMA --dir=/users/shchurch/scratch/castoe.test2.2 --name=castoe.test2.2 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.castoe.test2.2 --usepb --reps=500

# TEST 3: RAxML consistent optimization

perl sowhat --constraint=published_datasets/castoe.t1.tre --aln=published_datasets/castoe2009.phy --partition=published_datasets/castoe.parts.txt --model=GTRGAMMA --dir=/users/shchurch/scratch/castoe.test3 --name=castoe.test3 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.castoe.test3 --reps=500 --rerun

# TEST 4: effect of gaps

perl sowhat --constraint=published_datasets/castoe.t1.tre --aln=published_datasets/castoe2009.phy --partition=published_datasets/castoe.parts.txt --model=GTRGAMMA --dir=/users/shchurch/scratch/castoe.test4 --name=castoe.test4 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.castoe.test4 --reps=500 --gaps

# ANALYSIS: ATGC Dataset

# TEST 1: sample size using LG/GTRUNLINKED

perl sowhat --constraint=published_datasets/protein.t1.tre --aln=published_datasets/proteic_M1384_11x391_2003.phy --model=PROTGAMMALG --dir=/users/shchurch/scratch/prot.test1 --name=prot.test1 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.prot.test1 --reps=500 --runs=20

#Plot p-values

grep p-value: /users/shchurch/scratch/prot.test1/sowhat.results.* >analysis/prot.test1.pvals
R CMD BATCH --no-save --no-restore '--args analysis/prot.test1' analysis/stats.r

# TEST 2: model effects using LG/CAT

perl sowhat --constraint=published_datasets/protein.t1.tre --aln=published_datasets/proteic_M1384_11x391_2003.phy --model=PROTGAMMALG --dir=/users/shchurch/scratch/prot.test2 --name=prot.test2 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.prot.test2 --reps=500 --usepb

# TEST 3: RAxML consistent optimization

perl sowhat --constraint=published_datasets/protein.t1.tre --aln=published_datasets/proteic_M1384_11x391_2003.phy --model=PROTGAMMALG --dir=/users/shchurch/scratch/prot.test3 --name=prot.test3 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.prot.test3 --reps=500 --rerun