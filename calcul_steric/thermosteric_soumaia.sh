#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=40
#SBATCH --ntasks-per-node=40
#SBATCH --threads-per-core=1
#SBATCH -A cli@cpu
#SBATCH --hint=nomultithread
#SBATCH -J THERMOSTERIC
#SBATCH -e zalp.e%j
#SBATCH -o zalp.o%j
#SBATCH --time=2:00:00
#SBATCH --exclusive

# Compute annually thermosteric height from T/S using the cdftool cdfsteric_soumaia


#exp=$1
#iyear=$2
for exp in GAI; do
#imonth=$3

####################################################################
## scratch
dirscratch='/gpfsscratch/rech/cli/uor98hu'
dirwork='/gpfswork/rech/cli/uor98hu'
dirstore='/gpfsstore/rech/cli/rcli002/eORCA025.L75/eORCA025.L75-IMHOTEP.'${exp}'-S'

####################################################################
# loop on the simulations

###### A RAJOUTER QUAND LE REP N EXISTE PAS
mkdir -p ${dirscratch}/steric/decomposition/${exp}/
rm -f mask.nc mesh_zgr.nc
ln -s /gpfsstore/rech/cli/rcli002/eORCA025.L75/eORCA025.L75-I/eORCA025.L75_mesh_mask_closed_seas_greenland.nc mask.nc
ln -s /gpfsstore/rech/cli/rcli002/eORCA025.L75/eORCA025.L75-I/eORCA025.L75_mesh_zgr.nc mesh_zgr.nc

#:::: FOR EACH MEMBER

for K in {1998..2011}
do
cp ${dirstore}/1y/${K}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridT.nc ${dirscratch}/ 

ncks -A -v vosaline ${dirscratch}/steric/decomposition/${exp}_moy1980_2018.nc ${dirscratch}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridT.nc

${dirwork}/MYTOOLS/CDFTOOLS/bin/cdfsteric_soumaia -f ${dirscratch}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridT.nc -vvl -teos10 -nc4 -o ${dirscratch}/steric/decomposition/${exp}/${exp}_y${K}.1y_thermosteric_rho1035_0_cumsum.nc  
#${dirwork}/MYTOOLS/CDFTOOLS/bin/cdfsteric_soumaia -f ${dirscratch}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridT.nc -limit 1 31 -vvl -teos10 -nc4 -o ${dirscratch}/steric/decomposition/${exp}/${exp}_y${K}.1y_thermosteric_rho1035_0_220m.nc  

#${dirwork}/MYTOOLS/CDFTOOLS/bin/cdfsteric_soumaia -f ${dirscratch}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridT.nc -limit 1 40 -vvl -teos10 -nc4 -o ${dirscratch}/steric/decomposition/${exp}/${exp}_y${K}.1y_thermosteric_rho1035_0_565m.nc  

#${dirwork}/MYTOOLS/CDFTOOLS/bin/cdfsteric_soumaia -f ${dirscratch}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridT.nc -limit 1 35 -vvl -teos10 -nc4 -o ${dirscratch}/steric/decomposition/${exp}/${exp}_y${K}.1y_thermosteric_rho1035_0_300m.nc  

#${dirwork}/MYTOOLS/CDFTOOLS/bin/cdfsteric_soumaia -f ${dirscratch}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridT.nc -limit 1 43 -vvl -teos10 -nc4 -o ${dirscratch}/steric/decomposition/${exp}/${exp}_y${K}.1y_thermosteric_rho1035_0_700m.nc  

#${dirwork}/MYTOOLS/CDFTOOLS/bin/cdfsteric_soumaia -f ${dirscratch}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridT.nc -limit 1 54 -vvl -teos10 -nc4 -o ${dirscratch}/steric/decomposition/${exp}/${exp}_y${K}.1y_thermosteric_rho1035_0_2000m.nc  

#${dirwork}/MYTOOLS/CDFTOOLS/bin/cdfsteric_soumaia -f ${dirscratch}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridT.nc -limit 1 75 -vvl -teos10 -nc4 -o ${dirscratch}/steric/decomposition/${exp}/${exp}_y${K}.1y_thermosteric_rho1035_0_bottom.nc

rm -f ${dirscratch}/eORCA025.L75-IMHOTEP.${exp}_y*.1y_gridT.nc

done
wait
done
exit 0
