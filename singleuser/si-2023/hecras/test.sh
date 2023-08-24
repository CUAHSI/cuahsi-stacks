#!/bin/bash

TAG=hecras

docker run --rm -ti \
    --entrypoint=/bin/bash \
    cuahsi/si-$TAG:latest
