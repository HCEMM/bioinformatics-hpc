[Back to Home](../README.md)
## 5. Gene-Level Read Counting with featureCounts

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

After alignment with STAR, we convert BAM files into a **gene count matrix** for differential expression analysis using featureCounts (*from the Subread package*).

This step assigns aligned reads to genes based on genome annotation (GTF).

> GTF file is located in /data/reference/hg38/release_115/Homo_sapiens.GRCh38.115.gtf

---------------
### Basic featureCounts Command for Paired-end data

**Start interactive session:**
```bash
srun --pty --nodes=1 --ntasks=1 --mem=8G --cpus-per-task=8 --time=01:00:00 bash
```

**Run the featureCounts tool:**
```bash
featureCounts -T 8 -p \
  -a PATH/TO/GTF/Homo_sapiens.GRCh38.115.gtf \
  -o ASM_Dex_count_<USERNAME>.txt \
  PATH/TO/STAR/OUTPUTS/*_Aligned.sortedByCoord.out.bam
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

