#!/bin/bash 

TAG=$(echo $(hexdump -n 6 -e '4/4 "%08X" 1 "\n"' /dev/random) | tr '[:upper:]' '[:lower:]')
docker build -t cuahsi/singleuser-base:$TAG .
