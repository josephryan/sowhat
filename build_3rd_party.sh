#!/bin/bash
# Modified from https://bitbucket.org/caseywdunn/biolite/raw/e90e9c351960970ed24086a5d8fa44d296aef7ae/build_3rd_party.sh

if [ "$1" == "-h" ]
then
	echo "usage: build_3rd_party.sh [PREFIX] [CC] [CXX] [OPT]" >&2
	exit 0
fi

OSNAME=`uname`
OSBIT=`uname -m`
if [ "$OSBIT" != "x86_64" ]
then
	echo "ERROR: you're OS does not appear to be 64-bit" >&2
	exit 1
fi

PREFIX=${1-"/usr/local"}
CC=${2-"gcc"}
CXX=${3-"g++"}
OPT=${4-"-O3"}

BUILD_DIR="build"

set -o nounset
set -o errexit

# Convert relative path to absolute path.
[ "${PREFIX:0:1}" != "/" ] && PREFIX="$PWD/$PREFIX"

echo "Installing to $PREFIX"

BINDIR=$PREFIX/bin
LIBDIR=$PREFIX/lib
OPTDIR=$PREFIX/opt

download() {
	# $1:URL $2:SHA1 $3:FILE
	echo "Downloading $1 ..."
	if [ -f $3 ]
	then
		if [ `shasum $3 | cut -d ' ' -f 1` != "$2" ]
		then
			echo "WARNING: removing corrupt download '$3'" >&2
			rm $3
		fi
	fi
	[ -f $3 ] || wget $1 -O $3
	if [ `shasum $3 | cut -d ' ' -f 1` != "$2" ]
	then
		echo "ERROR: downloaded file is corrupt? (wrong SHA1 sum)" >&2
		exit 1
	fi
}

need_programs() {
	for program in $@
	do
		program=$BINDIR/$program
		[ -h $program ] && program=`readlink $program`
		(command -v $program >/dev/null) || return 0
	done
	return 1
}

need_libs() {
	for lib in $@
	do
		[ -f $LIBDIR/$lib ] || return 0
	done
	return 1
}

need_other() {
	for other in $@
	do
		[ -f $other ] || return 0
	done
	return 1
}

mkdir -p $BUILD_DIR
mkdir -p $BINDIR
mkdir -p $LIBDIR
mkdir -p $OPTDIR

cd $BUILD_DIR


# RAxML
URL="https://github.com/stamatak/standard-RAxML/archive/v7.7.6.zip"
FILE=`basename $URL`
SHA1="f83c56bacbd12204862aff4c4130a5e58c1305e6"
if need_programs raxmlHPC-PTHREADS-SSE3
then
	echo "Intalling RAxML..." >&2
	download $URL $SHA1 $FILE
	unzip $FILE
	cd standard-RAxML-7.7.6
	make -f Makefile.gcc CC="$CC"
	cp raxmlHPC $BINDIR/
	cd ..
else
	echo "RAxML is already installed in $PREFIX ...skipping." >&2
fi

# Seq-Gen
URL="https://github.com/josephryan/sowh.pl/blob/master/dependencies/Seq-Gen.v1.3.3.tgz"
FILE=`basename $URL`
SHA1="b96d353c963766d78bde47761bc6cecd6dae0372"
if need_programs seq-gen
then
	echo "Intalling seq-gen..." >&2
	download $URL $SHA1 $FILE
	tar xzf $FILE
	cd ${FILE%-.tgz}/source
	make
	cp seq-gen $BINDIR/
	cd ..
else
	echo "seq-gen is already installed in $PREFIX ...skipping." >&2
fi

# Take care of the other dependencies...
apt-get install r-base-core
apt-get install cpanminus
cpanm Statistics::R

