#!/usr/bin/env bash

TAG=$(echo $(hexdump -n 6 -e '4/4 "%08X" 1 "\n"' /dev/random) | tr '[:upper:]' '[:lower:]')
TAG=fix.r3
RVERSION=423

docker build -f Dockerfile.r -t cuahsi/singleuser-r$RVERSION:$TAG .

