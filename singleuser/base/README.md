
# Base JupyterHub Singleuser Image

This is the base singleuser image for the CUAHSI JupyterHub platform. The purpose of this image is to establish a basic (and small) environment that provides integration with HydroShare, that can be extended to derived more complex images. Below are the primary tools and libraries included in this environment:

1. `hsclient`: A python client for interacting with HydroShare in an object oriented way - [repo](https://github.com/hydroshare/hsclient/).
1. `hydroshare_on_jupyter`: JupyterLab plugin for interacting with HydroShare resources within JupyterLab's development environment - [repo](https://github.com/hydroshare/hydroshare_jupyter_sync). 
1. `iCommands`: A command-line toolset for working with iRODs - [icommands documentation](https://docs.irods.org/master/icommands/user/)   
1. `TauDEM`: A suite of digital elevation model tools for hydrologic analysis - [TauDEM homepage](http://hydrology.usu.edu/taudem/taudem5/index.html)

