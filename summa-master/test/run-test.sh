#!/usr/bin/env bash

# run the test case to make sure the container works
docker run --rm -ti \
-v $(pwd):/tmp/summa \
-e LOCALBASEDIR=test01 \
-e MASTERPATH=test01/settings/celia1990/summa_fileManager_celia1990.txt \
cuahsi/summa:master -x

#--entrypoint /bin/bash \
