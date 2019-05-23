#!/bin/bash 

TAG=$(echo $(hexdump -n 6 -e '4/4 "%08X" 1 "\n"' /dev/random) | tr '[:upper:]' '[:lower:]')
TAG=0.1
docker build -f Dockerfile.base -t cuahsi/singleuser-base:$TAG .

