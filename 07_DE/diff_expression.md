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

**Exercise:**

1. How would you show 20 IDs on the volcano plot?
2. Why adjust p-values?
3. Are two samples enough for a robust DE analysis? What are the limitations of this dataset?
4. Why represent gene expression changes as log2 fold changes instead of raw fold changes?

<details><summary>Answers</summary>

1. First, copy the R script to your home directory: `cp /common/workshop_data/scripts/limma_analysis.R ~/`

Then, edit as such:
```R
pdf(file.path(outdir, "2_volcano_plot.pdf"))
volcanoplot(fit, coef=2, main="Volcano Plot", highlight=20,
            names=results$Symbol[match(rownames(fit), results$ID)])
abline(h=-log10(0.05), col="red", lty=2)
dev.off()
```

2. Multi-testing will increase the chance of false positives, as multiple comparisons are being made [relevant xkcd](https://xkcd.com/882/).

3. Two samples per group is not ideal for robust DE analysis, as it limits the ability to estimate variability and can lead to false positives or negatives. With only two samples, it's difficult to distinguish true biological differences from random variation.

4. Log2 fold changes are used because they provide a symmetric scale for up- and down-regulation, making it easier to interpret changes in gene expression. A log2 fold change of 1 means a doubling of expression, while -1 means halving, which is more intuitive than raw fold changes that can be skewed by large values.

</details>

-------------------
|Previous|Home|Next|
|--------|----|----|
|[Counting](../05_counting/counting.md)|[Home](../README.md)|[Differential Expression Analysis](../08_Slurm/SLURM.md)|