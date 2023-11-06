import sys
count_snp = {}
number_isolates = []
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
  pos = line2.strip().split(" ")[0]
  ref = line2.strip().split(" ")[1]
  alt = line2.strip().split(" ")[2]
  lineID= pos+"-"+ref+"-"+alt
  if lineID in count_snp:
    if len(count_snp[lineID])==len(set(number_isolates)) and all(n > 0.95 for n in count_snp[lineID]):
      continue
    else:
      print (line2,end='')

