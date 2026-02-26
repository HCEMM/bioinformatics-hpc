#!/bin/bash
#SBATCH --job-name=sra_download
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --output=sra_download_%j.out
#SBATCH --error=sra_download_%j.err

# Load module
module load sratoolkit

# Create output directory
OUTDIR="Path/To/Output/raw_data"
mkdir -p $OUTDIR

# Download SRA run and split paired-end reads
fasterq-dump SRR1039508 \
    --split-files \
    --threads 4 \
    --outdir $OUTDIR

echo "Download complete"