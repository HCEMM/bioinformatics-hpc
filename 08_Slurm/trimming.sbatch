#!/bin/bash
#SBATCH --job-name=trim_array
#SBATCH --output=logs/trim_%A_%a.out
#SBATCH --error=logs/trim_%A_%a.err
#SBATCH --nodes=1
#SBATCH --ntasks=1          # still 1!
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=02:00:00
#SBATCH --array=0-3

# Get the current time
START_TIME=$(date +"%Y-%m-%d %H:%M:%S"); START_SECONDS=$(date +%s)
echo "Starting FastQC analysis at: $START_TIME"

# Load the module


# Define your sample names (Update these to match your actual file prefixes)
SAMPLES=

# Get the specific sample for this task
SAMPLE=${SAMPLES[$SLURM_ARRAY_TASK_ID]}

# Setup Directories
INPUT_DIR=
OUTPUT_DIR=
ADAPTERS=

# Make output directory
mkdir -p $OUTPUT_DIR

# Run Trimmomatic
# - TruSeq3 adapters
# - Sliding window for each 5 reads, cut if average quality drops below 25
# - Remove leading bases with quality below 5
# - Remove trailing bases with quality below 4
# - Minimum read length of 36 after trimming


# Calculate runtime
RUNTIME=$((END_SECONDS - START_SECONDS))
HOURS=$((RUNTIME / 3600))
MINUTES=$(((RUNTIME % 3600) / 60))
SECONDS=$((RUNTIME % 60))
echo "Total runtime: ${HOURS}h ${MINUTES}m ${SECONDS}s"
