#!/bin/bash 


if [ $# -lt 1 ]
then
    echo Usage: ./build.sh [VERSION]
    echo E.g. : ./build v5.1.2
    echo
    exit 1
fi

VERSION=$1

docker build \
    -t cuahsi/nwm-domain-subset:$VERSION \
    .
