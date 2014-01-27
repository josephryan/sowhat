# PROTEIN

# 100 SOWH tests - t1 - 100 reps

perl sowhat --constraint=published_datasets/protein.t1.tre --aln=published_datasets/protein.benchmark.phy --model=PROTGAMMAWAG --dir=test.output/1.prot.sowh.t1 --name=1.prot.sowh.t1 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.1.prot.sowh.t1 --reps=100 --runs=100

# 100 SOWH tests - t2 - 100 reps

perl sowhat --constraint=published_datasets/protein.t2.tre --aln=published_datasets/protein.benchmark.phy --model=PROTGAMMAWAG --dir=test.output/2.prot.sowh.t2 --name=2.prot.sowh.t2 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.2.prot.sowh.t2 --reps=100 --runs=100

# check distributions of p-values

# 4 SOWH tests - t1 - max 1000 reps

perl sowhat --constraint=published_datasets/protein.t1.tre --aln=published_datasets/protein.benchmark.phy --model=PROTGAMMAWAG --dir=test.output/3.prot.sowh.t1 --name=3.prot.sowh.t1 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.3.prot.sowh.t1 --reps=1000 --runs=4

# 4 SOWH tests - t2 - max 1000 reps

perl sowhat --constraint=published_datasets/protein.t2.tre --aln=published_datasets/protein.benchmark.phy --model=PROTGAMMAWAG --dir=test.output/4.prot.sowh.t2 --name=4.prot.sowh.t2 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.4.prot.sowh.t1 --reps=1000 --runs=4

# check convergence 

# 100 SOWH tests - t1 - 1000 reps

perl sowhat --constraint=published_datasets/protein.t1.tre --aln=published_datasets/protein.benchmark.phy --model=PROTGAMMAWAG --dir=test.output/5.prot.sowh.t1 --name=5.prot.sowh.t1 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.5.prot.sowh.t1 --reps=1000 --runs=100

# 100 SOWH tests - t2 - 1000 reps

perl sowhat --constraint=published_datasets/protein.t2.tre --aln=published_datasets/protein.benchmark.phy --model=PROTGAMMAWAG --dir=test.output/6.prot.sowh.t2 --name=6.prot.sowh.t2 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.6.prot.sowh.t1 --reps=1000 --runs=100

# check distributions of p-values

# 100 SOWH tests - t1 - rerun - 1000 reps

perl sowhat --constraint=published_datasets/protein.t1.tre --aln=published_datasets/protein.benchmark.phy --model=PROTGAMMAWAG --dir=test.output/7.prot.sowh.t1 --name=7.prot.sowh.t1 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.7.prot.sowh.t1 --reps=1000 --runs=100 --rerun

# check distribution of p-values

# 100 SOWH tests - t1 - usepb - 1000 reps

perl sowhat --constraint=published_datasets/protein.t1.tre --aln=published_datasets/protein.benchmark.phy --model=PROTGAMMAWAG --dir=test.output/8.prot.sowh.t1 --name=8.prot.sowh.t1 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.8.prot.sowh.t1 --reps=1000 --runs=100 --usepb

# check distribution of p-values

# SULLIVAN

# 100 SOWH tests - accepted (t2) - 100 reps

perl sowhat --constraint=published_datasets/Sullivan12S.t2.tre --aln=published_datasets/Sullivan12S.phy --model=GTRGAMMA --dir=test.output/9.sull.sowh.t2 --name=9.sull.sowh.t1 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.9.sull.sowh.t1 --reps=100 --runs=100
 
# check p-values

# 4 SOWH tests - t2 - 1000 reps

perl sowhat --constraint=published_datasets/Sullivan12S.t2.tre --aln=published_datasets/Sullivan12S.phy --model=GTRGAMMA --dir=test.output/10.sull.sowh.t2 --name=10.sull.sowh.t1 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.10.sull.sowh.t1 --reps=1000 --runs=4

# check convergence

# 100 SOWH tests - t2 - 1000 reps

perl sowhat --constraint=published_datasets/Sullivan12S.t2.tre --aln=published_datasets/Sullivan12S.phy --model=GTRGAMMA --dir=test.output/11.sull.sowh.t2 --name=11.sull.sowh.t1 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.11.sull.sowh.t1 --reps=1000 --runs=100

# check p-values

# 100 SOWH tests - t2 - rerun - 1000 reps

perl sowhat --constraint=published_datasets/Sullivan12S.t2.tre --aln=published_datasets/Sullivan12S.phy --model=GTRGAMMA --dir=test.output/12.sull.sowh.t2 --name=12.sull.sowh.t1 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.12.sull.sowh.t1 --reps=1000 --runs=100 --rerun

# 100 SOWH tests - t2 - usepb - 1000 reps

perl sowhat --constraint=published_datasets/Sullivan12S.t2.tre --aln=published_datasets/Sullivan12S.phy --model=GTRGAMMA --dir=test.output/13.sull.sowh.t2 --name=13.sull.sowh.t1 --rax=~/data/shchurch/SOWH/src/raxmlHPC --seqgen=~/data/shchurch/SOWH/src/Seq-Gen.v1.3.3/source/seq-gen >output.13.sull.sowh.t1 --reps=1000 --runs=100 --usepb

# check p-values

