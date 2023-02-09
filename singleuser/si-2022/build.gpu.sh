#!/bin/bash

TAG=$(date +"%s")

docker build -t cuahsi/singleuser-si:gpu-$TAG -f Dockerfile.gpu .
