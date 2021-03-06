# PangenomeAlignmentGenerator
This repository contains what you need to align SRAs to a
pangenome multi-FASTA file generated by Roary via reference-guided
alignment.

### Input:
Whole genome assemblies from NCBI

### Outputs:
* XMFA file for whole genome sequences which have been aligned to
a pangenome reference generated by Roary.
* Pangenome analysis statistics

### Installation

Start by cloning this repository and installing the different parts
of the package via pip:

* `pip install ~/go/src/github.com/kussell-lab/PangenomeAlignmentGenerator`

You will also need to install the following dependencies:

* [Roary](https://sanger-pathogens.github.io/Roary/)
* [Prokka](https://github.com/tseemann/prokka)
* [GNU parallel](https://www.gnu.org/software/parallel/)

If you want to use SplitGenome (to split the final alignment into XMFA files
for core and accessory genes) this can be installed via `go get`:
* `go get -u github.com/kussell-lab/PangenomeAlignmentGenerator/SplitGenome`

## Usage

`PangenomeAlignmentGenerate <assembly summary file> <assembly tsv> <sra list> <output directory> <output prefix>`

* `<assembly summary file>` can be download from ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/assembly_summary_refseq.txt
* `<assembly tsv>` tsv of assembly accessions; search for assemblies in NCBI, select the Send option when viewing search
                   results, then select "File" for "Choose Destination" and "ID Table" for "Format".
* `<sra list>` list of sra files which you want to align
* `<output directory>` is the working space and output directory
*  `<output_prefix>` is the output_prefix for the final pangenome alignment

Output is an XMFA file (`<output directory>/<output prefix>_pangenome.xmfa`) containing the alignments of each sequence to the pangenome
reference. You can then use `SplitGenome` to split this into XMFA files for core and accessory genes.

It may be preferable to run each of the steps of this program separately (due to download issues, etc). You can view each step 
the program takes by looking at the script `bin/PangenomeAlignmentGenerate` or `PangenomeAlignmentGenerate.sh`.


