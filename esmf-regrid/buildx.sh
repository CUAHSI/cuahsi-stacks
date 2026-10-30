#!/bin/bash

if [ $# -lt 1 ]; then
  echo Usage: ./build.sh [VERSION]
  echo E.g. : ./build v5.1.2
  echo
  exit 1
fi

VERSION=$1

docker buildx build \
  --platform linux/amd64 \
  -t cuahsi/wrfhydro-regrid:$VERSION \
  .
