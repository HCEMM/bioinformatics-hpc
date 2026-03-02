library(limma)

options(echo=F)

# 1. SETUP: Get input files
args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 3) {
  stop("Usage: Rscript analysis.R <counts.txt> <gtf_file.gtf> <output_directory>")
}

counts_file <- args[1]
gtf_file <- args[2]
outdir <- args[3]

# Create output directory if it doesn't exist
if (!dir.exists(outdir)) {
  dir.create(outdir, recursive = TRUE)
}

# 2. LOAD DATA (featureCounts format)
data <- read.delim(counts_file, comment.char="#", row.names=1)
counts <- data[, 6:ncol(data)] 

# RENAME COLUMNS
colnames(counts) <- gsub(".*(SRR[0-9]+).*", "\\1", colnames(counts))
short_names <- colnames(counts)

# 3. MAP Ensembl IDs to Gene names
gtf <- readLines(gtf_file)
gtf_genes <- gtf[grep('gene_id "([^"]+)";.*gene_name "([^"]+)";', gtf)]
ids <- gsub('.*gene_id "([^"]+)";.*', '\\1', gtf_genes)
syms <- gsub('.*gene_name "([^"]+)";.*', '\\1', gtf_genes)
gene_map <- unique(data.frame(ID=ids, Symbol=syms))
gene_map <- gene_map[!duplicated(gene_map$ID), ]

# 4. PREPARE
group <- factor(c("Control", "Dex", "Control", "Dex"))
logCPM <- log2(t(t(counts + 0.5) / (colSums(counts) + 1) * 1e6))

# 5. ANALYSIS
design <- model.matrix(~group)
fit <- lmFit(logCPM, design)
fit <- eBayes(fit, trend=TRUE)

# 6. MERGE RESULTS
results <- topTable(fit, coef=2, number=Inf)
results$ID <- rownames(results)
results <- merge(results, gene_map, by="ID", all.x=TRUE)
results$Symbol <- ifelse(is.na(results$Symbol), results$ID, results$Symbol)
results <- results[order(results$adj.P.Val), ]

write.csv(results, file.path(outdir, "final_results.csv"), row.names=FALSE)

#####--- PLOTS --- #####

# 7. PCA
pdf(file.path(outdir, "1_pca_plot.pdf"))
plotMDS(logCPM, labels = short_names, col=as.numeric(group), pch=19, main="PCA - Sample Clustering")
legend("topleft", legend=levels(group), col=1:2, pch=19)
dev.off()

# 8. Volcano
pdf(file.path(outdir, "2_volcano_plot.pdf"))
volcanoplot(fit, coef=2, main="Volcano Plot", highlight=10,
            names=results$Symbol[match(rownames(fit), results$ID)])
abline(h=-log10(0.05), col="red", lty=2)
dev.off()

# 9. Top Genes Boxplots
pdf(file.path(outdir, "3_top_genes_boxplots.pdf"))
par(mfrow=c(2,2))
for (i in 1:12) {
  gene_id <- results$ID[i]
  boxplot(logCPM[gene_id, ] ~ group, main=results$Symbol[i], 
          col=c("skyblue", "orange"), ylab="Relative Expression (log2 CPM)")
  stripchart(logCPM[gene_id, ] ~ group, add=TRUE, vertical=TRUE, pch=21, bg="white")
}
dev.off()

# 10. Sample Distance Heatmap
sampleDists <- as.matrix(dist(t(logCPM)))

pdf(file.path(outdir, "4_sample_distance_heatmap.pdf"))
heatmap(sampleDists, 
        main="Sample Euclidean Distance (Similarity)",
        symm=TRUE,
        col=cm.colors(256),
        margins=c(10,10))
dev.off()

# 11. Top 50 Genes Heatmap
top50_ids <- results$ID[1:50]
heatmap_matrix <- logCPM[top50_ids, ]
rownames(heatmap_matrix) <- results$Symbol[1:50]

RdBu <- colorRampPalette(c("blue", "white", "red"))(256)

pdf(file.path(outdir, "5_global_heatmap.pdf"))
heatmap(as.matrix(heatmap_matrix), 
        main="Top 50 Differentially Expressed Genes (z-score)",
        Colv=NA,
        scale="row",
        col=RdBu,
        margins=c(10,5))
dev.off()

cat("\nDone! Results saved to:", outdir, "\n")
