#!/bin/bash

#TAG=$(date +"%s")
TAG=latest

docker build -t cuahsi/singleuser-si:gpu-$TAG -f Dockerfile.gpu .
