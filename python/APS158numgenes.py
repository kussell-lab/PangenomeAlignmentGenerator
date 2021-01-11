##this script is to just confirm that everything was written correctly in the test MSA

MSApath = '/Volumes/aps_timemachine/recombo/APS158_pangenomealignmentgenerator/listeria_xmfa_1223/1224_properheader'

MSA = open(MSApath, 'r')
i = 0
for _, line in enumerate(MSA):
    if line == "=\n":
        i = i + 1
print("total number of genes: ", i)

j = 0
i = 0
MSA = open(MSApath, 'r')
for _, line in enumerate(MSA):
    if line.startswith(">"):
        j = j + 1
    elif line == "=\n" and j == 2:
        i = i + 1
        j = 0
    elif line == "=\n" and j != 2:
        j = 0
print("total number of genes shared between the two strains: ", i)

##now confirm that all the genes are the same length
j = 0
length = 0
MSA = open(MSApath, 'r')
for _, line in enumerate(MSA):
    if line.startswith(">"):
        continue
    if line == "=\n":
        length = 0
        continue
    elif length != 0:
        if length != len(line):
            print("not same length")
        else: j = j + 1
    else: length = len(line)
print("genes with same length: ", j)