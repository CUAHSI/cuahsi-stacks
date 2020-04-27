ARG BASE_VERSION
FROM cuahsi/singleuser:$BASE_VERSION

# The purpose of this Dockerfile is to provide a HydroShare base image
# that can be used as a starting point for all Binder builds. It leverages
# the pangeo r2d_overlay code that enables Dockerfiles to be used in addition
# to the standard Binder configuration files.


# set environment variables for repo2docker
ENV REPO_DIR=/home/jovyan
ENV NB_PYTHON_PREFIX=/srv/conda/envs/notebook

USER root

# add pangeo's r2d_overlay and the repo2docker-entrypoint
COPY r2d_overlay.py /usr/local/bin/r2d_overlay.py
COPY repo2docker-entrypoint /usr/local/bin/repo2docker-entrypoint

# We aren't using --chown here since a bunch of binders
# don't run new enough Docker for it.
ONBUILD COPY . ${REPO_DIR}

# We copy contents of *child* image to a subdirectory temporarily
# This helps us apply customizations that were only from the
# child, and re-do the packages of the parent.
ONBUILD COPY . ${REPO_DIR}/.onbuild-child
ONBUILD RUN chown -R 1000:1000 ${REPO_DIR}
ONBUILD RUN /usr/local/bin/r2d_overlay.py build
ONBUILD RUN rm -rf ${REPO_DIR}/.onbuild-child

ONBUILD USER ${NB_USER}

ENTRYPOINT ["/usr/local/bin/r2d_overlay.py", "start"]
