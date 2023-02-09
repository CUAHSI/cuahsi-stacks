#!/bin/bash 

# This is a script for running the taudem tests

# get input argument: image name
if [ $# -eq 0 ]
  then
    echo "No arguments supplied. Must provide an image name to test against."
    exit 1
fi
IMAGE=$1

docker run --rm -u root -ti \
    -v $(pwd)/setup.sh:/tmp/setup.sh \
    -v $(pwd)/tests.sh:/tmp/tests.sh \
    --entrypoint /bin/bash \
    $IMAGE
#    -c 'cd /tmp && ./setup.sh'




