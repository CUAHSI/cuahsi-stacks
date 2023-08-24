#!/bin/bash

#BASE_VERSION=2023.02.27
#TAG=$(date +"%s")
TAG=swmm

docker build -f Dockerfile.swmm -t cuahsi/si-$TAG:latest .
