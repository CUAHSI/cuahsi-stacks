Python 3.9 on alpine 3.15 with pandas and its dependencies installed. This image is a handy image to
have pre-built as build times can grow to upwards of 30 minutes because pandas is not installed via
a `wheel`.

During the build, the latest version of pandas is installed. When pushing to an image registry
please set the pandas version as the tag.

## Building

Create a `.env` file that contains the keys, `IMAGE_NAME` and `IMAGE_TAG` in this directory.  The
`.env` file will be used to set the image name and the image tag. Example:

```shell
IMAGE_NAME=gcr.io/<project-and-id>/python39_pandas
IMAGE_TAG=1.4.1
```

Do the following to build:

```shell
# build image
docker-compose build python
```

## Push to Registry

First, ensure that the image has been tagged with the appropriate `pandas` version.

```shell
# push image to registry
docker-compose push python
```
