import sys
PE_PPE_repeat_left={}
PE_PPE_repeat_right={}
for line in open("/Parastor300s_G30S/sunxh/public/genome_nnotation/MTB.ncbi/PE_PPE_repeat.bed"):
  if line.startswith("#"):
    continue
  id = line.split("\t")[9].split(";")[0].split("=")[1]
  PE_PPE_repeat_left[id] = float(line.split("\t")[1])
  PE_PPE_repeat_right[id] = float(line.split("\t")[2])


coverage = {}
freq = {}
month = sys.argv[1].split(".")[0].split("_")[0]
stage = sys.argv[1].split(".")[0].split("_")[1][1:]
a=0
for line in open(sys.argv[1],"r"):
  a = 0
  _coverage = line.strip().split(" ")[4].split(";")[4].split(":")[1]
  _freq = line.strip().split(" ")[3]
  _pos = line.strip().split(" ")[1]
  for key in PE_PPE_repeat_left:
    if float(_pos) >= PE_PPE_repeat_left[key] and float(_pos) <= PE_PPE_repeat_right[key]:
      a=1

  coverage[_pos] = _coverage
  _ref = line.strip().split(" ")[2].split(">")[0]
  _alt = line.strip().split(" ")[2].split(">")[1]
  freq[_pos] = _freq
  if float(_freq) > 0.95 and a == 0:
    print (_pos + " "+ _ref + " "+ _alt + " "+ _freq + " "+ coverage[_pos]+ " "+ month + " "+stage+"\n",end='')

    


