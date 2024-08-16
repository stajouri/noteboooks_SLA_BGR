#!/bin/bash
#SBATCH --job-name=gridRivers            # nom du job
#SBATCH --nodes=1                   # nombre de noeuds
#SBATCH --ntasks=36                 # nombre de tâche36 pour traiter 3 ans (3  * 12 en //
#SBATCH --ntasks-per-node=40
#SBATCH --threads-per-core=1
#SBATCH -A cli@cpu

#SBATCH --partition=cpu_p1
#SBATCH --hint=nomultithread        # on réserve des coeurs physiques et non logiques
#SBATCH --time=08:30:00             # temps d'exécution maximum demande (HH:MM:SS)
#SBATCH --output=gridR%j.out          # nom du fichier de sortie
#SBATCH --error=gridR%j.out           # nom du fichier d'erreur (ici commun avec la sortie)
#SBATCH --exclusive

# nettoyage des modules charges en interactif et herites par defaut
module purge
 
# chargement des modules
module load climate_science/py3
 
# echo des commandes lancées
set -x
 
# nombre de threads OpenMP
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK 
 
# Binding
export OMP_PLACES=cores

# exécution du code
python ./Save_gridU_gridV_gridT_Rivers-Copy2.py
