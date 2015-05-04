#!/bin/bash

#SBATCH -t 14-00:00:00

module load R/3.0.0;
module load phylobayes/3.3f;

perl sowhat --rax=/users/shchurch/scratch/FB_analyses/raxmlHPC --garli=/users/shchurch/scratch/FB_analyses/Garli-2.01 --seqgen=/users/shchurch/scratch/FB_analyses/seq-gen --aln=published_datasets/Dunnetal2005.phy --constraint=published_datasets/Dunnetal2005.tre --model=GTRGAMMAI --dir=analysis/D71 --name=D71 --reps=100 --initial >output.D71

perl sowhat --rax=/users/shchurch/scratch/FB_analyses/raxmlHPC --garli=/users/shchurch/scratch/FB_analyses/Garli-2.01 --seqgen=/users/shchurch/scratch/FB_analyses/seq-gen --aln=published_datasets/Dunnetal2005.phy --constraint=published_datasets/Dunnetal2005.tre --model=GTRGAMMAI --dir=analysis/D71 --name=D71 --reps=100 --usegentree=published_datasets/Dunnetal2005.D71.susko.tre >output.D71