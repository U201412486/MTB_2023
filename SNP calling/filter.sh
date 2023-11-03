cd /Parastor300s_G30S/sunxh/MTB/vcf2
for file in *.raw.vcf
do
name=$(echo ${file} |sed 's/\.raw\.vcf//g')
/Parastor300s_G30S/sunxh/software2/bcftools-1.14/sxh_install/bin/bcftools +fill-tags ./${file} -- -t VAF > /Parastor300s_G30S/sunxh/MTB/vcf2/${name}.raw2.vcf
done
cd /Parastor300s_G30S/sunxh/MTB/vcf2
for file in *.raw2.vcf
do
name=$(echo ${file} |sed 's/\.raw2\.vcf//g')

bcftools filter -e'GT ="."' ./${name}.raw2.vcf > ./${name}.tmp1.vcf
bcftools norm -m -any ./${name}.tmp1.vcf > ./${name}.tmp2.vcf
bcftools filter --threads 24 -O v -o ./${name}.tmp3.vcf -i 'QUAL>=60 && TYPE="snp" && DP4[2] >=20*AC && DP4[3] >=20*AC' ./${name}.tmp2.vcf
#bcftools filter --threads 24 -O v -o ./${name}.tmp4.vcf -e'VAF<0.95 & VAF>0.05' ./${name}.tmp3.vcf
#bcftools filter --threads 24 -O v -o ./${name}.tmp4.vcf -e'VAF<0.75' ./${name}.tmp3.vcf
mv ./${name}.tmp3.vcf ./${name}.tmp4.vcf
/home/software/vcftools.0.1.15/bin/vcftools --vcf ./${name}.tmp4.vcf --exclude-bed /Parastor300s_G30S/sunxh/public/genome_nnotation/MTB.ncbi/PE_PPE_repeat.bed --recode --out ./${name}
done
rm *tmp*
rm *log
