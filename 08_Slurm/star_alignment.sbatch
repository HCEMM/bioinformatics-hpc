#!/bin/bash

#SBATCH -t 0-2:00 		# days-hours:minutes runlimit after which job will be killed
#SBATCH -c 8 		    # number of cores requested
#SBATCH --mem=16G
#SBATCH --job-name=star
#SBATCH -o logs/star_%j.out
#SBATCH -e logs/start_%j.err

# Setup Directories
READS_DIR=
OUTPUT_DIR=
INDEX_FOLDER=

for R1 in ${READS_DIR}/*_1.fastq.gz
do
    # Extract sample name
    SAMPLE=$(basename ${R1} _1.fastq.gz)

    echo "Processing sample: ${SAMPLE}"

    # Run STAR


    echo "Finished sample: ${SAMPLE}"
    echo "----------------------------------"
done

echo "All samples completed."
