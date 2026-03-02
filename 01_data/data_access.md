[Back to Home](../README.md)
## 1. Data Download

**Dataset:** Airway smooth muscle cell RNA-seq ([Himes et al.](https://pubmed.ncbi.nlm.nih.gov/24926665/))
**GEO Accession:** [GSE52778](https://www.ncbi.nlm.nih.gov/Traces/study/?acc=PRJNA229998&o=acc_s%3Aa)  

This dataset contains RNA-seq data from human airway smooth muscle (hASM) cells treated with **Dexamethasone (Dex)** and control conditions. It provides a simple, biologically relevant system to explore **differential expression (DE)** analyses.

### Biological Relevance
- Treatment response in a human cell model  
- Simple control vs treated experimental design  
- Ideal for presenting DE analysis concepts

### Dataset Size & Simplicity
- Total samples: **4 RNA-seq datasets**  
  - 4 cell lines, treated vs untreated  
- Small enough for hands-on HPC exercises, but biologically meaningful

### Sample Table
| Accession  | Group     |
| ---------- | --------- |
| SRR1039508 | Untreated |
| SRR1039512 | Untreated |
| SRR1039509 | Treated   |
| SRR1039517 | Treated   |

---


## Data download steps
**Open HPC interactive shell:**
```bash
salloc --nodes=1 --ntasks=1 --cpus-per-task=4 --mem=16G --time=02:00:00 bash
```

**Environment setup, load necessary tools:**
```bash
module load sratoolkit
OR
ml sratoolkit
```

**Download data in parallel - Example:**
```bash
# Inspect the list of SRA accessions
cat /common/bioinformatics-hpc/01_data/sra_accessions.txt

# Download the reads for each SRA accession
while read sra
do
    fasterq-dump $sra \
    --split-files \
    --threads 4 \
    --outdir /common/workshop_data/raw_data
done < /common/bioinformatics-hpc/01_data/sra_accessions.txt
```
**Compression of FASTQ files:**
```bash
for file in /common/workshop_data/raw_data/*.fastq
do
  gzip -c "$file" > /common/workshop_data/raw_gzip/$(basename "$file").gz
done
```

>Important: due to long downloading times, raw fastq files are shared in a common directory: ```/common/workshop_data/raw_data``` and ```/common/workshop_data/raw_gzip``` for the compressed files!

**Exercise:**
Look at the downloaded files and investigate:
1. what does the -c tag do in the gzip command?
2. how to keep the original files after compression?
3. files sizes before and after compression?
4. what does the ```--split-files``` parameter change?
5. how can you "take a look" at the compressed files?
6. number of reads in each file?

<details><summary>Answers</summary>

1. The `-c` tag in the gzip command tells gzip to write the compressed output to standard output (stdout) instead of creating a .gz file. This allows you to redirect the compressed data to a specific location or file name using the `>` operator.

2. Use the `-k` option.

3. `du -sh /common/workshop_data/raw_data/*.fastq; du -sh /common/workshop_data/raw_gzip/*.fastq.gz`

4. Splits into paired-end files: _1 and _2 for forward and reverse reads, respectively.

5. Use `zcat` or `gunzip -c` with head to read compressed files without decompressing them first.

6. Use `zcat file.fastq.gz | wc -l` and use a calculator; or `seqkit stats file.fastq.gz` to get read counts directly (but takes ~3 min).

```
processed files:  8 / 8 [======================================] ETA: 0s. done
file                                                  format  type    num_seqs        sum_len  min_len  avg_len  max_len
/common/workshop_data/raw_gzip/SRR1039508_1.fastq.gz  FASTQ   DNA   22,935,521  1,444,937,823       63       63       63
/common/workshop_data/raw_gzip/SRR1039508_2.fastq.gz  FASTQ   DNA   22,935,521  1,444,937,823       63       63       63
/common/workshop_data/raw_gzip/SRR1039509_1.fastq.gz  FASTQ   DNA   21,155,707  1,332,809,541       63       63       63
/common/workshop_data/raw_gzip/SRR1039509_2.fastq.gz  FASTQ   DNA   21,155,707  1,332,809,541       63       63       63
/common/workshop_data/raw_gzip/SRR1039512_1.fastq.gz  FASTQ   DNA   28,136,282  1,772,585,766       63       63       63
/common/workshop_data/raw_gzip/SRR1039512_2.fastq.gz  FASTQ   DNA   28,136,282  1,772,585,766       63       63       63
/common/workshop_data/raw_gzip/SRR1039517_1.fastq.gz  FASTQ   DNA   34,298,260  2,160,790,380       63       63       63
/common/workshop_data/raw_gzip/SRR1039517_2.fastq.gz  FASTQ   DNA   34,298,260  2,160,790,380       63       63       63
```

</details>


------------------
|Previous|Home|Next|
|--------|----|----|
|[Pre-training](../00_pretraining/pretraining.md)|[Home](../README.md)|[Quality Control](../02_QC/quality_control.md)