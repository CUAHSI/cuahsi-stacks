#!/bin/bash 

# get input argument: image name
if [ $# -eq 0 ]
  then
    echo "No arguments supplied. Must provide an image name to test against."
    exit 1
fi
IMAGE=$1

# run tests inside singleuser container
docker run --rm -u root -ti $IMAGE \
-c  "cd /tmp/dakota/build/test && ctest -j 4 -L FastTest -LE Diff && ctest -j 4 -L AcceptanceTest"


