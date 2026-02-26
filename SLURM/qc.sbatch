#!/bin/bash
#SBATCH --job-name=YOUR_NAME_fastqc
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --output=fastqc_%j.out
#SBATCH --error=fastqc_%j.err

# -----------------------------
# Load required module
# -----------------------------
module load fastqc

# -----------------------------
# USER MUST MODIFY THESE
# -----------------------------
THREADS=4
INPUT_DIR="/common/workshop_data/raw_data"
OUTPUT_DIR="./fastqc_results"

# -----------------------------
# Create output directory
# -----------------------------
mkdir -p $OUTPUT_DIR

# -----------------------------
# Run FastQC
# -----------------------------
fastqc -t $THREADS ${INPUT_DIR}/*.fastq.gz -o $OUTPUT_DIR

echo "FastQC analysis complete"