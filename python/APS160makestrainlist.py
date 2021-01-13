##this script is to just confirm that everything was written correctly in the test MSA

MSApath = '/scratch/aps376/recombo/APS158_SP_Archive/SP_MASTER_OUT/MSA_SP_PANGENOME_MASTER'

MSA = open(MSApath, 'r')
strains = set()
for _, line in enumerate(MSA):
    if line.startswith(">"):
        terms = line.rstrip().split(" ")
        strain = str.split(line, " ")[2]
        strains.add(strain)

i = 0
with open("APS160_strain_list", "w+") as f:
    for strain in strains:
        f.write("%s" % strain)
        i = i + 1

print("total number of strains: ", i)