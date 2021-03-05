#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --time=1:00:00
#SBATCH --mem=4GB
#SBATCH --job-name=APS162reduce
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=aps376@nyu.edu
#SBATCH --output=APS162reducecore_slurm%j.out


##INPUTS
jobdir=/scratch/aps376/recombo/APS162reducedcore
cutoff=90
OUTDIR=/scratch/aps376/recombo/APS160_SP_Archive/corethreshold${cutoff}

mkdir -p ${OUTDIR}

echo "Loading modules."
module load go/1.15.7
module load python/intel/3.8.6
module load parallel/20201022
module load samtools/intel/1.11

###things we're waiting to be installed on Greene
#module load prokka/1.12
#module load muscle/intel/3.8.31
#module load sra-tools/2.10.5
#module load smalt/intel/0.7.6

##Making the AssemblyAlignmentGenerator and ReferenceAlignmentGenerator in path
echo "Making everything in path."
#mcorr
export PATH=$PATH:$HOME/go/bin:$HOME/.local/bin

#ReferenceAlignmentGenerator
export PATH=$PATH:~/opt/AssemblyAlignmentGenerator/
export PATH=$PATH:~/opt/ReferenceAlignmentGenerator

##set perl language variable; this will give you fewer warnings
export LC_ALL=C


##MSA stands for multi sequence alignment in the below
  #the '$1' command tells it to grab the argument of pipe_dream

echo "let's rock"
cd ${OUTDIR}
ReduceCoreGenome MSA_CORE MSA_FLEX ${OUTDIR}

