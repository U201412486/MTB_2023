mix_isolate = ["2_m5","6_m2","17_m34","19_m24","39_m8","43_m17","44_m14","17_m19","14_m5","25_m13","32_m1","38_m5","42_m8","49_m1","47_m5","2_m0","14_m0","47_m0","49_m0","32_m0","30_m0","30_m7","36_m6","30_m11","30_m21","36_m0"]
for line in open("/Parastor300s_G30S/sunxh/MTB/raw_data/1bp.depth.list"):
  line = line.strip().split(".")[0]
  if line in mix_isolate:
    print (line.split("_")[0],line.split("m")[1],"Yes",sep="\t")
  else:
    print (line.split("_")[0],line.split("m")[1],"No",sep="\t")
