#!/bin/bash 

if [ $# -lt 1 ]
then
    echo "Usage: ./build.sh [TAG]"
    echo "E.g. : ./build 2020.04.23"
    exit 1
fi

TAG=$1

docker build -f Dockerfile.base -t cuahsi/singleuser:base-$TAG .

