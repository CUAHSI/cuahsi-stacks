#!/usr/bin/env bash

cd /tmp

# get dakota test cases
dakota=dakota-6.5-public.src
wget https://dakota.sandia.gov/sites/default/files/distributions/public/$dakota.tar.gz
mkdir $dakota && tar xfz $dakota.tar.gz -C $dakota --strip-components 1

## install perl
#wget http://www.cpan.org/src/5.0/perl-5.22.1.tar.gz
#tar -xzf perl-5.22.1.tar.gz
#cd /shared/perl-5.22.1
#./Configure -des -Dprefix=/opt/perl-5.22.1/localperl
#make && make install

# run the tests
cd /tmp/$dakota/test
perl dakota_test.perl --label-regex=FastTest

