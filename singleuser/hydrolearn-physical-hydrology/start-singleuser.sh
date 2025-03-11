#!/bin/bash
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

# modified version of start-singleuser that activates
# a specific user environment before starting.
# added by tony castronova <acastronova@cuahsi.org> on
# 09.05.2023
source activate physical-hydrology

set -e

# set default ip to 0.0.0.0
if [[ "${NOTEBOOK_ARGS} $*" != *"--ip="* ]]; then
    NOTEBOOK_ARGS="--ip=0.0.0.0 ${NOTEBOOK_ARGS}"
fi

# shellcheck disable=SC1091,SC2086
. /usr/local/bin/start.sh jupyterhub-singleuser ${NOTEBOOK_ARGS} "$@"

