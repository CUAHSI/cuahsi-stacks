#!/usr/local/env python3


"""
Entrypoint for the ESMF-regridding container, requires Python 3.9+

Author: Tony Castronova <acastronova@cuahsi.org>
Date: 07.08.2022
Org: Consortium of Universities for the Advancement of Hydrologic Sciences, Inc
"""

import os
import sys
import argparse
import subprocess
import xesmf as xe
import xarray as xr
from glob import glob
from pathlib import Path
from typing import Dict, Union


class RegridGRIB:
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
                    "Interp": f"{interp}",
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


class RegridNetCDF:
    def __init__(self, geogrid_path, method, forcing_path, interp, verbose=False):
        self.geogrid = Path(geogrid_path)
        self.method = method
        self.forcing = Path(forcing_path)
        self.interp = interp
        self.output = Path("output_files")
        self.verbose = verbose
        self.regridder = None

    def execute(self) -> bool:

        for infile in sorted(self.forcing.glob("*.nc")):

            ds = xr.open_dataset(infile)
            regridded_vars = {}

            for var in ds.data_vars:
                da = ds[var]

                # Skip variables that can't be regridded
                if set(da.dims[-2:]) not in [set(["lat", "lon"]), set(["y", "x"])]:
                    print(f"Skipping non-gridded variable: {var}")
                    continue

                try:
                    regridded_vars[var] = self.regridder(da)
                except Exception as e:
                    print(f"Could not regrid variable '{var}': {e}")

            # Save regridded variables to new NetCDF
            if regridded_vars:
                out_ds = xr.Dataset(regridded_vars)
                outfile = os.path.join(self.output, os.path.basename(infile))
                out_ds.to_netcdf(outfile)
                print(f"Saved regridded file: {outfile}")
            else:
                print(f"No variables regridded for {infile}")

        return True

    def prepare(self) -> bool:

        if self.verbose:
            self.fmt_message(
                "Preparing Regridding",
                {
                    "Geogrid": f"{self.geogrid}",
                    "Forcing Path": f"{self.forcing}",
                    "Interp": f"{self.interp}",
                },
            )

        # generate weights
        geo = xr.open_dataset(self.geogrid)
        lats = geo["XLAT_M"].squeeze()
        lons = geo["XLONG_M"].squeeze()

        target_grid = xr.Dataset(
            {
                "lat": (["y", "x"], lats.data),
                "lon": (["y", "x"], lons.data),
            }
        )

        # --- Use one input file to define source grid for weight generation ---
        sample_src = xr.open_dataset(sorted(self.forcing.glob("*.nc"))[0])

        self.regridder = xe.Regridder(
            sample_src,
            target_grid,
            method=self.interp,
            filename="generated_weights.nc",
            reuse_weights=False,
        )

        return True

    def post_process(self) -> bool:

        try:
            # rename output files to match the format expected by WRF-Hydro
            for file in self.output.glob("*.nc"):
                parts = file.name.split(".")
                new_name = f"{parts[1][1:]}{parts[2][:2]}.LDASIN_DOMAIN1"
                file.rename(self.output / new_name)
                print(f"Renamed {file.name} to {new_name}")
        except Exception:
            print("Error renaming output files")
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
        "-F",
        "--forcing-format",
        choices=["NETCDF", "GRIB"],
        default="grib",
        help="the format of the input forcing data",
    )

    parser.add_argument(
        "-v",
        "--verbose",
        help="enable verbose mode",
        action="store_true",
        default=False,
    )
    args = parser.parse_args()

    if args.forcing_format.upper() == "GRIB":

        regrid = RegridGRIB(parser)

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
    else:
        # regrid NetCDF

        regrid = RegridNetCDF(
            args.geogrid_path, args.method, args.forcing_path, args.interp, args.verbose
        )

        # prepare
        success = regrid.prepare()
        if not success:
            print("Error encountered while generating weights")
            sys.exit(1)

        # execute
        success = regrid.execute()
        if not success:
            print(f"Error encountered while regridding: {args.method}")
            sys.exit(1)

        # rename outputs files
        success = regrid.post_process()
        if not success:
            sys.exit(1)
