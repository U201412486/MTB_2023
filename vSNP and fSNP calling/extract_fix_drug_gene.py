import sys
count_snp = {}
number_isolates = []

gene_left ={}
gene_right = {}
for line in open("/Parastor300s_G30S/sunxh/public/genome_nnotation/MTB.ncbi/drug_gene_from_WHO-UCN-GTB-PCI-2021.7-eng2_annotation.infor"):
  gene_left[line.strip().split("\t")[0]] = line.strip().split("\t")[3]
  gene_right[line.strip().split("\t")[0]] = line.strip().split("\t")[4]

drug_position = []
for line in open("/Parastor300s_G30S/sunxh/public/genome_nnotation/MTB.ncbi/drug_gene_from_WHO-UCN-GTB-PCI-2021.7-eng2_postion2"):
  if line.startswith("Genome"):
    continue
  drug_position.append(line.strip())


for line in open(sys.argv[1]):
  pos = line.strip().split(" ")[0]
  ref = line.strip().split(" ")[1]
  alt = line.strip().split(" ")[2]
  lineID= pos+"-"+ref+"-"+alt
  count_snp[lineID] = []

for line in open(sys.argv[1]):
  pos = line.strip().split(" ")[0]
  ref = line.strip().split(" ")[1]
  alt = line.strip().split(" ")[2]
  lineID= pos+"-"+ref+"-"+alt
  number_isolates.append(line.strip().split(" ")[6])
  if float(line.strip().split(" ")[3]) < 0.05:
    continue
  if lineID in count_snp:
    count_snp[lineID].append(float(line.strip().split(" ")[3]))


for line2 in open(sys.argv[1]):
  a = 0
  pos = line2.strip().split(" ")[0]
  for key in gene_left:
    if float(pos) >= float(gene_left[key]) and float(pos) <= float(gene_right[key]):
      a = 1
  if pos in drug_position:
    a = 1


  if a == 0:
    continue
  ref = line2.strip().split(" ")[1]
  alt = line2.strip().split(" ")[2]
  lineID= pos+"-"+ref+"-"+alt
  if lineID in count_snp:
    if len(count_snp[lineID])==len(set(number_isolates)) and all(n > 0.95 for n in count_snp[lineID]):
      print (line2,end='')

