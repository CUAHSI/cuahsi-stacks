#!/usr/bin/env bash

BASE_VERSION=$1
WRFHYDRO_VERSION=$2
TAG=$(echo $(hexdump -n 6 -e '4/4 "%08X" 1 "\n"' /dev/random) | tr '[:upper:]' '[:lower:]')

docker build -f Dockerfile.wrfhydro --build-arg BASE_VERSION=$BASE_VERSION -t cuahsi/singleuser-wrfhydro-py3:v$WRFHYDRO_VERSION-$TAG .

