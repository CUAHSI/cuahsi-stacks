#!/bin/bash

TAG=$(date +"%s")

docker build -t cuahsi/conda-si:$TAG -f Dockerfile.conda .
