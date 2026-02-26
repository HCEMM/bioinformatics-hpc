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
salloc --nodes=1 --ntasks=1 --cpus-per-task=4 --mem=16G --time=02:00:00 bash
```

```bash
ml r-base64 r-limma r-biobase
```

**Make a new Rscript file:**
```bash
nano limma_analysis.R
```

**Copy and paste the script below:**
<details><summary>Rscript</summary>

```R
library(limma)

options(echo=F)
# 1. SETUP: Get input files
args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 2) stop("Usage: Rscript analysis.R <counts.txt> <gtf_file.gtf>")

# 2. LOAD DATA (featureCounts format)
data <- read.delim(args[1], comment.char="#", row.names=1)
counts <- data[, 6:ncol(data)] 

# RENAME COLUMNS: Simplify long file paths to just the SRR ID
colnames(counts) <- gsub(".*(SRR[0-9]+).*", "\\1", colnames(counts))
short_names <- colnames(counts)

# 3. MAP NAMES Ensmbl IDs to Gene names
# This keeps it simple: it pulls ID and Name directly
gtf <- readLines(args[2])
gtf_genes <- gtf[grep('gene_id "([^"]+)";.*gene_name "([^"]+)";', gtf)]
ids <- gsub('.*gene_id "([^"]+)";.*', '\\1', gtf_genes)
syms <- gsub('.*gene_name "([^"]+)";.*', '\\1', gtf_genes)
gene_map <- unique(data.frame(ID=ids, Symbol=syms))
gene_map <- gene_map[!duplicated(gene_map$ID), ]

# 4. PREPARE: log-CPM and Groups (set up factor groups based on the column order in the count.txt file)
group <- factor(c("Control", "Dex", "Control", "Dex"))
# Convert counts to log2-scale
logCPM <- log2(t(t(counts + 0.5) / (colSums(counts) + 1) * 1e6))

# 5. ANALYSIS: The Limma Pipeline, fitting Bayesean distribution function
design <- model.matrix(~group)
fit <- lmFit(logCPM, design)
fit <- eBayes(fit, trend=TRUE)

# 6. MERGE: Get results and add the Symbols
results <- topTable(fit, coef=2, number=Inf)
results$ID <- rownames(results)
results <- merge(results, gene_map, by.x="ID", by.y="ID", all.x=TRUE)
results$Symbol <- ifelse(is.na(results$Symbol), results$ID, results$Symbol)
results <- results[order(results$adj.P.Val), ]
write.csv(results, "final_results.csv", row.names=FALSE)

#####--- THE SIMPLIFIED PLOTS --- #####
# 7. PLOT: PCA (Using limma's plotMDS)
pdf("1_pca_plot.pdf")
plotMDS(logCPM, labels = short_names, col=as.numeric(group), pch=19, main="PCA - Sample Clustering")
legend("topleft", legend=levels(group), col=1:2, pch=19)
dev.off()

# 8. PLOT: Volcano (Using limma's volcanoplot)
pdf("2_volcano_plot.pdf")
volcanoplot(fit, coef=2, main="Volcano Plot", highlight=10, names=results$Symbol[match(rownames(fit), results$ID)])
abline(h=-log10(0.05), col="red", lty=2)
dev.off()

# 9. PLOT: Boxplots of Top Genes
pdf("3_top_genes_boxplots.pdf")
par(mfrow=c(2,2))
for (i in 1:12) {
  gene_id <- results$ID[i]
  boxplot(logCPM[gene_id, ] ~ group, main=results$Symbol[i], 
          col=c("skyblue", "orange"), ylab="Relative Expression (log2 CPM)")
  stripchart(logCPM[gene_id, ] ~ group, add=TRUE, vertical=TRUE, pch=21, bg="white")
}
dev.off()

# 10. PLOT: Sample Distance Heatmap
# This helps see if "Control" samples cluster together with Eucledian distance
sampleDists <- as.matrix(dist(t(logCPM)))

pdf("4_sample_distance_heatmap.pdf")
heatmap(sampleDists, 
        main="Sample Euclidean Distance (Similarity)",
        symm = TRUE,
        col = cm.colors(256),
        margins = c(10,10))
dev.off()

# 11. PLOT: Top 50 Genes Heatmap
# This shows the "Global" pattern of expression
top50_ids <- results$ID[1:50]
heatmap_matrix <- logCPM[top50_ids, ]

# Replace IDs with Symbols for the heatmap labels
rownames(heatmap_matrix) <- results$Symbol[1:50]

RdBu <- colorRampPalette(c("blue", "white", "red"))(256)

pdf("5_global_heatmap.pdf")
heatmap(as.matrix(heatmap_matrix), 
        main="Top 50 Differentially Expressed Genes",
        Colv = NA,
        scale = "row",       # Standardizes rows so we see relative changes
        col = RdBu, 
        margins = c(10,5))
dev.off()

cat("\nDone! Results saved to CSV and 5 PDFs generated.\n")
```
</details>

---------------
**Run the script:**
```bash
Rscript limma_analysis.R /path/to/featureCounts/output/ASM_Dex_count_USER.txt /common/workshop_data/reference/hg38/release_115/gene_names.gtf
```

>Copy the resulting *pdf* files to your computer and, interpret the results!