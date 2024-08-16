import os,sys
import numpy as np
import xarray as xr

from dask.distributed import Client

prefix = "eORCA025.L75-IMHOTEP"
fo="1d" 
diridat="/gpfsstore/rech/cli/rcli002/eORCA025.L75/"+prefix+"."
diro = "/gpfsscratch/rech/cli/uor98hu/BILANS/1dDecomposition/RIVERS/"
chunk_size = {"time_counter":10} # {"x":500,"y":500}

for year in np.arange(1993,1995):
    y1 = str(year)
    print(y1)
    # create directory for the year
    diroyear = y1+"-concat"
    diropath = os.path.join(diro, diroyear)
    os.mkdir(diropath)
    i = 0
    for month in ['01','02','03','04','05','06','07','08','09','10','11','12']: # 
        print("month",month)

        ######## ---------- load S
        nexp = "S"
        print(nexp)

        fileT = diridat+nexp+"-S/"+"/1d/"+y1+"-concat"+"/"+prefix+"."+nexp+"_y"+y1+"m"+month+"_1d_gridT.nc"
        fileU = diridat+nexp+"-S/"+"/1d/"+y1+"-concat"+"/"+prefix+"."+nexp+"_y"+y1+"m"+month+"_1d_gridU.nc"
        fileV = diridat+nexp+"-S/"+"/1d/"+y1+"-concat"+"/"+prefix+"."+nexp+"_y"+y1+"m"+month+"_1d_gridV.nc"
        
        T_ds = xr.open_dataset(fileT,chunks = chunk_size).squeeze()
        U_ds = xr.open_dataset(fileU,chunks = chunk_size).squeeze()
        V_ds = xr.open_dataset(fileV,chunks = chunk_size).squeeze()

        U_S = U_ds.vozocrtx
        V_S = V_ds.vomecrty
        S_S = T_ds.vosaline
        T_S = T_ds.votemper

    
        ######## ---------- load AI
        nexp = "AI"
        print(nexp)

        fileT = diridat+nexp+"-S/"+"/1d/"+y1+"-concat"+"/"+prefix+"."+nexp+"_y"+y1+"m"+month+"_1d_gridT.nc"
        fileU = diridat+nexp+"-S/"+"/1d/"+y1+"-concat"+"/"+prefix+"."+nexp+"_y"+y1+"m"+month+"_1d_gridU.nc"
        fileV = diridat+nexp+"-S/"+"/1d/"+y1+"-concat"+"/"+prefix+"."+nexp+"_y"+y1+"m"+month+"_1d_gridV.nc"
        
        T_ds = xr.open_dataset(fileT,chunks = chunk_size).squeeze()
        U_ds = xr.open_dataset(fileU,chunks = chunk_size).squeeze()
        V_ds = xr.open_dataset(fileV,chunks = chunk_size).squeeze()

        U_AI = U_ds.vozocrtx
        V_AI = V_ds.vomecrty
        S_AI = T_ds.vosaline
        T_AI = T_ds.votemper
        
        ####### --------------- loading scale factors

        e3t = T_ds.e3t
        e3u = U_ds.e3u
        e3v = V_ds.e3v

        ####### --------------- compute RIVERS's terms
        U_G = U_S - U_AI
        V_G = V_S - V_AI
        S_G = S_S - S_AI
        T_G = T_S - T_AI
        
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
            description="T and S from T_s - T_ai and S_s - S_ai")
        )

        gridU = xr.Dataset(
        data_vars=dict(
            vozocrtx=(["time_counter","depthu","y", "x"], U_G.data),
            e3u=(["time_counter","depthu","y", "x"], e3u.data)),
        coords=dict(
            time_counter=U_ds.time_counter.values,
            depthu=U_ds.depthu.values),
        attrs=dict(
            description="U_rivers from U_s - U_ai")
        )   
        
        gridV = xr.Dataset(
        data_vars=dict(
            vomecrty=(["time_counter","depthv","y", "x"], V_G.data),
            e3v=(["time_counter","depthv","y", "x"], e3v.data)),
        coords=dict(
            time_counter=V_ds.time_counter.values,
            depthv=V_ds.depthv.values),
        attrs=dict(
            description="V_rivers from V_s - V_ai")
        ) 
        
        print("saving")
        print("saving U_G")
        gridU.to_netcdf(diropath+"/"+prefix+".RIVERS_y"+y1+"m"+month+"_1d_gridU.nc", mode='w')
        print("saving V_G")
        gridV.to_netcdf(diropath+"/"+prefix+".RIVERS_y"+y1+"m"+month+"_1d_gridV.nc", mode='w')
        print("saving S_G")
        gridT.to_netcdf(diropath+"/"+prefix+".RIVERS_y"+y1+"m"+month+"_1d_gridT.nc", mode='w')