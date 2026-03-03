#!/bin/bash
#SBATCH --job-name=
#SBATCH --time=
#SBATCH --cpus-per-task=
#SBATCH --mem=
#SBATCH --output=
#SBATCH --error=

THREADS=
INPUT_DIR=
OUTPUT_DIR=

# Get the current time
START_TIME=$(date +"%Y-%m-%d %H:%M:%S"); START_SECONDS=$(date +%s)
echo "Starting FastQC analysis at: $START_TIME"

# Load FastQC module


# Make FastQC output directory


# Run FastQC


# Get current time
END_TIME=$(date +"%Y-%m-%d %H:%M:%S"); END_SECONDS=$(date +%s)

echo "FastQC analysis complete at: $END_TIME"

# Calculate runtime
RUNTIME=$((END_SECONDS - START_SECONDS))
HOURS=$((RUNTIME / 3600))
MINUTES=$(((RUNTIME % 3600) / 60))
SECONDS=$((RUNTIME % 60))
echo "Total runtime: ${HOURS}h ${MINUTES}m ${SECONDS}s"
