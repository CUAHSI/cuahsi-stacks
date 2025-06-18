#!/usr/bin/env bash

docker build --build-arg BASE_VERSION=2025.06.03 -t cuahsi/singleuser:py3-sci-testing .
