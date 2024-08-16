#!/bin/bash
#SBATCH --job-name=halosteric        # nom du job
#SBATCH --nodes=1                   # nombre de noeuds
#SBATCH --ntasks=36                 # nombre de tâche36 pour traiter 3 ans (3  * 12 en //
#SBATCH --ntasks-per-node=40
#SBATCH --threads-per-core=1
#SBATCH -A cli@cpu
#SBATCH --partition=cpu_p1
#SBATCH --hint=nomultithread        # on réserve des coeurs physiques et non logiques
#SBATCH --time=01:10:00             # temps d'exécution maximum demande (HH:MM:SS)
#SBATCH --output=halo%j.out          # nom du fichier de sortie
#SBATCH --error=halo%j.out           # nom du fichier d'erreur (ici commun avec la sortie)
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
for exp in GAI AI S; do

####################################################################
## scratch
dirscratch='/gpfsscratch/rech/cli/uor98hu/SL_components'
dirwork='/gpfswork/rech/cli/uor98hu'
dirstore='/gpfsstore/rech/cli/rcli002/eORCA025.L75/eORCA025.L75-IMHOTEP.'${exp}'-S'

####################################################################
# loop on the simulations

#rm -f mask.nc mesh_zgr.nc
#ln -s /gpfsstore/rech/cli/rcli002/eORCA025.L75/eORCA025.L75-I/eORCA025.L75_mesh_mask_closed_seas_greenland.nc mask.nc
#ln -s /gpfsstore/rech/cli/rcli002/eORCA025.L75/eORCA025.L75-I/eORCA025.L75_mesh_zgr.nc mesh_zgr.nc

#:::: FOR EACH MEMBER

for K in {1980..2018}; do

cp ${dirstore}/1y/${K}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridT.nc ${dirscratch}/${exp}/ 
cp ${dirstore}/1y/${K}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridTsurf.nc ${dirscratch}/${exp}/


#ncks -A -v sossheig ${dirstore}/1y/${K}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridTsurf.nc  ${dirscratch}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridT.nc

${dirwork}/CDFTOOLS/bin/cdfsteric -t ${dirscratch}/eORCA025.L75-IMHOTEP.${exp}_yALL.1y_gridTmoy.nc -s ${dirscratch}/${exp}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridT.nc -ssh ${dirscratch}/${exp}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridTsurf.nc -vvl -HALO -teos10 -nc4 -o ${dirscratch}/${exp}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_halosteric_cumulated.nc  


rm -f ${dirscratch}/${exp}/eORCA025.L75-IMHOTEP.${exp}_y*.1y_gridT.nc
rm -f ${dirscratch}/${exp}/eORCA025.L75-IMHOTEP.${exp}_y*.1y_gridTsurf.nc

done
wait
done
exit 0
