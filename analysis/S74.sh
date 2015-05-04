#!/bin/bash

#SBATCH -t 14-00:00:00

module load R/3.0.0;
module load phylobayes/3.3f;

perl sowhat --rax=/users/shchurch/scratch/FB_analyses/raxmlHPC --garli=/users/shchurch/scratch/FB_analyses/Garli-2.01 --seqgen=/users/shchurch/scratch/FB_analyses/seq-gen --aln=published_datasets/Sullivanetal2000.phy --constraint=published_datasets/Sullivanetal2000.tre --model=GTRGAMMAI --dir=analysis/S74 --name=S74 --reps=100 --initial >output.S74

perl sowhat --rax=/users/shchurch/scratch/FB_analyses/raxmlHPC --garli=/users/shchurch/scratch/FB_analyses/Garli-2.01 --seqgen=/users/shchurch/scratch/FB_analyses/seq-gen --aln=published_datasets/Sullivanetal2000.phy --constraint=published_datasets/Sullivanetal2000.tre --model=GTRGAMMAI --dir=analysis/S74 --name=S74 --reps=100 --usegentree=published_datasets/Sullivanetal2000.S74.susko.tre >output.S74