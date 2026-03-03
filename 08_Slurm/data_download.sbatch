#!/bin/bash
#SBATCH --job-name=sra_download
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --output=logs/sra_download_%j.out
#SBATCH --error=logs/sra_download_%j.err

# Get the current time
START_TIME=$(date +"%Y-%m-%d %H:%M:%S"); START_SECONDS=$(date +%s)
echo "Starting FastQC analysis at: $START_TIME"

# Load module


# Setup Directories
ACCESSIONS_FILE=/common/bioinformatics-hpc/01_data/sra_accessions.txt
OUTPUT_DIR=./workshop_results/sra_download

# Make output directory
mkdir -p $OUTPUT_DIR

# Download in a loop
while read sra
do

done < $ACCESSIONS_FILE

# Gzip all files, don't keep the uncompressed


# Calculate runtime
RUNTIME=$((END_SECONDS - START_SECONDS))
HOURS=$((RUNTIME / 3600))
MINUTES=$(((RUNTIME % 3600) / 60))
SECONDS=$((RUNTIME % 60))
echo "Total runtime: ${HOURS}h ${MINUTES}m ${SECONDS}s"
