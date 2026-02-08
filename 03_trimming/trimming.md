### 3. Trimming
### Iterating through the fatsq files and doing the trimming
Trimming is the process of removing low quality read sequences due to missed detections based on Q-value scores in FASTQ files. It is an optional step after QC, to move further with only good quality data.

**Example:**
![Trimming before and after](../static/figures/03_trimming.png)

----------------
> Luckily our data is high quality FASTQ files from Illumina Hiseq instruments with overall Q-score > 30 in all positions for all files (see MultiQC outputs).

To perform trimming, we use ```Trimmomatic```, allowing many options to trim and modify our FASTQ files.

Perform the trimming of the file ```SRR1039509``` based on the following general scheme of Trimmomatic. (See ```--help``` or the [User manual](http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/TrimmomaticManual_V0.32.pdf) for further information)

```
srun --pty --nodes=1 --ntasks=1 --mem=8G --cpus-per-task=8 -
-time=01:00:00 bash
```

```bash
trimmomatic PE -threads <number_of_threads> \
  <forward_reads_input> <reverse_reads_input> \
  <forward_reads_paired_output> <forward_reads_unpaired_output> \
  <reverse_reads_paired_output> <reverse_reads_unpaired_output> \
  ILLUMINACLIP:<adapter_file>:<seed_mismatches>:<palindrome_clip>:<simple_clip> \
  SLIDINGWINDOW:<window_size>:<required_quality> \
  LEADING:<leading_quality> \
  TRAILING:<trailing_quality> \
  MINLEN:<minimum_length>
```

**Perform GC again and compare the files before and after trimming!**

```bash
fastqc -t 4 -o /$USER/03_trimming/trimmed \
    $SCRATCH/$USER/trimmed_data/*.fastq.gz

multiqc $SCRATCH/$USER/raw_data $SCRATCH/$USER/trimmed_data -o ./
```

-------------

<details><summary>Solution</summary>

```bash
trimmomatic PE -threads 8 \
  sample_1.fastq.gz sample_2.fastq.gz \
  sample_1.trimmed.fastq.gz sample_1.unpaired.fastq.gz \
  sample_2.trimmed.fastq.gz sample_2.unpaired.fastq.gz \
  ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 \
  SLIDINGWINDOW:4:20 \
  LEADING:3 \
  TRAILING:3 \
  MINLEN:50


trimmomatic PE -threads 8 $SCRATCH/raw_gzip/SRR1039509_1.fastq.gz  $SCRATCH/raw_gzip/SRR1039509_2.fastq.gz $SCRATCH/trimmed_data/SRR1039509_1.trimmed.fastq.gz $SCRATCH/trimmed_data/SRR1039509_1.unpaired.fastq.gz $SCRATCH/trimmed_data/SRR1039509_2.trimmed.fastq.gz $SCRATCH/trimmed_data/SRR1039509_2.unpaired.fastq.gz ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 SLIDINGWINDOW:4:20 LEADING:3 TRAILING:3 MINLEN:50
```

</details>

<details><summary>Expected output</summary>

```bash
Using PrefixPair: 'TACACTCTTTCCCTACACGACGCTCTTCCGATCT' and 'GTGACTGGAGTTCAGACGTGTGCTCTTCCGATCT'
ILLUMINACLIP: Using 1 prefix pairs, 0 forward/reverse sequences, 0 forward only sequences, 0 reverse only sequences
Quality encoding detected as phred33
Input Read Pairs: 21155707 Both Surviving: 18912466 (89.40%) Forward Only Surviving: 1218056 (5.76%) Reverse Only Surviving: 584666 (2.76%) Dropped: 440519 (2.08%)
TrimmomaticPE: Completed successfully
```

</details>

