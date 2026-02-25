[Back to Home](../README.md)
## 4. RNA-seq Alignment with STAR

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
>Pre-built reference genome is accessible at **/common/reference/hg38/release_115/** TODO.
-----------

### Star alignment with STAR
In this step, RNA-seq reads are aligned to the human reference genome using STAR.

```bash
salloc --pty --nodes=1 --ntasks=1 --mem=8G --cpus-per-task=8 --time=01:00:00 bash
```

```bash
ml star
```

**Create an output directory:**
```
mkdir ./STAR_outputs
```

**Run the following command to align the reads to the reference genome:**
```bash
STAR --runThreadN 8 \
         --genomeDir /PATH/TO/STAR_INDEX \
         --readFilesIn /PATH/TO/READS/${SAMPLE}_1.fastq.gz /PATH/TO/READS/${SAMPLE}_2.fastq.gz \
         --readFilesCommand zcat \
         --outFileNamePrefix /PATH/TO/OUTPUT/${SAMPLE}_ \
         --outSAMtype BAM SortedByCoordinate \
         --outSAMunmapped Within \
	     --outSAMattributes Standard \
         --quantMode GeneCounts TranscriptomeSAM
```
> Run this for all 4 samples separately!


------------
|Previous|Home|Next|
|--------|----|----|
|[Trimming](../03_trimming/)|[Home](../README.md)|[Counting](../05_counting/counting.md)|
     
