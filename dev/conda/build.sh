#!/bin/bash

cpanm Statistics::R
cpanm IPC::Run

perl Makefile.PL
make
make test
make install
