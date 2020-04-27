
# Base HydroShare Binder Image for JupyterHub

**Created by:** Tony Castronova

This is the base JupyterHub "singleuser" image that CUAHSI recommends all HydroShare Binder resources start with. This extends the pangeo `base-notebook` with HydroShare specific libraries designed to work in Binder environments.  

Base Image: https://hub.docker.com/r/pangeo/pangeo-notebook-onbuild   
Additional Libraries:  
- `iCommands`: A command-line toolset for working with iRODs - [documentation](https://docs.irods.org/master/icommands/user/)   
- `TauDEM`: A suite of digital elevation model tools for hydrologic analysis - [homepage](http://hydrology.usu.edu/taudem/taudem5/index.html)  
- `hs_restclient`: A python interface for the HydroShare API - [documentation](https://hs-restclient.readthedocs.io/en/latest/)  
- `hs-tools`: A CLI interface for work with HydroShare - [documentation](https://pypi.org/project/HSTools/)  
