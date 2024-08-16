#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=40
#SBATCH --ntasks-per-node=40
#SBATCH --threads-per-core=1
#SBATCH -A cli@cpu
#SBATCH --hint=nomultithread
#SBATCH -J STERIC
#SBATCH -e zalp.e%j
#SBATCH -o zalp.o%j
#SBATCH --time=1:00:00
#SBATCH --exclusive
#
#purpose: use the cdftool cdfsteric_rho1035 
##################

CONFIG=eORCA025.L75
DIR=/gpfsstore/rech/cli/rcli002
dirwork='/gpfswork/rech/cli/uor98hu'
dirscratch='/gpfsscratch/rech/cli/uor98hu'

###################################
# :::: for each member
exp=$1
MEMB=${exp}
echo $MEMB
DTADIR=${DIR}/${CONFIG}/${CONFIG}-IMHOTEP.${exp}-S
freq=1y

mkdir -p ${dirscratch}/steric/${MEMB}-S/

rm -f mask.nc mesh_zgr.nc

ln -s ${DIR}/${CONFIG}/${CONFIG}-I/${CONFIG}_mesh_mask_closed_seas_greenland.nc mask.nc
ln -s ${DIR}/${CONFIG}/${CONFIG}-I/${CONFIG}_mesh_zgr.nc mesh_zgr.nc

# loop on years
n=0
for iyear in {1998..2011}
do
${dirwork}/MYTOOLS/CDFTOOLS/bin/cdfsteric_rho1035 -f ${DTADIR}/$freq/${iyear}/${CONFIG}-IMHOTEP.${exp}_y${iyear}.1y_gridT.nc \
                                                  -vvl -nc4 -teos10 \
						  -o ${dirscratch}/steric/${MEMB}-S/${MEMB}_steric${iyear}.nc   &
   n=$(( n + 1 ))
   if [ $n = 14 ] ; then  # 14 years in pallalel
      n=0
      wait
   fi
done
wait
exit 0

