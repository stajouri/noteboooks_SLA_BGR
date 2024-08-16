#!/bin/bash
#SBATCH --job-name=curl        # nom du job
#SBATCH --nodes=1                   # nombre de noeuds
#SBATCH --ntasks=36                 # nombre de tâche36 pour traiter 3 ans (3  * 12 en //
#SBATCH --ntasks-per-node=40
#SBATCH --threads-per-core=1
#SBATCH -A cli@cpu
#SBATCH --partition=cpu_p1
#SBATCH --hint=nomultithread        # on réserve des coeurs physiques et non logiques
#SBATCH --time=00:05:00             # temps d'exécution maximum demande (HH:MM:SS)
#SBATCH --output=curl%j.out          # nom du fichier de sortie
#SBATCH --error=curl%j.out           # nom du fichier d'erreur (ici commun avec la sortie)
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
# use cdfcurl
#

####################################################################
CONFIG=eORCA025.L75
CASE=IMHOTEP.AI
## scratch
dirscratch='/gpfsscratch/rech/cli/uor98hu/Calcul_curl'
dirwork='/gpfswork/rech/cli/uor98hu/'
dirstore='/gpfsstore/rech/cli/rcli002/eORCA025.L75/eORCA025.L75-IMHOTEP.AI-S/'
CONFCASE=${CONFIG}-${CASE}
####################################################################

#ln -s /gpfsstore/rech/cli/rcli002/eORCA025.L75/eORCA025.L75-I/eORCA025.L75_mesh_hgr.nc mesh_hgr.nc
#ln -s /gpfsstore/rech/cli/rcli002/eORCA025.L75/eORCA025.L75-I/eORCA025.L75_mesh_zgr.nc mesh_zgr.nc

n=0
for K in {1980..2018} ; do 
#for mm in 01 02 03 04 05 06 07 08 09 10 11 12; do

( ${dirwork}CDFTOOLS/bin/cdfcurl -u ${dirstore}/1y/${K}/${CONFCASE}_y${K}.1y_gridU.nc sozotaux -v ${dirstore}/1y/${K}/${CONFCASE}_y${K}.1y_gridV.nc sometauy -surf -nc4 -8 -o ${dirscratch}/${CONFCASE}_y${K}_1y_curl.nc)  &
n=$(( n + 1 ))
if [ $n = 36 ] ; then
   wait
   n=0
fi

done
#done
wait
