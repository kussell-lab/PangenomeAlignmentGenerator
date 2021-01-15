#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --time=1:00:00
#SBATCH --mem=4GB
#SBATCH --job-name=APS160split
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=aps376@nyu.edu
#SBATCH --output=APS160split90_slurm%j.out


##INPUTS
jobdir=/scratch/aps376/recombo/APS160clusterSplit
ARCHIVE=/scratch/aps376/recombo/APS160_SP_Archive
MSA=${ARCHIVE}/corethreshold90/MSA_CORE
cluster_dict=${ARCHIVE}/cluster_list
OUTDIR=/scratch/aps376/recombo/APS160_SP_Archive/corethreshold90
FLEX_MSA=${ARCHIVE}/corethreshold90/MSA_FLEX

mkdir -p ${OUTDIR}

echo "Loading modules."
module load go/1.15.2
module load python/intel/3.8.6
module load parallel/20201022
module load samtools/intel/1.11

###things we're waiting to be installed on Greene
#module load prokka/1.12
#module load muscle/intel/3.8.31
#module load sra-tools/2.10.5
#module load smalt/intel/0.7.6

module load singularity/3.6.4

##aliases for singularity
source `which env_parallel.bash`
alias roary='singularity exec /home/aps376/roary_latest.sif roary'
alias prefetch='singularity exec /home/aps376/sra-tools.sif prefetch'
alias smalt='singularity exec /home/aps376/smalt.sif smalt'

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
clusterSplit ${MSA} ${OUTDIR} ${cluster_dict} --FLEX_MSA=${FLEX_MSA} --num-cpu=4
