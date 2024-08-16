#!/usr/bin/env python
# coding: utf-8

# AIM : save comaprable file gridT with frequency 1D of votemper, vosaline, e3t for T = T_gai - T_ai restp for salinity 

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
    diro = "/gpfsscratch/rech/cli/uor98hu/BILANS/1dDecomposition/"
    prefix = "eORCA025.L75-IMHOTEP"
    fo="1d"
    chunk_size = {"time_counter":10} # {"x":500,"y":500}
    diridat="/gpfsstore/rech/cli/rcli002/eORCA025.L75/"+prefix+"."
    
    for year in np.arange(1981,1990):
        y1 = str(year)
        print(y1)
        diroyear = y1+"-concat"
        diropath = os.path.join(diro, diroyear)

        for month in ['01','02','03','04','05','06','07','08','09','10','11', '12']: 

            print("month",month)
            ######## ---------- load GAI
            nexp = "GAI"
            print(nexp)

            fileT = diridat+nexp+"-S/"+"/1d/"+y1+"-concat"+"/"+prefix+"."+nexp+"_y"+y1+"m"+month+"_1d_gridT.nc"
        
            T_ds = xr.open_dataset(fileT,chunks = chunk_size).squeeze()

            T_GAI = T_ds.votemper

            ####### --------------- loading e3t

            e3t = T_ds.e3t
    
            ######## ---------- load AI
            nexp = "AI"
            print(nexp)

            fileT = diridat+nexp+"-S/"+"/1d/"+y1+"-concat"+"/"+prefix+"."+nexp+"_y"+y1+"m"+month+"_1d_gridT.nc"
        
            T_ds = xr.open_dataset(fileT,chunks = chunk_size).squeeze()
            T_AI = T_ds.votemper
        
            ####### --------------- compute Greenland's terms
            T_G = T_GAI - T_AI
        
            ####### --------------- loading S_G
        
            pathsc = "/gpfsscratch/rech/cli/uor98hu/BILANS/1dDecomposition/"
            fileS_G = pathsc+y1+"-concat"+"/"+"S_G_y"+y1+"m"+month+"_1d.nc"
            S_G = xr.open_dataset(fileS_G,chunks = chunk_size).S_G

            ####### ------------- save terms
            gridT = xr.Dataset(
            data_vars=dict(
                vosaline=(["time_counter","deptht","y", "x"], S_G.data),
                votemper=(["time_counter","deptht","y", "x"], T_G.data),
                e3t=(["time_counter","deptht","y", "x"], e3t.data)),
            coords=dict(
                time_counter=T_ds.time_counter.values,
                deptht=T_ds.deptht.values),
            attrs=dict(
                description="T and S from T_gai - T_ai and S_gai - S_ai"))

            print("saving")
            gridT.to_netcdf(diropath+"/"+prefix+".G_y"+y1+"m"+month+"_1d_gridT.nc", mode='w')

