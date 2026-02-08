## 1. Data Download

**Dataset:** Airway smooth muscle cell RNA-seq ([Himes et al.](https://pubmed.ncbi.nlm.nih.gov/24926665/))
**GEO Accession:** [GSE52778](https://www.ncbi.nlm.nih.gov/Traces/study/?acc=PRJNA229998&o=acc_s%3Aa)  

This dataset contains RNA-seq data from human airway smooth muscle (hASM) cells treated with **Dexamethasone (Dex)** and control conditions. It provides a simple, biologically relevant system to explore **differential expression (DE)** analyses.

### Biological Relevance
- Treatment response in a human cell model  
- Simple control vs treated experimental design  
- Ideal for presenting DE analysis concepts

### Dataset Size & Simplicity
- Total samples: **8 RNA-seq datasets**  
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
srun --pty --nodes=1 --ntasks=1 --cpus-per-task=4 --mem=16G --time=02:00:00 bash
```

**Download data in paralell:**
```bash
while read sra
do
    fasterq-dump $sra \
    --split-files \
    --threads 4 \
    --outdir $SCRATCH/$USER/raw_data
done < sra_accession.txt
```
**Compress FASTQ files:**
```bash 
gzip $SCRATCH/$USER/raw_data/*.fastq 
```

**Excercies:**
Look at the downloaded files and investigate:
- files sizes before and after comperssion?
- what happened after ```split-files```?
- 
