[Back to Home](../README.md)
## Differential Expression Analysis in R using limma
**What is limma?**

**limma** (Linear Models for Microarray and RNA-seq Data) is an [R/Bioconductor package](https://bioconductor.org/packages/release/bioc/html/limma.html) used to identify differentially expressed genes between experimental conditions. For RNA-seq count data, limma is typically used together with the ```voom()``` function, which transforms raw counts into log2-counts per million (logCPM) with precision weights.

### Limma will:
- Normalize data
- Model gene expression
- Test for differences between groups
- Output statistically significant genes

### Basic *limma* Workflow

1. Load count data (*featureCounts output*)
2. Define experimental groups (Untreated vs. Dexamethasone)
3. Create design matrix
4. Apply ```voom``` transformation
5. Fit linear model
6. Extract differentially expressed genes



## Perform statistical differential expression analysis

```bash
salloc --nodes=1 --ntasks=1 --cpus-per-task=4 --mem=16G --time=02:00:00 bash
```

```bash
ml r-base64 r-limma r-biobase

Rscript /common/workshop_data/scripts/limma_analysis.R ./workshop_results/featureCounts/ASM_Dex_count.txt /common/workshop_data/reference/hg38/release_115/gene_names.gtf ./workshop_results/limma_results/
```

>Copy the resulting *pdf* files to your computer and, interpret the results!

**How would you show 20 IDs on the volcano plot?**

First, copy the R script to your home directory:
```bash
cp /common/workshop_data/scripts/limma_analysis.R ~/
```

<details><summary>Expected output</summary>

Edit the R script as follows:

```R
pdf(file.path(outdir, "2_volcano_plot.pdf"))
volcanoplot(fit, coef=2, main="Volcano Plot", highlight=20,
            names=results$Symbol[match(rownames(fit), results$ID)])
abline(h=-log10(0.05), col="red", lty=2)
dev.off()
```

</details>

-------------------
|Previous|Home|Next|
|--------|----|----|
|[Counting](../05_counting/counting.md)|[Home](../README.md)|[Differential Expression Analysis](../08_Slurm/SLURM.md)|