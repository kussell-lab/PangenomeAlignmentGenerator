#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --time=1:00:00
#SBATCH --mem=4GB
#SBATCH --job-name=APS162measuregaps
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=aps376@nyu.edu
#SBATCH --output=APS162gaps_single_vs_pangenome_MSA_slurm%j.out


##INPUTS
jobdir=/scratch/aps376/recombo/APS162MeasureGaps
ARCHIVE=/scratch/aps376/recombo/APS160_SP_Archive
projdir=/scratch/aps376/recombo

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

MeasureGaps ${projdir}/APS156_SP_Archive/SP_MASTER_OUT/MSA_SP_MASTER --threads=20
MeasureGaps ${projdir}/APS158_SP_Archive/SP_MASTER_OUT/MSA_SP_PANGENOME_MASTER --threads=20