# TEST SUITE

# 1, MODEL 1, 100

perl sowhat --constraint=published_datasets/Sullivan12S.H1.tre --aln=published_datasets/Sullivan12S.phy --model=GTRGAMMA --dir=sull.test1 --name=sull --reps=100 --runs=10 >output.sull.test1 

# 2, MODEL 1, 500

perl sowhat --constraint=published_datasets/Sullivan12S.H1.tre --aln=published_datasets/Sullivan12S.phy --model=GTRGAMMA --dir=/users/shchurch/scratch/sull.tesH1 --name=sull --reps=500 --runs=10 >output.sull.tesH1 

# 3, MODEL 1, STOP

perl sowhat --constraint=published_datasets/Sullivan12S.H1.tre --aln=published_datasets/Sullivan12S.phy --model=GTRGAMMA --dir=sull.test3 --name=sull --stop--runs=10 >output.sull.test3

# 4, MODEL MAX, STOP

perl sowhat --constraint=published_datasets/Sullivan12S.H1.tre --aln=published_datasets/Sullivan12S.phy --model=GTRGAMMA --dir=sull.test4 --name=sull --reps=100 --runs=10 --max >output.sull.test4 

# 5, MODEL PB, STOP

perl sowhat --constraint=published_datasets/Sullivan12S.H1.tre --aln=published_datasets/Sullivan12S.phy --model=GTRGAMMA --dir=sull.test5 --name=sull --reps=100 --runs=10 --usepb >output.sull.test5 

# 6, NO GAP, STOP

# perl sowhat --constraint=published_datasets/Sullivan12S.H1.tre --aln=published_datasets/Sullivan12S.phy --model=GTRGAMMA --dir=sull.test6 --name=sull --reps=100 --runs=10 >output.sull.test6 

# 7, RERUN, STOP

perl sowhat --constraint=published_datasets/Sullivan12S.H1.tre --aln=published_datasets/Sullivan12S.phy --model=GTRGAMMA --dir=sull.test7 --name=sull --reps=100 --runs=10 --rerun >output.sull.test7 

# 8, GARLI, STOP

# perl sowhat --constraint=published_datasets/Sullivan12S.H1.garli.tre --aln=published_datasets/Sullivan12S.phy --dir=sull.test8 --name=sull --reps=100 --runs=10 --usegarli --garli_conf=examples/garli.conf >output.sull.test8 

# 9, GARLI MAX, STOP

# perl sowhat --constraint=published_datasets/Sullivan12S.H1.garli.tre --aln=published_datasets/Sullivan12S.phy --dir=sull.test9 --name=sull --reps=100 --runs=10 --usegarli --garli_conf=examples/garli.conf --max >output.sull.test9 
