#!/bin/bash
##first write for one replicate
##then write for multiple

##make job directory
DATE=1226
SLURMDIR=${DATE}_slurm
SUBMITDIR=${DATE}_submissions
JOBDIR=$SCRATCH/recombo/APS158_fetchSRA
LISTS=${JOBDIR}/SRA_tbc1
WRKDIR=$SCRATCH/recombo/APS158_spneumoniae


mkdir -p ${WRKDIR}
mkdir -p ${SLURMDIR}
mkdir -p ${SUBMITDIR}

##will change from 9 to 500 once it is confirmed to work
for line in {0..19}
#for line in 0
do
  echo "submitting list ${line}"
  jobfile=${SUBMITDIR}/APS158prefetch_${line}.sh

  echo "#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=12:00:00
#SBATCH --mem=2GB
#SBATCH --job-name=prefetch_${line}
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=aps376@nyu.edu
#SBATCH --output=${SLURMDIR}/slurm%j_prefetch_${line}.out

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
alias roary='singularity exec /home/aps376/roary_latest.sif roary'
alias prefetch='singularity exec /home/aps376/sra-tools.sif prefetch'
alias smalt='singularity exec /home/aps376/smalt.sif smalt'

##Making the AssemblyAlignmentGenerator and ReferenceAlignmentGenerator in path
echo \"Making everything in path.\"
#mcorr
export PATH=\$PATH:\$HOME/go/bin:\$HOME/.local/bin

#ReferenceAlignmentGenerator
export PATH=\$PATH:~/opt/AssemblyAlignmentGenerator/
export PATH=\$PATH:~/opt/ReferenceAlignmentGenerator

##set perl language variable; this will give you fewer warnings
export LC_ALL=C

cd $WRKDIR

echo \"let's rock\"

parallel singularity exec /home/aps376/sra-tools.sif prefetch :::: ${LISTS}/SRA_TBC_${line}" >$jobfile
  sbatch "$jobfile"
  echo "I'm taking a 2 second break"
  sleep 2 #pause the script for a second so we don't break the cluster with our magic
done
