#!/bin/bash

#SBATCH -t 14-00:00:00

module load R/3.0.0;
module load phylobayes/3.3f;

perl sowhat --rax=/users/shchurch/scratch/FB_analyses/raxmlHPC --garli=/users/shchurch/scratch/FB_analyses/Garli-2.01 --seqgen=/users/shchurch/scratch/FB_analyses/seq-gen --aln=published_datasets/Edwardsetal2005.phy --constraint=published_datasets/Edwardsetal2005.tre --dir=analysis/E72 --name=E72 --reps=100 --model=GTRGAMMAI --initial >output.E72

perl sowhat --rax=/users/shchurch/scratch/FB_analyses/raxmlHPC --garli=/users/shchurch/scratch/FB_analyses/Garli-2.01 --seqgen=/users/shchurch/scratch/FB_analyses/seq-gen --aln=published_datasets/Edwardsetal2005.phy --constraint=published_datasets/Edwardsetal2005.tre --dir=analysis/E72 --name=E72 --reps=100 --model=GTRGAMMAI --usegentree=published_datasets/Edwardsetal2005.E72.susko.tre >output.E72