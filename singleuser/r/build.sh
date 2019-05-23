#!/usr/bin/env bash

TAG=$(echo $(hexdump -n 6 -e '4/4 "%08X" 1 "\n"' /dev/random) | tr '[:upper:]' '[:lower:]')
TAG=0.1

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
fi

docker build -f Dockerfile.r -t cuahsi/singleuser-r351:$TAG .

