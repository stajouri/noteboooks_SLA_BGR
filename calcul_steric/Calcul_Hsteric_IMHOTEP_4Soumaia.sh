####################
#!/bin/bash

#
# Compute monthly steric height from T/S
#
#

exp=$1
#iyear=$2
#imonth=$3

####################################################################
## scratch
dirscratch='/gpfsscratch/rech/bcn/una12nf/IMHOTEP/'
dirwork='/gpfswork/rech/bcn/una12nf/'
dirstore='/gpfsstore/rech/bcn/rcli002/eORCA025.L75/eORCA025.L75-IMHOTEP.'${exp}'-S/'

####################################################################
    #:::: FOR EACH MEMBER


for K in {1993..2018} ; do
#for K in {2010..2018} ; do



###### A RAJOUTER QUAND LE REP N EXISTE PAS
#mkdir -p ${dirscratch}/HTHERMO_OCCITENS/${MEMB}/${iyear}
#mkdir -p ${dirscratch}/TMP_${MEMB}${iyear}${MONTH}

rm -f ${dirscratch}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridT.nc

cp ${dirstore}/1y/${K}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridT.nc ${dirscratch} 

ncks -A -v sossheig ${dirstore}/1y/${K}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridTsurf.nc  ${dirscratch}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridT.nc



# ${dirwork}/CDFTOOLS_TEOS10/bin/cdfsteric_rho1035 -f ${dirscratch}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridT.nc -limit 1 19  -vvl -teos10 -nc4 -o ${dirscratch}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_steric_0_50m.nc
# ${dirwork}/CDFTOOLS_TEOS10/bin/cdfsteric_rho1035 -f ${dirscratch}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridT.nc -limit 1 25  -vvl -teos10 -nc4 -o ${dirscratch}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_steric_0_100m.nc
 ${dirwork}/CDFTOOLS_TEOS10/bin/cdfsteric_rho1035 -f ${dirscratch}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridT.nc -limit 1 31  -vvl -teos10 -nc4 -o ${dirscratch}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_steric_0_200m.nc
 ${dirwork}/CDFTOOLS_TEOS10/bin/cdfsteric_rho1035 -f ${dirscratch}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridT.nc -limit 1 35  -vvl -teos10 -nc4 -o ${dirscratch}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_steric_0_300m.nc


rm -f ${dirscratch}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridT.nc


done
