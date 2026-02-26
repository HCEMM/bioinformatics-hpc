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

## STAR
We use a single SLURM job that loops through all FASTQ files in a selected folder and processes them sequentially.

0. Make a new directory for STAR outputs.
1. Locate the file ```star_alignment.sh```.
2. Print the content of the file.
3. Open the script with a file editor and change the desired parameters:
     - SBATCH ```--job-name```
     - ```/PATH/TO/STAR_IINDEX```
     - ```/PATH/TO/READS```
     - ```/PATH/TO/OUTPUT```
4. Submit the job with ```sbatch star_alignment.sh```
5. Monitor your job with ```squeue -u $USERNAME``` and look at the output files of your job ```$JOBID.out```

<details><summary>star_alignemtn.sh</summary>


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

## Counting
trimmomatic.sh

## DEA
R script