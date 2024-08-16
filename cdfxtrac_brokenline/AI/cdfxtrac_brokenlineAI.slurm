#!/bin/bash
#SBATCH --job-name=xtracAI         # nom du job
#SBATCH --nodes=1                   # nombre de noeuds
#SBATCH --ntasks=36                 # nombre de tâche36 pour traiter 3 ans (3  * 12 en //
#SBATCH --ntasks-per-node=40
#SBATCH --threads-per-core=1
#SBATCH -A cli@cpu
#SBATCH --partition=cpu_p1
#SBATCH --qos=qos_cpu-dev
#SBATCH --hint=nomultithread        # on réserve des coeurs physiques et non logiques
#SBATCH --time=00:30:00             # temps d'exécution maximum demande (HH:MM:SS)
#SBATCH --output=xtrac2%j.out          # nom du fichier de sortie
#SBATCH --error=xtrac2_err%j.out           # nom du fichier d'erreur (ici commun avec la sortie)
#SBATCH --exclusive

#
# Compute transport along each edge of the box BG
#
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

# Extract section from NEMO 

exp=AI

####################################################################
dirscratch='/gpfsscratch/rech/cli/uor98hu/xtrac_brokenline/'${exp}'/'
dirwork='/gpfswork/rech/cli/uor98hu/'
dirstore='/gpfsstore/rech/cli/rcli002/eORCA025.L75/eORCA025.L75-IMHOTEP.'${exp}'-S'
dirI='/gpfsstore/rech/cli/rcli002/eORCA025.L75/eORCA025.L75-I/'
####################################################################

#mkdir -p ${dirscratch}/Sections/

# rm -f mesh_zgr.nc mesh_hgr.nc

ln -s ${dirI}eORCA025.L75_mesh_zgr.nc mesh_zgr.nc 
ln -s ${dirI}eORCA025.L75_mesh_hgr.nc mesh_hgr.nc

##### la section doit etre dans le meme repertoire (section_mane.txt)
#K=1980
for K in {1980..2018} ; do

	${dirwork}/CDFTOOLS/bin/cdf_xtrac_brokenline -t ${dirstore}/1y/${K}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridT.nc -u ${dirstore}/1y/${K}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridU.nc -v ${dirstore}/1y/${K}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridV.nc -l section_GrEst.txt -vecrot -vt -mxl ${dirstore}/1y/${K}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridTsurf.nc -mld -b ${dirI}eORCA025.L75_Bathymetry.nc
	#-vvl ${dirstore}/1y/${K}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridW.nc
	# --ssh-file ${dirstore}/1y/${K}/eORCA025.L75-IMHOTEP.${exp}_y${K}.1y_gridTsurf.nc -ssh
	
	mv section_GrEst.nc ${dirscratch}${exp}_1y_${K}_section_GrEst.nc
	rm -f  section_GrEst_section.dat

done
