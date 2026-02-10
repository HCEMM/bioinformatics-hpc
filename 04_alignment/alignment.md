[Back to Home](../README.md)
## 4. RNA-seq Alignment with STAR

<details><summary><strong>Conda Enviroment Setup</strong></summary>

### Enviroment setup
Load Miniconda:
```bash
module load miniconda3
OR
ml miniconda3
```
Check:
```bash
conda --version
    conda 25.11.1
```

Create our environment:
```bash
conda create -f bioinfo-hpc.yml
```

Activate environment:
```bash
conda activate bioinfo-hpc
```

<details><summary>Problems</summary>

If conda environment is not activated, try:
```bash
/opt/miniconda3/bin/conda init bash
source ~/.bashrc
```
then try activating the environment again!

</details>
</details>

--------------

In this section, we will align trimmed RNA-seq reads to the human reference genome using **STAR** (**S**pliced **T**ranscripts **A**lignment to a **R**eference). The output will be **sorted BAM files**, suitable for downstream quantification and differential expression analysis.

### Prepare Reference Genome Index

Before alignment, STAR requires a pre-built genome index. If you don’t have one, build it (one-time step):

**DON'T RUN**
```bash
STAR --runThreadN 8 \
     --runMode genomeGenerate \
     --genomeDir $SCRATCH/$USER/STAR_index \
     --genomeFastaFiles /path/to/human_genome.fa \
     --sjdbGTFfile /path/to/annotations.gtf \
     --sjdbOverhang 100
```
>Pre-built reference genome is accessible at **/data/indexes/etc/TODO**.
-----------

### Star alignment with STAR
In this step, RNA-seq reads are aligned to the human reference genome using STAR.
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


------------
|Previous|Home|Next|
|--------|----|----|
|[Trimming](../03_trimming/)|[Home](../README.md)|[Counting](../05_counting/counting.md)|
     
