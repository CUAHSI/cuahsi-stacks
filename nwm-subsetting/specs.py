#!/usr/bin/env python3

from typing import Optional, Any

####################################
# Author: Tony Castronova
# Email:  acastronova.cuahsi.org
# Date:   10.23.2017
# Org:    CUAHSI
# Desc:   Standard interface for executing scientific models as sopftware
#         containers.
####################################


class SPECS():

    def execute(self, *args: Any, **kwargs: Any) -> bool:
        """
        Initiates execution of the software and/or model simulation
        Phase: Execution

        Parameters
        ----------
        *args: typing.Any
            args
        **kwargs: typing.Any
            kwargs


        Returns
        -------
        bool
            True if successful, otherwise False.
        """

        raise Exception("Function `execute` is not Implemented")
    
    
    def prepare(self, *args: Any, **kwargs: Any) -> bool:
        """
        Prepares the software and/or model simulation for execution
        Phase: Pre-execution

        Parameters
        ----------
        *args: typing.Any
            args
        **kwargs: typing.Any
            kwargs


        Returns
        -------
        bool
            True if successful, otherwise False.
        """
        raise Exception("Function `prepare` is not Implemented")
    
    
    def clean(self, success: bool=True, *args: Any, **kwargs: Any) -> None:
        """
        Performs clean-up operations after execution.
        Phase: Post-execution

        Parameters
        ----------
        success: bool
            Indicates if sofware execution was successful (True) or not (False)
        *args: typing.Any
            args
        **kwargs: typing.Any
            kwargs


        Returns
        -------
        None
        """
        raise Exception("Function `clean` is not Implemented")
    
    
    def describe(self, *args: Any, **kwargs: Any) -> str:
        """
        Provides a description of the software capabilities

        Parameters
        ----------
        *args: typing.Any
            args
        **kwargs: typing.Any
            kwargs


        Returns
        -------
        response: str
            String containing the description of software capabilities.
        """

        raise Exception("Function `describe` is not Implemented")

