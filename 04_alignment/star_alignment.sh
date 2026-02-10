#!/bin/bash

#SBATCH -t 0-2:00 		# hours:minutes runlimit after which job will be killed
#SBATCH -c 8 		# number of cores requested -- this needs to be greater than or equal to the number of cores you plan to use to run your job
#SBATCH --mem 16G
#SBATCH --job-name STAR_YOURNAME 		# Job name
#SBATCH -o %j.out			# File to which standard out will be written
#SBATCH -e %j.err 		# File to which standard err will be written

for R1 in /PATH/TO/READS/*_1.fastq.gz
do
    # Extract sample name
    SAMPLE=$(basename ${R1} _1.fastq.gz)

    echo "Processing sample: ${SAMPLE}"

    STAR --runThreadN 8 \
         --genomeDir /PATH/TO/STAR_INDEX \
         --readFilesIn /PATH/TO/READS/${SAMPLE}_1.fastq.gz /PATH/TO/READS/${SAMPLE}_2.fastq.gz \
         --readFilesCommand zcat \
         --outFileNamePrefix /PATH/TO/OUTPUT/${SAMPLE}_ \
         --outSAMtype BAM SortedByCoordinate \
         --outSAMunmapped Within \
	     --outSAMattributes Standard \
         --quantMode GeneCounts TranscriptomeSAM

    echo "Finished sample: ${SAMPLE}"
    echo "----------------------------------"
done

echo "All samples completed."