#!/usr/bin/env python
# coding: utf-8

# ------------------------
## ----import libraries
# ------------------------
import os,sys
import numpy as np
# xarray
import xarray as xr

from dask.distributed import Client

if __name__ == '__main__':

    c = Client()

    pathsc = "/gpfsscratch/rech/cli/uor98hu/BILANS/1dDecomposition/"

    for K in np.arange(2003,2019):
        for month in ['01', '02','03','04','05','06','07','08','09','10','11','12']: # 
            namefilesU = pathsc +str(K)+"-concat/"+"eORCA025.L75-IMHOTEP.G_y"+str(K)+"m"+month+"_1d_gridU.nc"
            namefilesV = pathsc +str(K)+"-concat/"+"eORCA025.L75-IMHOTEP.G_y"+str(K)+"m"+month+"_1d_gridV.nc"

            gridU_ds = xr.open_dataset(namefilesU,chunks={"depthu":1}).mean("time_counter")
            gridV_ds = xr.open_dataset(namefilesV,chunks={"depthv":1}).mean("time_counter")
            print(str(K)+" "+month)
            gridU_ds.to_netcdf(path=pathsc+"VeloGr1m/"+"eORCA025.L75-IMHOTEP.G_y"+str(K)+"m"+month+"_1m_gridU.nc", mode='w')
            gridV_ds.to_netcdf(path=pathsc+"VeloGr1m/"+"eORCA025.L75-IMHOTEP.G_y"+str(K)+"m"+month+"_1m_gridV.nc", mode='w')