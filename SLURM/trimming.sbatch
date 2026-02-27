#!/bin/bash
#SBATCH --job-name=trim_array
#SBATCH --output=trim_logs/trim_%A_%a.out
#SBATCH --error=trim_logs/trim_%A_%a.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --array=0-3

# 1. Load the module
module load trimmomatic

# 2. Define your sample names (Update these to match your actual file prefixes)
SAMPLES=("SRR1039508" "SRR1039509" "SRR1039512" "SRR1039517")

# Get the specific sample for this task
SAMPLE=${SAMPLES[$SLURM_ARRAY_TASK_ID]}

# 3. Setup Directories
INPUT_DIR="path/to/input/files"
OUTPUT_DIR="path/to/output/dir"
ADAPTERS="TruSeq3-PE.fa"

mkdir -p $OUTPUT_DIR
mkdir -p trim_logs

# 4. Run Trimmomatic
# Note: This assumes your files are named SampleName_R1.fastq.gz
trimmomatic PE -threads $SLURM_CPUS_PER_TASK \
    ${INPUT_DIR}/${SAMPLE}_1.fastq.gz ${INPUT_DIR}/${SAMPLE}_2.fastq.gz \
    ${OUTPUT_DIR}/${SAMPLE}_1_trimmed.fastq.gz ${OUTPUT_DIR}/${SAMPLE}_1_unpaired.fastq.gz \
    ${OUTPUT_DIR}/${SAMPLE}_2_trimmed.fastq.gz ${OUTPUT_DIR}/${SAMPLE}_2_unpaired.fastq.gz \
    ILLUMINACLIP:${ADAPTERS}:2:30:10 \
    SLIDINGWINDOW:4:15 \
    LEADING:3 \
    TRAILING:3 \
    MINLEN:36

echo "Finished trimming $SAMPLE