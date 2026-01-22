# bioinformatics-hpc
Cutting-Edge Bioinformatics in a High-Performance Computing Environment

## 0. Enviroment setup
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

## 1. Data download
Airway smooth muscle cell RNA-seq (Himes et al.)

GEO accession: GSE52778 – human airway smooth muscle cells treated with Dexamethasone (Dex) and other conditions (published RNA-seq).

Biological relevance: treatment response in a human cell model — simple control vs treated design, great for DE examples.

Size & simplicity: only 8 total RNA-seq samples (four cell lines, treated vs untreated), not huge but biologically real \
**Access link:** https://www.ncbi.nlm.nih.gov/Traces/study/?acc=PRJNA229998&o=acc_s%3Aa

**Table**:
| Accession  | Group     |
| ---------- | --------- |
| SRR1039508 | Untreated |
| SRR1039512 | Untreated |
| SRR1039509 | Treated   |
| SRR1039517 | Treated   |


----------------
Open HPC interactive shell:
```bash
srun --pty --nodes=1 --ntasks=1 --cpus-per-task=4 --mem=16G --time=02:00:00 bash
```

Download paralell:
```bash
while read sra
do
    fasterq-dump $sra \
    --split-files \
    --threads 4 \
    --outdir $SCRATCH/$USER/raw_data
done < sra_accession.txt
```
Zip files:
```bash 
gzip $SCRATCH/$USER/raw_data/*.fastq 
```

>Questions:
* where to download the files?
* should they just copy from a common dir?
* if we use scratch, every student will have a separate folder?
* use home? (not good)
* how many threads should we allow for download?
* it is really slow with 4 threads, increase or cp from a scratch location or just use simlinks to the files.

## 2. Quality check (QC)
We have to check the fastq files quailty

Look into fastq file:
```fastq
@SRR1039508.1 HWI-ST177:290:C0TECACXX:1:1101:1225:2130 length=63
CATTGCTGATACCAANNNNNNNNGCATTCCTCAAGGTCTTCCTCCTTCCCTTACGGAATTACA
+SRR1039508.1 HWI-ST177:290:C0TECACXX:1:1101:1225:2130 length=63
HJJJJJJJJJJJJJJ########00?GHIJJJJJJJIJJJJJJJJJJJJJJJJJHHHFFFFFD
```
Line meanings:
1. Read information line, always starts with a ```@```
2. The DNA sequence
3. Read info, sometimes same as line 1., always starts with ```+```
4. String of characters, representing quality score for each nucleotide (Phred-score)

<details><summary>Solution</summary>

```bash
head -n 4 SRR1039508.1.fastq
```

</details>

### Phred-score system
The line 4 has characters encoding the quality of each nucleotide in the read. The legend below provides the mapping of quality scores (Phred = ASCII - 33) to the quality encoding characters. *Different quality encoding scales exist (differing by offset in the ASCII table), but note the most commonly used one is fastqsanger, which is the scale output by Illumina since mid-2011.*

```
 Quality encoding: !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHI
                   |         |         |         |         |
    Quality score: 0........10........20........30........40 
```

Each quality score represents the probability that the corresponding nucleotide call is incorrect. This quality score is logarithmically based and is calculated as:

```
Q = -10 x log10(Perror), where P is the probability that a base call is erroneous
```
> e.g. First nucleotide in SRR1039508.1 is Cytosine with ASCII character 'H'. ASCII(H) = 72, Phred-score = 72-33 = 39

Q = -10 x log10(Perror) --> Perror = 10^-(39/10) --> 0.0126% chance that the nucleotide base is worng.

----------------
### FastQC tool
Interactive shell:
```
srun --pty --nodes=1 --ntasks=1 --mem=8G --time=01:00:00 bash
```




