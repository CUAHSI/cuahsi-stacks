#!/usr/bin/env bash

docker build \
  --build-arg BASE_VERSION=csdms-fix-latest \
  --platform=linux/amd64 \
  -t cuahsi/singleuser:py3-sci-testing .
