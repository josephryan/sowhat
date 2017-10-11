#!/bin/bash

# cd to location of makefile
cd $SRC_DIR
cd Seq-Gen.v1.3.3/source

make

mkdir -p $PREFIX/bin

cp seq-gen $PREFIX/bin
