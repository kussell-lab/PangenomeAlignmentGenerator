#!/usr/bin/env python
import os
import time
from itertools import combinations
import numpy as np


def mkdir_p(dir):
    'make a directory if doesnt exist'
    if not os.path.exists(dir):
        os.mkdir(dir)

#define directories
date = "0325reducedcore"
jobdir = "/scratch/aps376/recombo/APS178reducedcore"
archive = "/scratch/aps376/recombo/APS169_SP_Archive/corethreshold95"
newarchive = "/scratch/aps376/recombo/APS178_SP_Archive/APS169reduced_threshold95"
submitdir = "/scratch/aps376/recombo/APS178reducedcore/%s_submissions" % date
slurmdir = "/scratch/aps376/recombo/APS178reducedcore/%s_slurm" % date
#scratch = os.environ['SCRATCH']
mkdir_p(archive)
mkdir_p(submitdir)
mkdir_p(slurmdir)
mkdir_p(newarchive)

"make all possible combos of clusters"

sero_list = [10, 11, 32, 68, 69, 83, 88, 95, 97, 98, 101, 104, 105, 114,
             122, 139, 144, 148, 151, 152, 153, 155, 156, 157, 158, 163, 165,
             166, 168, 169, 174, 175, 177, 179, 180, 181, 183, 188, 189, 197,
             199, 201, 203, 204]

clusterlist = []

for s in sero_list:
    clusterlist.append("cluster"+str(s))

#print(str(np.arange(0,30)))
##can divide into groups of 8 for submission
count = 0
##will do to len(pairs) in futur
for c in clusterlist:
    outdir = os.path.join(newarchive, c)
    mkdir_p(outdir)
    count = count + 1
    #os.system('cd %s' %job_directory)
    job_file = os.path.join(submitdir, "reducecore_%s.sh" % c)
    with open(job_file, "w+") as fh:
        fh.writelines("#!/bin/bash\n")
        fh.writelines("#SBATCH --job-name=reduced_%s\n" % c)
        fh.writelines("#SBATCH --nodes=1\n")
        fh.writelines("#SBATCH --cpus-per-task=4\n")
        fh.writelines("#SBATCH --time=8:00:00\n")
        fh.writelines("#SBATCH --mem=8GB\n")
        fh.writelines("#SBATCH --mail-type=END,FAIL\n")
        fh.writelines("#SBATCH --mail-user=aps376@nyu.edu\n")
        fh.writelines("#SBATCH --output=%s/slurm%%j_%s.out\n" % (slurmdir, c))
        fh.writelines("#SBATCH --mail-user=aps376@nyu.edu\n")
        fh.writelines("\n")
        #load modules
        fh.writelines("module purge\n")
        fh.writelines("module load go/1.15.7\n")
        fh.writelines("module load python/intel/3.8.6\n")
        ##Making everything in path
        #mcorr
        fh.writelines("\n")
        fh.writelines("export PATH=$PATH:$HOME/go/bin:$HOME/.local/bin\n")
        #load virtual enviromment ...
        fh.writelines("cd /scratch/aps376/recombo\n")
        fh.writelines("source venv/bin/activate\n")
        fh.writelines("export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK;\n")
        #ReferenceAlignmentGenerator
        fh.writelines("export PATH=$PATH:~/opt/AssemblyAlignmentGenerator/\n")
        fh.writelines("export PATH=$PATH:~/opt/ReferenceAlignmentGenerator\n")
        fh.writelines("\n")
        msa_core = os.path.join(archive, c, "MSA_CORE_%s" % c)
        msa_flex = os.path.join(archive, c, "MSA_FLEX_%s" % c)
        fh.writelines("ReduceCoreGenome %s %s %s\n" % (msa_core, msa_flex, outdir))
    os.system("sbatch %s" %job_file)
    print('submitted %s' % c)
    time.sleep(1)
print('%s total submissions' %count)