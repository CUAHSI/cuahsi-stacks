#!/bin/bash

docker run --rm -ti \
    --mount type=bind,source="$(pwd)"/ngen/data,target=/data \
    --entrypoint=/bin/bash \
    cuahsi/singleuser-si:1651515689

# Test model execution using the following command
# ngen data/catchment_data.geojson "" data/nexus_data.geojson "" data/example_realization_config.json

