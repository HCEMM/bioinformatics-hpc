#!/bin/bash

#SBATCH -t 0-1:00              # Runtime (D-HH:MM)
#SBATCH -c 4                   # Number of CPU cores
#SBATCH --mem=8G               # Memory
#SBATCH --job-name=limma_USER  # Change USER to your name
#SBATCH -o %j.out              # Standard output
#SBATCH -e %j.err              # Standard error

# Load R module (modify if your cluster uses a different module name)
ml r-base64 r-limma r-biobase

# Run the R script
Rscript ../07_DE/limma_analysis.R \
/path/to/featureCounts/output/ASM_Dex_count_YOUR_USER.txt \
/common/workshop_data/reference/hg38/release_115/gene_names.gtf

echo "limma analysis completed."