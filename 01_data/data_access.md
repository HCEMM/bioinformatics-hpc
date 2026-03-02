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
gzip /common/workshop_data/raw_data/*.fastq
```

>Important: due to long downloading times, raw fastq files are shared in a common directory: ```/common/workshop_data/raw_data``` and ```/common/workshop_data/raw_gzip``` for the compressed files!

**Exercise:**
Look at the downloaded files and investigate:
- files sizes before and after compression?
- what does the ```--split-files``` parameter change?
- how can you read the compressed files?

------------------
|Previous|Home|Next|
|--------|----|----|
|[Pre-training](../00_pretraining/pretraining.md)|[Home](../README.md)|[Quality Control](../02_QC/quality_control.md)