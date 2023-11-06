for name in $(ls /home/sunxh/project/bacterium2/raw_data/*_m*R1.fastq.gz |sed 's/_L001_R1\.fastq\.gz//g')
do
file=$(basename ${name})
echo "#!/bin/sh" >> ${file}.pbs
echo "#PBS -N ${file}" >> ${file}.pbs
echo "#PBS -j eo" >> ${file}.pbs
echo "#PBS -q Blade" >> ${file}.pbs
echo "#PBS -l nodes=1:ppn=40" >> ${file}.pbs
echo "cd /home/sunxh/project/bacterium2/raw_data" >> ${file}.pbs
echo "date" >> ${file}.pbs
echo "/home/software/bwa-0.7.15/bwa mem -t 6 /home/sunxh/public/genome_nnotation/bwa_mem_MTB_index/MTB ./${file}_L001_R1.fastq.gz ./${file}_L001_R2.fastq.gz | samtools view -@ 2 -bS - > ./${file}.bam" >> ${file}.pbs
echo "samtools sort -@ 8 ./${file}.bam -o ./${file}.sort.bam" >> ${file}.pbs
#echo "rm ./${file}.bam" >> ${file}.pbs
echo "/home/sunxh/software/jdk1.8.0_131/bin/java -jar /home/sunxh/software/picard_2.202.jar MarkDuplicates I=/home/sunxh/project/bacterium2/raw_data/${file}.sort.bam O=/home/sunxh/project/bacterium2/raw_data/${file}.mdup.sort.bam M=/home/sunxh/project/bacterium2/raw_data/${file}.mdup.metrics.txt" >>${file}.pbs
#echo "rm ./${file}.sort.bam" >> ${file}.pbs
echo "samtools index -@ 8 ./${file}.mdup.sort.bam" >> ${file}.pbs
#echo "/home/software/FastQC/fastqc -t 8 -o /Parastor300s_G30S/sunxh/MTB/raw_fastqc --noextract -f fastq ./${file}_L001_R1.fastq.gz ./${file}_L001_R2.fastq.gz" >> ${file}.pbs
done
qsub ${file}.pbs
