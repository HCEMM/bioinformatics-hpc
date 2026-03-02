[Back to Home](../README.md)
## 4. RNA-seq Alignment with STAR


In this section, we will align trimmed RNA-seq reads to the human reference genome using **STAR** (**S**pliced **T**ranscripts **A**lignment to a **R**eference). The output will be **sorted BAM files**, suitable for downstream quantification and differential expression analysis.

### Prepare Reference Genome Index

Before alignment, STAR requires a pre-built genome index. If you don’t have one, build it (one-time step):

**DON'T RUN**
```bash
ml star

STAR --runThreadN 16 \
     --runMode genomeGenerate \
     --genomeDir /common/workshop_data/index \
     --genomeFastaFiles /common/workshop_data/reference/hg38/release_115/Homo_sapiens.GRCh38.dna.primary_assembly.fa \
     --sjdbGTFfile /common/workshop_data/reference/hg38/release_115/gene_names.gtf \
     --sjdbOverhang 100
```
>Reference genome is accessible at **/common/workshop_data/reference/hg38/release_115/**

>Pre-built index is located at **/common/workshop_data/index/**
-----------

### Star alignment with STAR
In this step, RNA-seq reads are aligned to the human reference genome using STAR.

```bash
salloc --nodes=1 --ntasks=1 --mem=8G --cpus-per-task=16 --time=01:00:00
```

```bash
ml star
```

**Create the output directory:**
```
mkdir ./workshop_results/STAR_outputs
```

**Run the following command to align the reads to the reference genome:**
```bash
SAMPLE=SRR1039508
STAR --runThreadN 16 \
         --genomeDir /common/workshop_data/index \
         --readFilesIn /common/workshop_data/raw_gzip/${SAMPLE}_1.fastq.gz /common/workshop_data/raw_gzip/${SAMPLE}_2.fastq.gz \
         --readFilesCommand zcat \
         --outFileNamePrefix ./workshop_results/STAR_outputs/${SAMPLE}_ \
         --outSAMtype BAM SortedByCoordinate \
         --outSAMunmapped Within \
	     --outSAMattributes Standard \
         --quantMode GeneCounts TranscriptomeSAM
```
> **Run this for all 4 samples separately! $SAMPLE names are:**

| Accession  | Group     |
| ---------- | --------- |
| SRR1039508 | Untreated |
| SRR1039512 | Untreated |
| SRR1039509 | Treated   |
| SRR1039517 | Treated   |


*How to run all samples in a single command?*

<details><summary>Solution</summary>

```bash
for SAMPLE in SRR1039508 SRR1039512 SRR1039509 SRR1039517; do
  STAR --runThreadN 16 \
       --genomeDir /common/workshop_data/index \
       --readFilesIn /common/workshop_data/raw_gzip/${SAMPLE}_1.fastq.gz /common/workshop_data/raw_gzip/${SAMPLE}_2.fastq.gz \
       --readFilesCommand zcat \
       --outFileNamePrefix ./workshop_results/STAR_outputs/${SAMPLE}_ \
       --outSAMtype BAM SortedByCoordinate \
       --outSAMunmapped Within \
        --outSAMattributes Standard \
       --quantMode GeneCounts TranscriptomeSAM
done
```
</details>

------------
|Previous|Home|Next|
|--------|----|----|
|[Trimming](../03_trimming/)|[Home](../README.md)|[Counting](../05_counting/counting.md)|
     
