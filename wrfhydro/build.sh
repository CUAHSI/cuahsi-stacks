#!/bin/bash 


if [ $# -lt 1 ]
then
    echo Usage: ./build.sh [WRF_HYDRO_VERSION]
    echo E.g. : ./build v5.1.2
    echo
    echo Note: version should start with 'v'. All acceptable versions can be found at https://github.com/NCAR/wrf_hydro_nwm_public/releases
    echo
    exit 1
fi

VERSION=$1
TAG=$(echo $VERSION | cut -c2-)

docker build \
    --build-arg WRF_HYDRO_VERSION=$VERSION \
    -t cuahsi/wrfhydro-nwm:$TAG \
    .
