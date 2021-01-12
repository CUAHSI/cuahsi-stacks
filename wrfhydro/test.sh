#!/usr/bin/env bash

#/tmp/wrf_hydro_nwm_public/trunk/NDHMS/Run
RUN_DIR=$1
docker run --rm -ti \
    -v $(pwd)/DOMAIN:/tmp/input/DOMAIN \
    -v $(pwd)/hydro.namelist:/tmp/input/hydro.namelist \
    -v $(pwd)/namelist.hrldas:/tmp/input/namelist.hrldas \
    --entrypoint=bash cuahsi/wrfhydro-nwm:5.0.3 
