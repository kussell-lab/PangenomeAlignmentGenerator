#!/bin/bash
# This script generates an XMFA file for whole genome sequences which have been aligned to a pangenome reference
# created with Roary
# Script by Asher Preska Steinberg (apsteinberg@nyu.edu).
# Usage: PangenomeAlignmentGenerate <assembly summary file> <assembly tsv> <sra list> <output directory> <output prefix>
# Arguments:
#   <assembly summary file> can be download from ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/assembly_summary_refseq.txt
#   <assembly tsv> tsv of assembly accessions; search for assemblies in NCBI, select the Send option when viewing search
#                   results, then select "File" for "Choose Destination" and "ID Table" for "Format".
#   <sra list> list of sra files which you want to align
#   <output directory> is the working space and output directory
#   <output prefix> is the output_prefix for the final pangenome alignment
# Results:
#   <output directory>/<output prefix>_pangenome.xmfa stores the final alignments to the pangenome reference
# This program contains five steps as detailed below.

assembly_summary_file=$1
genome_list=$2
sra_list=$3
output_dir=$4
output_prefix=$5

mkdir -p ${output_dir}

##Step 1: fetch genomes from NCBI
FetchGenomes ${assembly_summary_file} ${genome_list} ${output_dir}/genome_assemblies

##Step 2: use Prokka to reannotate genomes
mkdir -p ${output_dir}/prokka
InvokeProkka assembly_accession_list ${output_dir}/genome_assemblies ${output_dir}/prokka

##Step 3: use Roary to generate a pangenome
mkdir -p ${output_dir}/roary
InvokeRoary assembly_accession_list ${output_dir}/prokka ${output_dir}/roary

##Step 4: map reads to the roary pangenome
mkdir -p ${output_dir}/alignments
ref=${output_dir}/roary/pan_genome_reference.fa
ConvertMap ${sra_list} ${output_dir}/alignments ${ref}

##Step 5: Collect alignments into an XMFA file
CollectPangenomeAlignments ${sra_list} ${ref} ${output_dir}/alignments ${output_dir}/${output_prefix}_pangenome.xmfa --progress