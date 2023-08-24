#!/bin/bash

#BASE_VERSION=2023.02.27
#TAG=$(date +"%s")
TAG=latest

docker build -f Dockerfile -t cuahsi/singleuser-si-fim:$TAG .
