#!/bin/bash

if [ -z "$1" ]
  then
    IMG='cuahsi/singleuser-si-fim:latest'
  else
    IMG=$1
fi

docker run --rm -ti \
    -v $(pwd)/taudem-test-data:/tmp/taudem-test-data \
    --entrypoint=/bin/bash \
    --user=root \
    $IMG
