[Back to Home](../README.md)
## 5. Gene-Level Read Counting with featureCounts

After alignment with STAR, we convert BAM files into a **gene count matrix** for differential expression analysis using featureCounts (*from the Subread package*).

This step assigns aligned reads to genes based on genome annotation (GTF).

> GTF file is located in **/common/reference/hg38/release_115/Homo_sapiens.GRCh38.115.gtf**

---------------
### Basic featureCounts Command for Paired-end data

**Start interactive session:**
```bash
salloc --nodes=1 --ntasks=1 --mem=8G --cpus-per-task=8 --time=02:00:00 bash
```

```
ml subread
```

**Run the featureCounts tool:**
```bash
mkdir -p ./workshop_results/featureCounts
featureCounts -T 8 -p \
  -a /common/workshop_data/reference/hg38/release_115/Homo_sapiens.GRCh38.115.gtf \
  -o ./workshop_results/featureCounts/ASM_Dex_count.txt \
  ./workshop_results/STAR_outputs/*_Aligned.sortedByCoord.out.bam
```

<details><summary>Expected output</summary>

The **Count Matrix** contains:
- a gene id (*Ensembl ID*);
- Chromosome Start-End positions
- Strand orientations (+ or -);
- Gene length
- And the raw count values for each FASTQ files

**Example:**
| Gene ID (Ensembl) | Chr | Start | End | Strand | Length (bp) | SRR1039508 | SRR1039509 | SRR1039512 | SRR1039517 |
|------------------|-----|-------|-----|--------|-------------|----------|----------|----------|----------|
| ENSG00000232952  | 1   | 105891739 | 105893517 | + | 1779 | 6 | 2 | 4 | 4 |
| ENSG00000272931  | 1   | 89820174  | 89820868  | - | 695  | 0 | 1 | 0 | 0 |
| ENSG00000224468  | 1   | 183138402 | 183141282 | - | 479  | 32 | 55 | 44 | 86 |
| ENSG00000241318  | 1   | 91534666  | 91535593  | - | 928  | 0 | 2 | 2 | 2 |
| ENSG00000228238  | 1   | 186578279 | 186579299 | + | 1021 | 4 | 4 | 2 | 2 |

>This data will be used for statistical differential expression analysis in R!

</details>


-----------
### Overall quality checks for each step
The following table summarizes general guidelines for what to check at each step of the pipeline.
| Pipeline Step | Tool        | Most Important QC Metric | What It Means | Good Value |
|---------------|-------------|--------------------------|----------------|------------|
| Read Quality  | FastQC      | Per-base Phred Q-score   | Base-call accuracy | Q ≥ 30 |
| Alignment     | STAR        | Mapping rate (%)         | Reads aligned to genome | > 80% |
| Counting      | featureCounts | Assigned reads (%)     | Reads assigned to genes | > 60% |

---------------

**Exercise:**

Some questions to think about:
1. Check the count matrix. What is the structure?
2. How many genes have zero counts in all samples?
3. How to get the genes expressed only in treated?
4. Why longer genes have more counts?

<details><summary>Answers</summary>

1. After the first two header lines, we get this info:
```
| Column Number | Column Name   | Description               |
|---------------|--------------|----------------------------|
| 1             | Geneid       | Ensembl gene ID            |
| 2             | Chr          | Chromosome                 |
| 3             | Start        | Start position             |
| 4             | End          | End position               |
| 5             | Strand       | Strand (+ or -)            |
| 6             | Length       | Gene length (bp)           |
| 7+            | Sample counts| Raw counts per sample file |
```

2. `awk 'NR>2 {sum=0; for(i=7;i<=NF;i++) sum+=$i; if(sum==0) print $1}' ASM_Dex_count.txt | wc -l`

3. `awk 'NR>2 {if(($7==0 && $9==0) && ($8>0 || $10>0)) print $1}' ASM_Dex_count.txt`

4. Because longer genes have more sequence, they are more likely to have reads that align to them, leading to higher counts. This is a common bias in RNA-seq data, which is why normalization methods (like TPM or RPKM) account for gene length.

</details>

------------
|Previous|Home|Next|
|--------|----|----|
|[Alignment](../04_alignment/)|[Home](../README.md)|[Salmon](../06_DE/pseudo_aligner.md)|
     