#!/usr/bin/env python3
"""
Fetch genome sequences from NCBI FTP via rsync
Created by Asher Preska Steinberg (apsteinberg@nyu.edu)
"""
import argparse
import gzip
import os
import ftplib
import tqdm

def mkdir_p(dir):
    'make a directory if doesnt exist'
    if not os.path.exists(dir):
        os.mkdir(dir)

def main():
    """
    main function
    """
    parser = argparse.ArgumentParser(description="Fetch genome sequences from NCBI FTP")
    parser.add_argument("NCBI_refseq_list", help="NCBI file listing all genome assemblies;\
     ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/assembly_summary_refseq.txt")
    parser.add_argument("assembly_tsv", help="assembly accession list file; search for assemblies in NCBI,\
                                                        select the Send to option when viewing search results,\
                                                        then select Choose Destination: File, and Format: ID Table (text).\
                                                         This will give the right format")
    parser.add_argument("out_dir", help="output directory")
    # parse command arguments.
    args = parser.parse_args()
    assembly_summary_file = args.NCBI_refseq_list
    assembly_accession_list_file = args.assembly_tsv
    out_dir = args.out_dir

    # assembly_summary_file = '/Users/asherpreskasteinberg/Desktop/code/recombo/APS159_NG_Analysis/assembly_summary_refseq.txt'
    # assembly_accession_list_file ='/Users/asherpreskasteinberg/Desktop/code/recombo/APS159_NG_Analysis/assembly_result.txt'
    # out_dir = '/Users/asherpreskasteinberg/Desktop/code/recombo/APS159_NG_Analysis/blargh'

    # read the list of assembly accessions.
    assembly_accession_set = set()
    with open(assembly_accession_list_file, 'r') as input_file:
        for line in input_file:
            if line.startswith("GenBank"):
                continue
            else:
                terms = line.rstrip().split("\t")
                accession = terms[2]
                if accession == "N/A":
                    continue
                else:
                    assembly_accession_set.add(accession)

    ##save as a list for next step with Prokka
    with open("assembly_accession_list", "w+") as f:
        for accession in assembly_accession_set:
            f.write("%s\n" % accession)

    # read assembly summary report file, which is a TAB file,
    # and obtain a hashmap of accession:ftp path.
    assembly_ftp_paths = {}
    with open(assembly_summary_file, 'r') as input_file:
        header = []
        for line in input_file:
            terms = line.rstrip().split("\t")
            if line.startswith('#'):
                header = terms
            else:
                accession = terms[0]
                ftp_path = terms[header.index("ftp_path")]
                if accession in assembly_accession_set:
                    assembly_ftp_paths[accession] = ftp_path

    # download genomic sequences from FTP.
    print("Fetching genome sequences from NCBI FTP:")
    mkdir_p(out_dir)
    for accession in tqdm.tqdm(assembly_ftp_paths.keys()):
        # create assembly output directory if not exists.
        assembly_out_dir = os.path.join(out_dir, accession)
        mkdir_p(assembly_out_dir)
        # if not os.path.exists(assembly_out_dir):
        #     os.makedirs(assembly_out_dir)

        ftp_path = assembly_ftp_paths[accession].replace('ftp://', "rsync://")
        base_name = os.path.basename(assembly_ftp_paths[accession])
        appendix_list = ["_genomic.fna.gz"]
        for appendix in appendix_list:
            # download file from FTP.
            ftp_file_path = os.path.join(ftp_path, base_name + appendix)
            #os.system("rsync --copy-links --times --verbose %s %s/" %(ftp_file_path, assembly_out_dir))
            os.system("rsync --copy-links --times --quiet %s %s/" % (ftp_file_path, assembly_out_dir))
            local_gzip_file = os.path.join(assembly_out_dir, base_name + appendix)
            # unzip file
            #local_text_file = local_gzip_file.replace(".gz", "")
            local_text_file = os.path.join(assembly_out_dir, accession + "_genomic.fna")
            with open(local_text_file, 'wb') as out:
                with gzip.open(local_gzip_file) as handle:
                    out.write(handle.read())
            os.remove(local_gzip_file)
    print("Genome sequences were saved in %s" % out_dir)

if __name__ == "__main__":
    main()