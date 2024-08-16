#!/bin/bash
#SBATCH --job-name=VAISRiv        # nom du job
#SBATCH --nodes=1                   # nombre de noeuds
#SBATCH --ntasks=36                 # nombre de tâche36 pour traiter 3 ans (3  * 12 en //
#SBATCH --ntasks-per-node=40
#SBATCH --threads-per-core=1
#SBATCH -A cli@cpu
#SBATCH --partition=cpu_p1
#SBATCH --hint=nomultithread        # on réserve des coeurs physiques et non logiques
#SBATCH --time=11:00:00             # temps d'exécution maximum demande (HH:MM:SS)
#SBATCH --output=VAISRiv%j.out          # nom du fichier de sortie
#SBATCH --error=VAISRiv%j.out           # nom du fichier d'erreur (ici commun avec la sortie)
#SBATCH --exclusive

# nettoyage des modules charges en interactif et herites par defaut
module purge

# chargement des modules
module load intel-compilers/19.0.4
module load intel-mpi
module load intel-mkl
module load netcdf/4.7.2-mpi
module load netcdf-fortran/4.5.2-mpi
module load nco
module load cdo
module load gcc/9.1.0
module load ncl
module load hdf5/1.10.5-mpi
module load ncview

# echo des commandes lancées
set -x

#
# use cdfvT
#

####################################################################
CONFIG=eORCA025.L75
CASE=IMHOTEP.RIVERS
## scratch
dirscratch='/gpfsscratch/rech/cli/uor98hu/BILANS/1dDecomposition/RIVERS/'
dirwork='/gpfswork/rech/cli/uor98hu/'
dirstore='/gpfsstore/rech/cli/rcli002/eORCA025.L75/eORCA025.L75-IMHOTEP.AI-S/1d/'

CONFCASE=${CONFIG}-${CASE}
####################################################################

n=0
for K in {2004..2018} ; do

for mm in 01 02 03 04 05 06 07 08 09 10 11 12; do

( ln -s ${dirscratch}/${K}-concat/eORCA025.L75-IMHOTEP.RIVERS_y${K}m${mm}_1d_gridT.nc ${dirscratch}/cdfvT/VeloAISRiv/eORCA025.L75-IMHOTEP.RIVERS_y${K}m${mm}_1d_gridT.nc

ln -s $dirstore/${K}-concat/eORCA025.L75-IMHOTEP.AI_y${K}m${mm}_1d_gridU.nc ${dirscratch}/cdfvT/VeloAISRiv/eORCA025.L75-IMHOTEP.RIVERS_y${K}m${mm}_1d_gridU.nc

ln -s $dirstore/${K}-concat/eORCA025.L75-IMHOTEP.AI_y${K}m${mm}_1d_gridV.nc ${dirscratch}/cdfvT/VeloAISRiv/eORCA025.L75-IMHOTEP.RIVERS_y${K}m${mm}_1d_gridV.nc

${dirwork}CDFTOOLS/bin/cdfvT -c ${dirscratch}/cdfvT/VeloAISRiv/${CONFCASE} -l y${K}m${mm}_1d -nc4 -vvl -o ${dirscratch}/cdfvT/VeloAISRiv/${CONFCASE}_y${K}m${mm}_1d_PROD.nc

rm -f ${dirscratch}/cdfvT/VeloAISRiv/eORCA025.L75-IMHOTEP.RIVERS_y${K}m${mm}_1d_gridU.nc
rm -f ${dirscratch}/cdfvT/VeloAISRiv/eORCA025.L75-IMHOTEP.RIVERS_y${K}m${mm}_1d_gridV.nc
rm -f ${dirscratch}/cdfvT/VeloAISRiv/eORCA025.L75-IMHOTEP.RIVERS_y${K}m${mm}_1d_gridT.nc ) &
n=$(( n + 1 ))
if [ $n = 36 ] ; then
   wait
   n=0
fi

done
done
wait


