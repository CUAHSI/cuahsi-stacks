#!/bin/bash
set -x
set -e


# build mpich from source (gcc 7)
git clone git://git.mpich.org/mpich.git /tmp/mpich
cd /tmp/mpich
git submodule update --init
./autogen.sh
./configure --prefix=/usr
make -j8
make -j8 install
rm -rf /tmp/*
