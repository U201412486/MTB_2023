cd /Parastor300s_G30S/sunxh/MTB/v_snp
for i in $(ls /Parastor300s_G30S/sunxh/MTB/raw_data2/*.mdup.sort.bam |cat |sed 's/\/Parastor300s_G30S\/sunxh\/MTB\/raw_data2\///' |awk -F '.' '{print $1}')
do
echo "#!/bin/sh" >> varscan2_$i.pbs
echo "#PBS -N varscan2_$i" >> varscan2_$i.pbs
echo "#PBS -j eo" >> varscan2_$i.pbs
echo "#PBS -q Fat" >> varscan2_$i.pbs
echo "#PBS -l nodes=1:ppn=2"  >> varscan2_$i.pbs
echo "cd /Parastor300s_G30S/sunxh/MTB/raw_data2" >> varscan2_$i.pbs
echo "/Parastor300s_G30S/sunxh/software2/bin/samtools mpileup -C 50 -Q 20 -q 30 --ff UNMAP,SECONDARY,QCFAIL,DUP,SUPPLEMENTARY -f /Parastor300s_G30S/sunxh/public/genome_nnotation/MTB.ncbi/GCF_000195955.2_ASM19595v2_genomic.fna ./$i.mdup.sort.bam | java -jar /Parastor300s_G30S/sunxh/software2/bin/VarScan.v2.4.2.jar mpileup2snp --min-coverage 20 --min-var-freq 0.005 --min-avg-qual 20 --min-reads2 4 --min-freq-for-hom 0.9 --p-value 99e-02 --strand-filter 1 > /Parastor300s_G30S/sunxh/MTB/v_snp/$i.varscan2.var" >> varscan2_$i.pbs
echo "/Parastor300s_G30S/sunxh/software/Python-2.7.5/sxh_configure/bin/python2 /Parastor300s_G30S/sunxh/software/LoFreq-0.4.0/build/scripts-2.7/lofreq_snpcaller.py -f /Parastor300s_G30S/sunxh/public/genome_nnotation/MTB.ncbi/GCF_000195955.2_ASM19595v2_genomic.fna -b ./$i.mdup.sort.bam -o /Parastor300s_G30S/sunxh/MTB/v_snp/$i.lofreq.snp" >> varscan2_$i.pbs
qsub varscan2_$i.pbs
done

for i in $(ls /Parastor300s_G30S/sunxh/MTB/raw_data/*.mdup.sort.bam |cat |sed 's/\/Parastor300s_G30S\/sunxh\/MTB\/raw_data\///' |awk -F '.' '{print $1}' |grep -v ^a)
do

/Parastor300s_G30S/sunxh/software/Python-2.7.5/sxh_configure/bin/python2 /Parastor300s_G30S/sunxh/software/LoFreq-0.4.0/build/scripts-2.7/lofreq_filter.py --strandbias-holmbonf --min-cov 20 --max-cov 3000 -i /Parastor300s_G30S/sunxh/MTB/v_snp/$i.lofreq.snp -o /Parastor300s_G30S/sunxh/MTB/v_snp/$i.lofreq.filt.snp

perl /Parastor300s_G30S/sunxh/software/MTB_script/varscan_lofreq_compare.pl /Parastor300s_G30S/sunxh/MTB/v_snp/$i.lofreq.filt.snp /Parastor300s_G30S/sunxh/MTB/v_snp/$i.varscan2.var > /Parastor300s_G30S/sunxh/MTB/v_snp/$i.var

perl /Parastor300s_G30S/sunxh/MTB/v_snp2/3a_mix_filter.pl <(perl /Parastor300s_G30S/sunxh/software/MTB_script/1_format_trans.pl /Parastor300s_G30S/sunxh/MTB/v_snp/$i.var) > $i.varscan2.snp

python /Parastor300s_G30S/sunxh/MTB/v_snp2/varscan2_to_lofreq.py $i.varscan2.snp $i.lofreq.filt.snp > $i.snp
awk '{if($4<=0.95)print}' $i.snp > $i.var.snp
python ../v_snp2/write_fix_snp.py $i.lofreq.filt.snp > $i.fix.snp
done














#rm 17_m19.format 30_m0.format 30_m7.format 36_m6.format 47_m5.format
#rm 30_m11.format 30_m21.format 47_m0.format 36_m0.format
#for i in $(ls /Parastor300s_G30S/sunxh/MTB/raw_data/*.mdup.sort.bam |cat |sed 's/\/Parastor300s_G30S\/sunxh\/MTB\/raw_data\///' |awk -F '.' '{print $1}'|grep -v ^30 |grep -v ^36 |grep -v ^47)
#do 
#done
