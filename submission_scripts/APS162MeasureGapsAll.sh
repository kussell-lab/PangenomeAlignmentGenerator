#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --time=0:30:00
#SBATCH --mem=4GB
#SBATCH --job-name=APS162measuregaps
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=aps376@nyu.edu
#SBATCH --output=APS162gaps_slurm%j.out


##INPUTS
jobdir=/scratch/aps376/recombo/APS162MeasureGaps
ARCHIVE=/scratch/aps376/recombo/APS160_SP_Archive/corethreshold90
MSA=${ARCHIVE}/MSA_CORE

echo "Loading modules."
module load go/1.15.7

##Making the AssemblyAlignmentGenerator and ReferenceAlignmentGenerator in path
echo "Making everything in path."
#mcorr
export PATH=$PATH:$HOME/go/bin:$HOME/.local/bin

##set perl language variable; this will give you fewer warnings
export LC_ALL=C


##MSA stands for multi sequence alignment in the below
  #the '$1' command tells it to grab the argument of pipe_dream

echo "let's rock"

MeasureGaps ${MSA} --threads=20

