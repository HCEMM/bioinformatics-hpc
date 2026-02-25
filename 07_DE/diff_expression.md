DE analysis - R
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
salloc --pty --nodes=1 --ntasks=1 --cpus-per-task=4 --mem=16G --time=02:00:00 bash
```

```bash
ml r-base64 r-limma r-biobase
```

**Make a new Rscript file:**
```bash
nano limma_analysis.R
```

**Copy and paste the script below:***
```R
install.packages("BiocManager")
BiocManager::install("edgeR")

library(limma)
library(edgeR)

# Load counts (remove annotation columns if needed)
counts <- read.delim("counts.txt", comment.char="#", row.names=1)
counts <- counts[,6:ncol(counts)]   # adjust if needed

group <- factor(c("Control","Control","Treatment","Treatment"))

dge <- DGEList(counts=counts, group=group)
dge <- calcNormFactors(dge)

design <- model.matrix(~group)
v <- voom(dge, design, plot=FALSE)

fit <- lmFit(v, design)
fit <- eBayes(fit)

results <- topTable(fit, coef=2, number=Inf)

write.csv(results, "limma_results.csv")

# Volcano plot
pdf("volcano_plot.pdf")
volcanoplot(fit, coef=2, highlight=10, names=rownames(counts))
dev.off()

# Barplot of top 10 genes
top10 <- head(results, 10)

pdf("top10_barplot.pdf")
barplot(top10$logFC,
        names.arg=rownames(top10),
        las=2,
        main="Top 10 Differentially Expressed Genes",
        ylab="log2 Fold Change")
dev.off()

#get adj-p-values also TODO
#PCA also
#A heatmap also
#Distance between samples (calc distance matrix in deseq2)
```

```
Rscript limma_analysis.R
```

FileZilla will be used