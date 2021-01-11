#!/bin/bash
##first write for one replicate
##then write for multiple

##make job directory
DATE=0111
JOBDIR=$SCRATCH/recombo/APS159map2ref
WRKDIR=$SCRATCH/recombo/APS159_ngonorrhoeae
REF=/scratch/aps376/recombo/APS159_NG_Archive/roary_1610395135/pan_genome_reference.fa
LISTS=$JOBDIR/piles_tbc
SUBMITDIR=${DATE}_submissions
SLURMDIR=${DATE}_slurm

mkdir -p $SUBMITDIR
mkdir -p $SLURMDIR
mkdir -p $WRKDIR


##will change to 0 to 9 once confirmed that it werks
#for line in {1..99}
for line in 0
do
  echo "submitting list ${line}"
  jobfile=$SUBMITDIR/APS156map2ref_${line}.sh

  echo "#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --time=16:00:00
#SBATCH --mem=2GB
#SBATCH --job-name=map2ref_${line}
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=aps376@nyu.edu
#SBATCH --output=${SLURMDIR}/slurm%j_map2ref_${line}.out

echo \"Loading modules.\"
module load go/1.15.2
module load python/intel/3.8.6
module load parallel/20201022
module load samtools/intel/1.11
module load muscle/intel/3.8.1551
module load sra-tools/2.10.9
module load smalt/intel/0.7.6

module load singularity/3.6.4

##aliases for singularity
source \`which env_parallel.bash\`
alias roary='singularity exec /scratch/work/public/singularity/roary-3.13.0.sif roary'
alias prokka='singularity exec /scratch/work/public/singularity/prokka-1.14.5.sif prokka'
##Making the AssemblyAlignmentGenerator and ReferenceAlignmentGenerator in path
echo \"Making everything in path.\"
#mcorr
export PATH=\$PATH:\$HOME/go/bin:\$HOME/.local/bin

#ReferenceAlignmentGenerator
export PATH=\$PATH:~/opt/AssemblyAlignmentGenerator/
export PATH=\$PATH:~/opt/ReferenceAlignmentGenerator

##set perl language variable; this will give you fewer warnings
export LC_ALL=C

echo \"let's rock\"
cd ${WRKDIR}
ConvertMap ${LISTS}/piles_TBC_${line} $WRKDIR $REF" > $jobfile
  sbatch "$jobfile"
  echo "I'm taking a 2 second break"
  sleep 2 #pause the script for a second so we don't break the cluster with our magic
done



