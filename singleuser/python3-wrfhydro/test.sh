#!/usr/bin/env bash

TAG=$1
docker run --rm -ti -u root \
    -v $(pwd)/DOMAIN:/tmp/input/DOMAIN \
    -v $(pwd)/hydro.namelist:/tmp/input/hydro.namelist \
    -v $(pwd)/namelist.hrldas:/tmp/input/namelist.hrldas \
    cuahsi/singleuser-wrfhydro-py3:$TAG bash
