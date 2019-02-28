#!/bin/bash 

# This is a script for preparing and running modflow tests

# get input argument: image name
if [ $# -eq 0 ]
  then
    echo "No arguments supplied. Must provide an image name to test against."
    exit 1
fi
IMAGE=$1

# exit early if unzip is not installed
if ! [ -x "$(command -v wget)" ]; then
  echo 'Error: wget is not installed.' >&2
  exit 1
fi

ln -sf /usr/bin/perl5.26.1 /usr/bin/perl

dakota=dakota-6.7-release-public-src
https://dakota.sandia.gov/sites/default/files/distributions/public/dakota-6.7-release-public-src.tar.gz
wget https://dakota.sandia.gov/sites/default/files/distributions/public/$dakota.tar.gz
mkdir $dakota && tar xfz $dakota.tar.gz -C $dakota --strip-components 1

# run tests inside singleuser container
docker run --rm -u root -ti -v $(pwd)/$dakota:/tmp/dakota \
#-v $(pwd)/prepare-test-env.sh:/tmp/prepare-test-env.sh \
$IMAGE \
/bin/bash -c "cd /tmp/dakota/test; ./dakota_test.perl --label-regex=FastTest"

# remove Testdata
rm -rf $(pwd)/$dakota


