#!/bin/bash

#SBATCH -t 14-00:00:00

module load R/3.0.0;
module load phylobayes/3.3f;

perl sowhat --rax=/users/shchurch/scratch/FB_analyses/raxmlHPC --garli=/users/shchurch/scratch/FB_analyses/Garli-2.01 --seqgen=/users/shchurch/scratch/FB_analyses/seq-gen --aln=published_datasets/dixonetal2007.phy --constraint=published_datasets/dixonetal2007.tre --dir=analysis/D66 --name=D66 --reps=500 --runs=100 --model=GTRGAMMA >output.D66