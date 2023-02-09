#!/usr/local/env python3


"""
Entrypoint for the ESMF-regridding container, requires Python 3.9+

Author: Tony Castronova <acastronova@cuahsi.org>
Date: 07.08.2022
Org: Consortium of Universities for the Advancement of Hydrologic Sciences, Inc
"""

import sys
import argparse
import subprocess
from typing import Dict, Union
from pathlib import Path


class Regrid():
    def __init__(self, parser):
        self.parser = parser

    def execute(self, geogrid: str, method: str) -> bool:

        # regrid forcing
        cmd = f"""ncl 'srcFileName="*.grb"' 'dstGridName="{geogrid}"' {method}2WRFHydro_regrid.ncl"""
        p = subprocess.Popen(cmd, shell=True)
        _, _ = p.communicate()

        if p.returncode != 0:
            return False
        return True

    def prepare(
        self,
        geogrid: Union[str, Path],
        method: Union[str, Path],
        forcing_path: Union[str, Path],
        interp: str,
        verbose: bool = False,
    ) -> bool:

        # convert input args to Path objects
        forcing_path = Path(forcing_path)
        geogrid_path = Path(geogrid)

        if verbose:
            self.fmt_message(
                "Preparing Regridding",
                {
                    "Geogrid": f"{geogrid_path}",
                    "Forcing Path": f"{forcing_path}",
                    "Interp": f"{interp}"
                 },
            )

        # generate weights
        srcgrid = str(next(forcing_path.glob("*.grb")).absolute())
        cmd = f"""ncl 'interp_opt="{interp}"' 'srcGridName="{srcgrid}"' 'dstGridName="{geogrid_path}"' {method}2WRFHydro_generate_weights.ncl"""
        p = subprocess.Popen(cmd, shell=True)
        _, _ = p.communicate()

        if p.returncode != 0:
            return False

        return True

    def fmt_message(self, msg: str, args: Dict[str, str]) -> None:
        print(f'\n{"-"*25}\n{msg}\n')
        for k, v in args.items():
            print(f"{k:<15}:\t{v}")
        print(f'{"-"*25}\n')


class Parser(argparse.ArgumentParser):
    def error(self, message):
        print(f"\nERROR: {message}\n\n")


if __name__ == "__main__":

    parser = Parser()
    parser.add_argument(
        "-f",
        "--forcing-path",
        help="path to the mounted directory containing the forcing files that will be regridded",
        required=True,
    )
    parser.add_argument(
        "-g",
        "--geogrid-path",
        help="path to the mounted directory containing the geogrid file that will be used as the destination grid",
        required=True,
    )
    parser.add_argument(
        "-m",
        "--method",
        help="the regridding method that will be used",
        choices=[
            "NLDAS",
        ],
        required=True,
    )
    parser.add_argument(
        "-i",
        "--interp",
        choices=["conserve", "bilinear"],
        default="bilinear",
        help="interpolation method to use",
    )
    parser.add_argument(
        "-v",
        "--verbose",
        help="enable verbose mode",
        action="store_true",
        default=False,
    )
    args = parser.parse_args()

    regrid = Regrid(parser)

    # prepare
    success = regrid.prepare(
        args.geogrid_path, args.method, args.forcing_path, args.interp, args.verbose
    )
    if not success:
        print("Error encountered while generating weights")
        sys.exit(1)

    # execute
    success = regrid.execute(args.geogrid_path, args.method)
    if not success:
        print(f"Error encountered while regridding: {args.method}")
        sys.exit(1)

