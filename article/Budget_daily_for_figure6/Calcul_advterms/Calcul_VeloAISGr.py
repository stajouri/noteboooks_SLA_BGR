#!/usr/bin/env python
# coding: utf-8

# AIM: save the decomposition of the horizontal advection term for all gridpoints into the 3 terms: VeloGrSGr; VeloGrSAI; VeloAISGr

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

    # --------------------
    # Variable to modify 
    # --------------------

    term = "VeloAISGr"

    # --------------------
    # loading data
    # --------------------
    chunk_size = {"deptht":1}
    diro = "/gpfsscratch/rech/cli/uor98hu/BILANS/1dDecomposition/advterms/" 
    diri="/gpfswork/rech/cli/rcli002/eORCA025.L75/eORCA025.L75-I/"
    mesh_hgr=xr.open_dataset(diri+'mesh_hgr.nc',chunks=chunk_size).squeeze()
    tmask = mesh_hgr.tmask.rename({'nav_lev':"deptht"})
    tmaskutil = mesh_hgr.tmaskutil

    e1t = mesh_hgr.e1t.fillna(0)
    e2t = mesh_hgr.e2t.fillna(0)
    e2u = mesh_hgr.e2u.fillna(0)
    e1v = mesh_hgr.e1v.fillna(0)



    # -------------------------------------------------------
    # ------------------------- VeloGrSGr -------------------
    # -------------------------------------------------------
    CONFCASE = "eORCA025.L75-IMHOTEP.G" 
    pathdata = "/gpfsscratch/rech/cli/uor98hu/BILANS/1dDecomposition/"
    path4T = "/gpfsstore/rech/cli/rcli002/eORCA025.L75/eORCA025.L75-IMHOTEP.GAI-S/1m/"

    for year in np.arange(1980,2019):
        for month in ['01','02','03','04','05','06','07','08','09','10','11','12']: # 

            y1 = str(year)
            print(y1 + "  " +month)   
            PROD_ds = xr.open_dataset(pathdata+"cdfvT/"+term+"/"+CONFCASE+"_y"+y1+"m"+month+"_1d_PROD.nc",decode_coords=False,chunks=chunk_size).squeeze()#.persist()
            T_ds = xr.open_dataset(path4T+y1+"/eORCA025.L75-IMHOTEP.GAI_y"+y1+"m"+month+".1m_gridT.nc",decode_coords=False,chunks=chunk_size).squeeze()#.persist()

            e3t = T_ds.e3t.fillna(0)
            e3u = PROD_ds.e3u.fillna(0)
            e3v = PROD_ds.e3v.fillna(0)

            US_ref = PROD_ds.vozous.fillna(0)
            VS_ref = PROD_ds.vomevs.fillna(0)

            # ------------------------
            # calcul de la advection horizontale
            # ------------------------
            # manuel NEMO 4.0.1 §4.1.
            bt = (e3t*e1t*e2t) # volume of each cell

            prod1_U = (e3u * US_ref * e2u)
            prod1_V = (e3v * VS_ref * e1v)

            deltaU = (prod1_U - prod1_U.roll(x=1)) # garder en tete que le premier point est pas bon
            deltaV = (prod1_V - prod1_V.roll(y=1)) # garder en tete que le premier point est pas bon

            DIV = ( deltaU + deltaV ).where(tmask)
            DIV = DIV * tmaskutil * (-1)
            adv_h = DIV/bt
            adv_h = adv_h.compute()
            dsadv_h = adv_h.to_dataset(name = term)

            # saving
            dsadv_h.to_netcdf(path=diro+CONFCASE+"_y"+y1+"m"+month+".1m_"+term+".nc", mode='w')

