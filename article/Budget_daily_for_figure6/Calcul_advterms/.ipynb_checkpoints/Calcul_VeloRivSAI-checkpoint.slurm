#!/bin/bash
#SBATCH --job-name=VRivSAI      # nom du job
#SBATCH --nodes=1                   # nombre de noeuds
#SBATCH --ntasks=1                  # nombre de tâche (un unique processus ici)
#SBATCH --cpus-per-task=20          # nombre de threads OpenMP
#SBATCH -A cli@cpu
#SBATCH --partition=cpu_p1

#SBATCH --hint=nomultithread        # on réserve des coeurs physiques et non logiques
#SBATCH --time=04:00:00             # temps d'exécution maximum demande (HH:MM:SS)
#SBATCH --output=VRivSAI%j.out          # nom du fichier de sortie
#SBATCH --error=VRivSAI_err%j.out           # nom du fichier d'erreur (ici commun avec la sortie)

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
python ./Calcul_VeloRivSAI.py
