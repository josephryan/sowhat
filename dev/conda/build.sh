#!/bin/bash

cpanm Statistics::R

perl Makefile.PL
make
make test
make install
