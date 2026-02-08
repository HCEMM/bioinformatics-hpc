## 4. RNA-seq Alignment with STAR

In this section, we will align trimmed RNA-seq reads to the human reference genome using **STAR** (**S**pliced **T**ranscripts **A**lignment to a **R**eference). The output will be **sorted BAM files**, suitable for downstream quantification and differential expression analysis.

### Prepare Reference Genome Index

Before alignment, STAR requires a pre-built genome index. If you don’t have one, build it (one-time step):

```bash
STAR --runThreadN 8 \
     --runMode genomeGenerate \
     --genomeDir $SCRATCH/$USER/STAR_index \
     --genomeFastaFiles /path/to/human_genome.fa \
     --sjdbGTFfile /path/to/annotations.gtf \
     --sjdbOverhang 100
```
*Note:* Have to do it once, everyone use it from a common dir maybe.... **TODO**

