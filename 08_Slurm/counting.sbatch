#!/bin/bash
#SBATCH --job-name=slurm_counting
#SBATCH --output=workshop_%j.log
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=02:00:00

# 1. Load the necessary modules
module load subread

# 2. Set your paths (Change these to your actual folder paths!)
GTF="PATH/TO/GTF/Homo_sapiens.GRCh38.115.gtf"
BAM_FILES="PATH/TO/STAR/OUTPUTS/*_Aligned.sortedByCoord.out.bam"
OUT_FILE="ASM_Dex_count_${USER}.txt"

# 3. Run featureCounts (using 8 CPUs)
echo "Starting featureCounts..."
featureCounts -T 8 -p \
  -a "$GTF" \
  -o "$OUT_FILE" \
  "$BAM_FILES"