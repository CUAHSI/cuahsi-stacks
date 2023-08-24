#!/bin/bash

# download swmm source code from epa website
wget https://www.epa.gov/sites/production/files/2018-08/swmm51013_engine_0.zip

# unzip engine files
unzip swmm51013_engine_0.zip

# extract makefiles to directory "MakeFiles"
unzip makefiles.zip -d MakeFiles

# extract source code to directory "source51013" 
unzip source5_1_013.zip -d source51013

# extract makefile to compile the shared object library (note: we overwrite the existing Readme.txt with the "-o" argument)
unzip -o MakeFiles/GNU-LIB.zip

# copy the Makefile to the directory containing the swmm5 source files
cp Makefile source51013/

# change directory
cd source51013/

# modify Makefile to avoid "/usr/bin/ld: swmm5.o: relocation R_X86_64_PC32 against symbol `ErrorCode'
# can not be used when making a shared object; recompile with -fPIC" error
sed -i "2i CFLAGS= -fPIC" Makefile

# build standalone exe
sed -i "s/xsect.o/xsect.o main.o/" Makefile
sed -i "s/-shared//" Makefile
sed -i "s/libswmm5.so/swmm5/" Makefile

# compile the shared object library
make
