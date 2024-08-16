Steps for computing the salinity budget terms: 


term Gtotal:
from 00_save_Gtotal directory:
1) save_1d_vosaline_BGR : save in zarr format the daily salinity in 4D of the BGR box only (in the scratch then moved to the STORE). Done for GAI, AI, and S.
2) save_Gtotal_BGR : compute Gtotal: 1/ deltaS (as the difference between 2 consecutive months). 2/ volume weighted average in the BGR. 3/ time-cumulative sum and save data in the work (data4figure directory). Warning: the last time index is not correct (for computational reasons)

term Gadv:
Computed from the notebook 00_Save_global_Budget_terms.ipynb.
Compute for the whole water column; is the adv_h variable (from STORE directory). Then Use 01_save_Gadvection.ipynb.

term Gforcing:
1) use data stored in STORE computed from the notebook 00_Save_global_Budget_terms.ipynb.
2) compute using 02_save_Gforcing.ipynb
