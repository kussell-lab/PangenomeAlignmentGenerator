#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --time=1:00:00
#SBATCH --mem=4GB
#SBATCH --job-name=APS162filtersplit
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=aps376@nyu.edu
#SBATCH --output=APS162filtersplit_singleref90_slurm%j.out


##INPUTS
jobdir=/scratch/aps376/recombo/APS162filtersplit
#list=/scratch/aps376/recombo/APS158_fetchSRA/APS156_full_SRA_list
WRKD=/scratch/aps376/recombo/APS158_spneumoniae
ARCHIVE=/scratch/aps376/recombo/APS156_SP_Archive
MSA=${ARCHIVE}/SP_MASTER_OUT/MSA_SP_MASTER
list=${jobdir}/APS156_finalpile
cutoff=90
OUTDIR=/scratch/aps376/recombo/APS162_SP_Archive/APS156corethreshold${cutoff}

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

module load singularity/3.6.4

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
SplitGenome ${MSA} ${list} ${cutoff} ${OUTDIR} --threads=16 --num-cpu=16

