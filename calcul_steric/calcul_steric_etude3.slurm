#!/bin/bash
#SBATCH --job-name=steric        # nom du job
#SBATCH --nodes=1                   # nombre de noeuds
#SBATCH --ntasks=36                 # nombre de tâche36 pour traiter 3 ans (3  * 12 en //
#SBATCH --ntasks-per-node=40
#SBATCH --threads-per-core=1
#SBATCH -A cli@cpu
#SBATCH --partition=prepost
#SBATCH --hint=nomultithread        # on réserve des coeurs physiques et non logiques
#SBATCH --time=03:00:00             # temps d'exécution maximum demande (HH:MM:SS)
#SBATCH --output=steric%j.out          # nom du fichier de sortie
#SBATCH --error=steric%j.out           # nom du fichier d'erreur (ici commun avec la sortie)
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

# Compute annually steric height from T/S using the cdftool cdfsteric
for exp in EAI; do

for mb in 001 ; do
####################################################################
## scratch
dirscratch='/gpfsscratch/rech/cli/uor98hu/ETUDE3/steric/'${exp}'/'
dirwork='/gpfswork/rech/cli/uor98hu'
dirstore='/gpfsstore/rech/cli/rcli002/eORCA025.L75/eORCA025.L75-IMHOTEP.'${exp}'.'${mb}'-S/1m'

####################################################################
# loop on the simulations

#rm -f mask.nc mesh_zgr.nc
#ln -s /gpfsstore/rech/cli/rcli002/eORCA025.L75/eORCA025.L75-I/eORCA025.L75_mesh_mask_closed_seas_greenland.nc mask.nc
#ln -s /gpfsstore/rech/cli/rcli002/eORCA025.L75/eORCA025.L75-I/eORCA025.L75_mesh_zgr.nc mesh_zgr.nc


for K in {1980..2018}; do

mkdir -p ${dirscratch}${K}/

for mm in 01 02 03 04 05 06 07 08 09 10 11 12; do

cp ${dirstore}/${K}/eORCA025.L75-IMHOTEP.${exp}.${mb}_y${K}m${mm}.1m_gridT.nc ${dirscratch}${K} 
cp ${dirstore}/${K}/eORCA025.L75-IMHOTEP.${exp}.${mb}_y${K}m${mm}.1m_gridTsurf.nc ${dirscratch}${K}

${dirwork}/CDFTOOLS/bin/cdfsteric -t ${dirscratch}${K}/eORCA025.L75-IMHOTEP.${exp}.${mb}_y${K}m${mm}.1m_gridT.nc -ssh ${dirscratch}${K}/eORCA025.L75-IMHOTEP.${exp}.${mb}_y${K}m${mm}.1m_gridTsurf.nc -vvl -teos10 -nc4 -o ${dirscratch}${K}/eORCA025.L75-IMHOTEP.${exp}.${mb}_y${K}m${mm}.1m_steric_cumulated.nc  


rm -f ${dirscratch}${K}/eORCA025.L75-IMHOTEP.${exp}.${mb}_y*gridT.nc
rm -f ${dirscratch}${K}/eORCA025.L75-IMHOTEP.${exp}.${mb}_y*gridTsurf.nc

done
wait
done
wait
done
exit 0
