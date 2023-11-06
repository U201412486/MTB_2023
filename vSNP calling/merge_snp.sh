

#python3 write_mix_isolate.py > mix_isolate
for name in $(ls /Parastor300s_G30S/sunxh/MTB/raw_data/*.mdup.sort.bam |cat |sed 's/\/Parastor300s_G30S\/sunxh\/MTB\/raw_data\///' |awk -F '.' '{print $1}' |grep -E -v "^2_m5$|^6_m2$|17_m34$|19_m24$|39_m8$|43_m17$|44_m14$|17_m19$|14_m5$|25_m13$|32_m1$|38_m5$|42_m8$|49_m1$|47_m5$|^2_m0$|14_m0$|47_m0$|49_m0$|32_m0$|30_m0$|30_m7$|36_m6$|30_m11$|30_m21$|36_m0$")
do
cat ../v_snp/${name}.fix.snp ../v_snp/${name}.var.snp > ./${name}.snp
done
for name in $(ls *.snp |awk -F "_" '{print $1}' |sort |uniq |grep -v ^all)
do
cat ${name}_m*snp | awk '{if($4>=0.05)print}' > tmp
python3 extract_informate_snp.py tmp > ${name}.2snp 
python3  extract_fix_drug_gene.py tmp > ${name}.3snp
python3 extract_fix.py tmp > ${name}.4snp
done
cat *.2snp > all.vsnp
perl 6_H37Rv_annotate.pl /Parastor300s_G30S/sunxh/public/genome_nnotation/MTB.ncbi/GCF_000195955.2_ASM19595v2_annotation.infor /Parastor300s_G30S/sunxh/software2/TBRU_serialTB/scripts/variant_extraction/support_data/2_genetic_codes /Parastor300s_G30S/sunxh/public/genome_nnotation/MTB.ncbi/GCF_000195955.2_ASM19595v2_genomic.fna all.vsnp > all.vsnp.annotated

cat *.3snp > all.fix_drugsnp
perl 6_H37Rv_annotate.pl /Parastor300s_G30S/sunxh/public/genome_nnotation/MTB.ncbi/GCF_000195955.2_ASM19595v2_annotation.infor /Parastor300s_G30S/sunxh/software2/TBRU_serialTB/scripts/variant_extraction/support_data/2_genetic_codes /Parastor300s_G30S/sunxh/public/genome_nnotation/MTB.ncbi/GCF_000195955.2_ASM19595v2_genomic.fna all.fix_drugsnp > all.fix_drugsnp.annotated
cat *.4snp > all.fix_snp
perl 6_H37Rv_annotate.pl /Parastor300s_G30S/sunxh/public/genome_nnotation/MTB.ncbi/GCF_000195955.2_ASM19595v2_annotation.infor /Parastor300s_G30S/sunxh/software2/TBRU_serialTB/scripts/variant_extraction/support_data/2_genetic_codes /Parastor300s_G30S/sunxh/public/genome_nnotation/MTB.ncbi/GCF_000195955.2_ASM19595v2_genomic.fna all.fix_snp > all.fix_snp.annotated
