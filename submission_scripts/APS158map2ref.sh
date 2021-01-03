#!/bin/bash
##first write for one replicate
##then write for multiple

##make job directory
DATE=1227_v1
JOBDIR=$SCRATCH/recombo/APS158map2ref
WRKDIR=$SCRATCH/recombo/APS158_spneumoniae
REF=/scratch/aps376/recombo/APS158_SP_Archive/1223_roary/pan_genome_reference.fa
LISTS=$JOBDIR/piles_tbc
SUBMITDIR=${DATE}_submissions
SLURMDIR=${DATE}_slurm

mkdir -p $SUBMITDIR
mkdir -p $SLURMDIR
mkdir -p $WRKDIR


##will change to 0 to 9 once confirmed that it werks
for line in {0..199}
#for line in 0
do
  echo "submitting list ${line}"
  jobfile=$SUBMITDIR/APS156map2ref_${line}.sh

  echo "#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --time=24:00:00
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

###things we're waiting to be installed on Greene
#module load prokka/1.12
#module load muscle/intel/3.8.31
#module load sra-tools/2.10.5
#module load smalt/intel/0.7.6

module load singularity/3.6.4

##aliases for singularity
source \`which env_parallel.bash\`
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

echo \"let's rock\"
cd ${WRKDIR}
bash ${JOBDIR}/ConvertMapwSingularity.sh ${LISTS}/piles_TBC_${line} $WRKDIR $REF" > $jobfile
  sbatch "$jobfile"
  echo "I'm taking a 2 second break"
  sleep 2 #pause the script for a second so we don't break the cluster with our magic
done



