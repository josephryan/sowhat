#!/bin/bash

#SBATCH -t 14-00:00:00

module load R/3.0.0;
module load phylobayes/3.3f;

perl sowhat --rax=/users/shchurch/scratch/FB_analyses/raxmlHPC --garli=/users/shchurch/scratch/FB_analyses/Garli-2.01 --seqgen=/users/shchurch/scratch/FB_analyses/seq-gen --aln=published_datasets/castoe2009.phy --constraint=published_datasets/castoe.t1.tre --dir=analysis/C30 --model=GTRGAMMA --name=C30 --reps=100 >output.C30
