#!/bin/bash

#SBATCH -t 14-00:00:00

module load R/3.0.0;
module load phylobayes/3.3f;

perl sowhat --rax=/users/shchurch/scratch/FB_analyses/raxmlHPC --garli=/users/shchurch/scratch/FB_analyses/Garli-2.01 --seqgen=/users/shchurch/scratch/FB_analyses/seq-gen --aln=published_datasets/dixonetal2007.phy --constraint=published_datasets/dixonetal2007.garli.tre --dir=analysis/D70 --name=D70 --reps=500 --usegarli --garli_conf=analysis/D70.conf --initial >output.D70

perl sowhat --rax=/users/shchurch/scratch/FB_analyses/raxmlHPC --garli=/users/shchurch/scratch/FB_analyses/Garli-2.01 --seqgen=/users/shchurch/scratch/FB_analyses/seq-gen --aln=published_datasets/dixonetal2007.phy --constraint=published_datasets/dixonetal2007.garli.tre --dir=analysis/D70 --name=D70 --reps=500 --usegarli --garli_conf=analysis/D70.conf --usegentree=published_datasets/dixonetal2007.D70.susko.tre >output.D70