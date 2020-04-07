#!/usr/bin/env bash

# v1.0
BASE_VERSION=$1

TAG=$(echo $(hexdump -n 6 -e '4/4 "%08X" 1 "\n"' /dev/random) | tr '[:upper:]' '[:lower:]')

docker build -f Dockerfile --build-arg BASE_VERSION=$BASE_VERSION -t cuahsi/parflow-singleuser:$TAG .
