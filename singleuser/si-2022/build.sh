#!/bin/bash

BASE_VERSION=2022.04.04
TAG=$(date +"%s")

docker build --build-arg BASE_VERSION=$BASE_VERSION -t cuahsi/singleuser-si:$TAG .
