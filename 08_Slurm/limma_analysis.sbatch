#!/bin/bash

#SBATCH -t 0-1:00              # Runtime (D-HH:MM)
#SBATCH -c 4                   # Number of CPU cores
#SBATCH --mem=8G               # Memory
#SBATCH --job-name=limma_USER  # Change USER to your name
#SBATCH -o %j.out              # Standard output
#SBATCH -e %j.err              # Standard error

# Get the current time
START_TIME=$(date +"%Y-%m-%d %H:%M:%S"); START_SECONDS=$(date +%s)
echo "Starting FastQC analysis at: $START_TIME"

# Load R modules


# Define variables
COUNTS=
GENE_NAMES=
OUTPUT_DIR=

# Run the R script
Rscript /common/workshop_data/scripts/limma_analysis.R ${COUNTS} ${GENE_NAMES} ${OUTPUT_DIR}

# Calculate runtime
RUNTIME=$((END_SECONDS - START_SECONDS))
HOURS=$((RUNTIME / 3600))
MINUTES=$(((RUNTIME % 3600) / 60))
SECONDS=$((RUNTIME % 60))
echo "Total runtime: ${HOURS}h ${MINUTES}m ${SECONDS}s"
