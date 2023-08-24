#!/bin/bash

if [ -z "$1" ]
  then
    IMG='cuahsi/singleuser-si:gpu-latest'
  else
    IMG=$1
fi

docker run --rm -ti \
    --entrypoint=/bin/bash \
    --user=root \
    $IMG

