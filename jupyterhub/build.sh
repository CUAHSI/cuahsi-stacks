#!/usr/bin/env bash

VERSION=$1

docker build -t cuahsi/jupyterhub:$VERSION .
