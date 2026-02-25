[Back to Home](../README.md)
## 6. Pseudo-alignment with Salmon
"*Don't count . . . quantify*" (Extra content)

--------------

### Transcript Quantification with Salmon

In this part of the course, we introduce *Salmon*, a lightweight and highly efficient tool for RNA-seq transcript quantification. Unlike traditional alignment-based pipelines (e.g., genome alignment followed by counting [```STAR + featurecounts```]), Salmon performs quasi-mapping directly against a reference transcriptome. This approach **avoids full base-to-base alignment, making it significantly faster (often more than 20× faster) while maintaining high accuracy.**

Salmon estimates transcript abundances as **pseudocounts** (e.g., TPM and estimated read counts), which can be used for downstream differential gene expression analysis with tools such as DESeq2 (via tximport) or for isoform-level analysis. One of Salmon’s major strengths is its ability to properly account for multi-mapping reads and to model sample-specific biases, including GC bias, positional bias, and sequence-specific bias. Correcting for these biases improves the accuracy of transcript abundance estimates and reduces false positives in downstream analyses.

> The Salmon workflow consists of two main steps:
1. **Indexing the reference transcriptome** (FASTA file).
2. **Quantification**, where sequencing reads (FASTQ files) are quasi-mapped to the indexed transcriptome and transcript abundances are estimated.

Because Salmon maps reads to the transcriptome rather than the genome, accurate quantification depends on the quality and completeness of the reference transcriptome. 
>**Overall, Salmon provides a fast, accurate, and scalable solution for RNA-seq quantification, particularly well-suited for high-performance computing environments.**
----------------

Optional: build Salmon index



--------------

|Previous|Home|Next|
|--------|----|----|
|[Counting](../05_counting/counting.md)|[Home](../README.md)|[Differential Expression Analysis](../07_DE/diff_expression.md)|
     