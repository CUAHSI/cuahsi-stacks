#!/bin/bash

#BASE_VERSION=2023.02.27
#TAG=$(date +"%s")
TAG=hecras

docker build -f Dockerfile.hecras -t cuahsi/si-$TAG:latest .
