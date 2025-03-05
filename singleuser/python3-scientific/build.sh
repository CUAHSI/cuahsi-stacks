#!/usr/bin/env bash

docker build --build-arg BASE_VERSION=2025.03.03 -t cuahsi/singleuser:py3-sci-testing .
