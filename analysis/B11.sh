#!/bin/bash

#SBATCH -t 14-00:00:00

module load R/3.0.0;
module load phylobayes/3.3f;

perl sowhat --rax=/users/shchurch/scratch/FB_analyses/raxmlHPC --garli=/users/shchurch/scratch/FB_analyses/Garli-2.01 --seqgen=/users/shchurch/scratch/FB_analyses/seq-gen --aln=published_datasets/Sullivan12S.phy --constraint=published_datasets/Sullivan12S.H0.tre --model=GTRGAMMA --dir=analysis/B11 --name=B11 --reps=1000 --rerun >output.B11