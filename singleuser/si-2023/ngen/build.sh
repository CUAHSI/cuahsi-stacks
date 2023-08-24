#!/bin/bash

#BASE_VERSION=2023.02.27
#TAG=$(date +"%s")
TAG=ngen

docker build -f Dockerfile -t cuahsi/singleuser-si:$TAG .
