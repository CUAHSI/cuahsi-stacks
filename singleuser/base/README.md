
# Base JupyterHub Singleuser Image

This is the base singleuser image for the CUAHSI JupyterHub platform. The purpose of this image is to establish a basic (and small) environment that provides integration with HydroShare, that can be extended to derived more complex images. Below are the primary tools and libraries included in this environment:

1. `hs_restclient`: A python library for interfacing with HydroShare's web API - [hs_restclient repository](https://github.com/hydroshare/hs_restclient)   
2. `iCommands`: A command-line toolset for working with iRODs - [icommands documentation](https://docs.irods.org/master/icommands/user/)   
3. `TauDEM`: A suite of digital elevation model tools for hydrologic analysis - [TauDEM homepage](http://hydrology.usu.edu/taudem/taudem5/index.html)

