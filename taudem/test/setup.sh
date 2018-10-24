#!/usr/bin/env bash


# install testing framework
cd /tmp 
git clone https://github.com/sstephenson/bats.git
cd bats
./install.sh /usr/local
git clone https://github.com/ztombol/bats-support /tmp/bats-support
git clone https://github.com/ztombol/bats-assert /tmp/bats-assert
git clone https://github.com/ztombol/bats-file /tmp/bats-file

# get the taudem test data from github
cd /tmp 
git clone https://github.com/dtarb/TauDEM-Test-Data.git; git pull

# move the custom test cases into this directory
cp /tmp/tests.sh /tmp/TauDEM-Test-Data/Input/tests.sh
chmod +x /tmp/TauDEM-Test-Data/Input/tests.sh

# run tests
cd /tmp/TauDEM-Test-Data/Input; ./tests.sh

