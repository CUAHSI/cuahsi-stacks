# JupyterHub Scientific Computing Environment

The files in this directory are used to build the general purpose scientific
computing environment using the CUAHSI JupyterHub
[jupyterhub.cuahsi.org](https://jupyterhub.cuahsi.org). To build this
multistage image you must perform the following:


1. Build the TauDEM image located in `cuahsi_stacks/taudem`

    ```
    cd cuahsi_stacks/taudem
    docker build -f Dockerfile.ubuntu-20-focal -f cuahsi/taudem:focal
    ```

2. Build the scientific image

    ```
    cd ..
    docker-compose build scientific
    ```
