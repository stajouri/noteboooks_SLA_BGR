# use cdftools polymask to create a mask given the corners of the polygon

#-------------------------------

exp=$1
MEMB=${exp}

/gpfswork/rech/cli/uor98hu/CDFTOOLS/bin/cdfpolymask -p ${MEMB}.txt -ref /gpfsstore/rech/cli/rcli002/eORCA025.L75/eORCA025.L75-IMHOTEP.GAI-S/1y/1980/eORCA025.L75-IMHOTEP.GAI_y1980.1y_gridT.nc -o /gpfswork/rech/cli/uor98hu/MYDATA/rivers_mask/${MEMB}.nc
