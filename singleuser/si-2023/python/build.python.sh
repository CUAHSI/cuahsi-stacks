#!/bin/bash

#BASE_VERSION=2023.02.27
#TAG=$(date +"%s")
TAG=python-deps

docker build -f Dockerfile.python -t cuahsi/si-$TAG:latest .
