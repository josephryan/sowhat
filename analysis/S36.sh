#!/bin/bash

#SBATCH -t 14-00:00:00

module load R/3.0.0;
module load phylobayes/3.3f;

perl sowhat --rax=/users/shchurch/scratch/FB_analyses/raxmlHPC --garli=/users/shchurch/scratch/FB_analyses/Garli-2.01 --seqgen=/users/shchurch/scratch/FB_analyses/seq-gen --aln=published_datasets/Sullivanetal2000.phy --constraint=published_datasets/Sullivanetal2000.tre --model=GTRGAMMAI --dir=analysis/S36 --name=S36 --reps=100 --nogaps >output.S36