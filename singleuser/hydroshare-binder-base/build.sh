#!/usr/bin/env bash

if [ $# -lt 2 ]
then
    echo "Usage: ./build [BASEVERSION] [TAG]"
    echo "E.g. : ./build.sh base-2020.04.23 ubuntu-2020.04.23"
    exit 1
fi


BASE_VERSION=$1
TAG=$2

docker build \
    --build-arg BASE_VERSION=$BASE_VERSION \
    -t cuahsi/hydroshare-binder:$TAG . 

