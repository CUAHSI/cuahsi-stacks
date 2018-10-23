#!/bin/bash 


# run tests inside singleuser container
#docker run --rm -u root -ti -v $(pwd)/entry.sh:/tmp/entry.sh \
docker run --rm -u root -ti $IMAGE \
"cd /tmp/dakota/build/test && ctest -j 4 -L FastTest -LE Diff && ctest -j 4 -L AcceptanceTest"


