cd /Parastor300s_G30S/sunxh/MTB
for i in $(find /Parastor300s_G30S/sunxh/MTB/raw_data2 -name '*.mdup.sort.bam' |cat |sed 's/\/Parastor300s_G30S\/sunxh\/MTB\/raw_data2\///'|awk -F '_' '{print $1}' |sort -nk 1 |uniq)
do
echo "#!/bin/sh" >> vcf_$i.pbs
echo "#PBS -N vcf_$i" >> vcf_$i.pbs
echo "#PBS -j eo" >> vcf_$i.pbs
echo "#PBS -q Blade" >> vcf_$i.pbs
echo "#PBS -l nodes=1:ppn=10"  >> vcf_$i.pbs
echo "cd /Parastor300s_G30S/sunxh/MTB/raw_data2" >> vcf_$i.pbs
echo "date" >> vcf_$i.pbs
#echo "/Parastor300s_G30S/sunxh/software/bin/bcftools mpileup -C 50 -Q 20 -q 30 -d 200000 -L 200000 --ff UNMAP,SECONDARY,QCFAIL,DUP,SUPPLEMENTARY -f /Parastor300s_G30S/sunxh/public/MTB_ncbi/GCF_000195955.2_ASM19595v2_genomic.fna --threads 10 ./${i}_*.mdup.sort.bam --annotate FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/DP,INFO/AD,INFO/ADF,INFO/ADR > ../vcf2/$i.mpileup" >> vcf_$i.pbs
echo "/Parastor300s_G30S/sunxh/software/bin/bcftools mpileup -C 50 -Q 20 -q 30 -d 200000 -L 200000 --ff UNMAP,SECONDARY,QCFAIL,DUP,SUPPLEMENTARY -f /Parastor300s_G30S/sunxh/public/MTB_ncbi/GCF_000195955.2_ASM19595v2_genomic.fna --threads 4 ./${i}_*.mdup.sort.bam --annotate FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/DP,INFO/AD,INFO/ADF,INFO/ADR  | /Parastor300s_G30S/sunxh/software/bin/bcftools call -mv --threads 4 --ploidy 1 -f GQ  > ../vcf2/$i.raw.vcf" >> vcf_$i.pbs
echo "date" >> vcf_$i.pbs
qsub vcf_$i.pbs
done
