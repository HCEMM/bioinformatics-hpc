[Back to Home](../README.md)
## SLURM: Job Scheduling on HPC

This section covers SLURM (Simple Linux Utility for Resource Management), the workload manager used on many high-performance computing clusters.

SLURM allows users to:
- Request computational resources
- Submit batch jobs
- Run interactive sessions
- Monitor job status
- Manage parallel workloads efficiently

Instead of running heavy computations on login nodes, SLURM schedules jobs on compute nodes, ensuring fair resource usage and system stability.

Typical workflow:
- Request resources (salloc or sbatch)
- Load required modules
- Run analysis
- Collect outputs
- Exit session

Understanding SLURM is essential for reproducible and scalable bioinformatics analyses on HPC systems.

[Working in an HPC environment](https://hbctraining.github.io/Intro-to-bulk-RNAseq/lessons/03_working_on_HPC.html) (*External link*)

## HPC cluster overvirview
![HPC cluster](../static/figures/08_compute_cluster.png)

*Image source: HBCTraining*

## 1. Data download

Edit ```data_access.sbatch``` file to start the data download for ```SRR1039508```
- Specify the output folder path!

<details><summary><strong>data_access.sbatch</strong></summary>

```bash
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
```
</details>

>------------------

**Submit your first job!**
```bash
sbatch data_access.sbatch
```

**See running jobs**
```bash
squeue

OR 

squeue -u {YOUR_USERNAME}
```

**Cancel the jobs!**
```bash
scancel 123456 	# JOBID

squeue			# check status
```


## 2. FastQC

**Modify and run the quality control for all fastq files!**
In the ```qc.sbatch``` file:
- Change the job-name
- Specify the CPUs
- Check all parameters, submit the job
<details><summary><strong>qc.sbatch</strong></summary>

```bash
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
```
</details>

**Open the output and error files**
- What is the output showing? 
- Were there any error messages during the run?

## 3. Trimming

In this step, we will transition from running a single command to using Job Arrays. This allows us to submit one script that Slurm will automatically replicate for each of our 4 samples, assigning each a unique ```${SLURM_ARRAY_TASK_ID}```.
**Modify the ```trimming.sbatch``` file to process all samples as separate sub-jobs!**
1. Open the file ```nano trimming.sbatch```
2. Add the Array SBATCH header ```#SBATCH --array=0-3``` to tell SLURM to launch 4 tasks
3. Define the list of Samples
4. Map the TASK IDs: ```SAMPLE=${SAMPLES[$SLURM_ARRAY_TASK_ID]}``` to ensure each sub-job picks a different file for trimming
5. Update trimmomatic ```input``` and ```output``` folder paths.

<details><summary><strong>trimming.sbatch</strong></summary>

```bash
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
```
</details>

## 4. Alignment
For STAR alignment, instead of running a single SLURM job that loops through all FASTQ files sequentially (which is slow and inefficient), we can use SLURM job arrays. Job arrays allow us to process multiple FASTQ files in parallel, significantly speeding up the alignment step and making better use of cluster resources.

0. Make a new directory for STAR outputs.
1. Locate the file ```star_alignment.sh```.
2. Print the content of the file.
3. Open the script with a file editor:
    - Change the desired parameters:
        - SBATCH ```--job-name```
        - ```/PATH/TO/STAR_IINDEX```
        - ```/PATH/TO/READS```
        - ```/PATH/TO/OUTPUT```
    - Convert the script to a **job array**
        - Add a ```#SBATCH --array=``` line
        - Remove the for loop
        - Use ```$SLURM_ARRAY_TASK_ID``` to select one sample
4. Submit the job with ```sbatch star_alignment.sh```
5. Monitor your job with ```squeue -u $USERNAME``` and look at the output files of your jobs ```ls *.out```

<details><summary><strong>star_alignemnt.sbatch</strong></summary>


```bash
#!/bin/bash

#SBATCH -t 0-2:00 		# hours:minutes runlimit after which job will be killed
#SBATCH -c 8 		# number of cores requested -- this needs to be greater than or equal to the number of cores you plan to use to run your job
#SBATCH --mem 16G
#SBATCH --job-name STAR_YOURNAME 		# Job name
#SBATCH -o %j.out			# File to which standard out will be written
#SBATCH -e %j.err 		# File to which standard err will be written

for R1 in /PATH/TO/READS/*_1.fastq.gz
do
    # Extract sample name
    SAMPLE=$(basename ${R1} _1.fastq.gz)

    echo "Processing sample: ${SAMPLE}"

    STAR --runThreadN 8 \
         --genomeDir /PATH/TO/STAR_INDEX \
         --readFilesIn /PATH/TO/READS/${SAMPLE}_1.fastq.gz /PATH/TO/READS/${SAMPLE}_2.fastq.gz \
         --readFilesCommand zcat \
         --outFileNamePrefix /PATH/TO/OUTPUT/${SAMPLE}_ \
         --outSAMtype BAM SortedByCoordinate \
         --outSAMunmapped Within \
	     --outSAMattributes Standard \
         --quantMode GeneCounts TranscriptomeSAM

    echo "Finished sample: ${SAMPLE}"
    echo "----------------------------------"
done

echo "All samples completed."
```

For all the available options, see [STAR's documentation](https://github.com/alexdobin/STAR/blob/master/doc/STARmanual.pdf).

</details>

## 5. Counting

<details><summary><strong>counting.sbatch</strong></summary>

```bash
#!/bin/bash
#SBATCH --job-name=RNAseq_Workshop
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
```

</details>

## 6. DEA

<details><summary><strong>limma_analysis.sbatch</strong></summary>

```R
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
```