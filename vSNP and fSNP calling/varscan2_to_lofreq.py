import sys
coverage = {}
freq = {}
month = sys.argv[2].split(".")[0].split("_")[0]
stage = sys.argv[2].split(".")[0].split("_")[1][1:]
for line in open(sys.argv[2],"r"):
  _coverage = line.strip().split(" ")[4].split(";")[4].split(":")[1]
  _freq = line.strip().split(" ")[3]
  _pos = line.strip().split(" ")[1]
  coverage[_pos] = _coverage
  freq[_pos] = _freq
for line in open(sys.argv[1],"r"):
  _pos = line.strip().split("\t")[1]
  _ref = line.strip().split("\t")[2]
  _alt = line.strip().split("\t")[3]
  print (_pos + " "+ _ref + " "+ _alt + " "+ freq[_pos] + " "+ coverage[_pos]+ " "+ month + " "+stage+"\n",end='')
