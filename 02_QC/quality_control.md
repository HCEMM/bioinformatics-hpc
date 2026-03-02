[Back to Home](../README.md)
## 2. Quality check (QC)


> We have to check the fastq files quality before proceeding!

List the first 4 lines of all fastq files.

<details><summary>Solution</summary>

```bash
head -4 /common/workshop_data/raw_data/*.fastq
```

</details>

```
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

### Phred-score system
The line 4 has characters encoding the quality of each nucleotide in the read. The legend below provides the mapping of quality scores (Phred = ASCII - 33) to the quality encoding characters. *Different quality encoding scales exist (differing by offset in the ASCII table), but note the most commonly used one is fastqsanger, which is the scale outputed by Illumina since mid-2011.*

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

Q = -10 x log10(Perror) --> Perror = 10^-(39/10) --> 0.0126% chance that the nucleotide base is wrong.

----------------
### FastQC tool
**FastQC is used to check the per-base quality of FASTQ files.**

**Start interactive shell:**
```bash
salloc --nodes=1 --ntasks=1 --mem=8G --cpus-per-task=16 --time=10:00:00
```

**Load necessary tools:**
```bash
ml fastqc
```

**Run quality check for all files:**
```bash
mkdir -p workshop_results/fastqc
fastqc /common/workshop_data/raw_gzip/*.fastq.gz -o ./workshop_results/fastqc	#Directing output to the current directory
```

> **We can reduce the analysis times using multiple threads!**
-----------------
Use the ```--help``` option to see how to set multiple threads for FastQC! (set 4 threads)


<details><summary>Solution</summary>

```bash
fastqc -t 16 /common/workshop_data/raw_gzip/*.fastq.gz -o ./workshop_results/fastqc
```
>All 8 files are now processed parallely!
</details>


----------------
### MultiQC tool
**Collect and combine files with MultiQC easily:**
```bash
ml py-multiqc
ml py-pydantic
multiqc ./workshop_results/fastqc --outdir ./workshop_results/multiqc
```
>Did you need to create the output folder?

**Examine output:**
![MultiQC](../static/figures/02_MultiQC.png)

**Exercise:**

Some questions to think about:
1. If Q30 = 0.1% error, what is Q20 error rate? 
```
Formula: Q = -10 x log10(Perror) --> Perror = 10^(-Q/10)
```
2. Why is Q-score logarithmic?
3. If last 10 bases are always lower quality - what does that suggest?
4. Why might GC-rich regions show lower quality?

<details><summary>Answers</summary>

1. Each +10 = 10× lower error.
```
Q20 → 1% error
Q30 → 0.1% error
Q40 → 0.01% error
```

2. Human perception handles log scales better; Error rates span multiple orders of magnitude.

3. Illumina chemistry degrades over cycles.

4. GC regions can form secondary structures, affecting sequencing efficiency.

</details>

-------------

|Previous|Home|Next|
|--------|----|----|
|[Data Access](../01_data/data_access.md)|[Home](../README.md)|[Trimming](../03_trimming/trimming.md)