#!/bin/bash

docker run --rm -ti \
  -v ./test-data:/home/jovyan/test-data \
  --entrypoint=/bin/bash \
  cuahsi/awi-ciroh-image-ngen:latest

#-p 8888:8888 \
