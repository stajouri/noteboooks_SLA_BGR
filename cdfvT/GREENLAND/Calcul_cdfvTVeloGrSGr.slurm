#!/bin/bash
#SBATCH --job-name=VGrSGr        # nom du job
#SBATCH --nodes=1                   # nombre de noeuds
#SBATCH --ntasks=36                 # nombre de tâche36 pour traiter 3 ans (3  * 12 en //
#SBATCH --ntasks-per-node=40
#SBATCH --threads-per-core=1
#SBATCH -A cli@cpu
#SBATCH --partition=prepost
#SBATCH --hint=nomultithread        # on réserve des coeurs physiques et non logiques
#SBATCH --time=08:00:00             # temps d'exécution maximum demande (HH:MM:SS)
#SBATCH --output=VGrSGr%j.out          # nom du fichier de sortie
#SBATCH --error=VGrSGr_err%j.out           # nom du fichier d'erreur (ici commun avec la sortie)
#SBATCH --exclusive

# nettoyage des modules
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
CASE=IMHOTEP.GREENLAND
## scratch
dirscratch='/gpfsscratch/rech/cli/uor98hu/Bilans_4_fig6/GREENLAND/'
dirwork='/gpfswork/rech/cli/uor98hu/'

CONFCASE=${CONFIG}-${CASE}
####################################################################

n=0
for K in {1980..2018} ; do 
for mm in 01 02 03 04 05 06 07 08 09 10 11 12; do

( ${dirwork}MYTOOLS/CDFTOOLS/bin/cdfvT -c ${dirscratch}/${K}-concat/${CONFCASE} -l y${K}m${mm}_1d -nc4 -vvl -o ${dirscratch}/cdfvT_outputs/VeloGrSGr/${CONFCASE}_y${K}m${mm}_1d_PROD.nc)  &
n=$(( n + 1 ))
if [ $n = 36 ] ; then
   wait
   n=0
fi

done
done
wait
