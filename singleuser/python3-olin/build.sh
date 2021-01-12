#!/usr/bin/env bash

#if [ -z "$1" ]
#  then
#    echo "Must provide image BASE_VERSION as input, e.g. 1.0.1"
#    exit 1
#fi
#
#BASE_VERSION=$1

docker build \
    -t cuahsi/singleuser:python3-olin .
#    --build-arg BASE_VERSION=$BASE_VERSION \

