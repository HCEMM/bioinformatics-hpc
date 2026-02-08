# Cutting-Edge Bioinformatics in a High-Performance Computing Environment
***HCEMM** - Scientific Computing ACF*  
Instructors: Joao Sequeira, Maria Kavoosi, Istvan Szepesi-Nagy

---

## Course Introduction
This course introduces advanced bioinformatics techniques within high-performance computing (HPC) environments. Participants will learn to efficiently manage computational workflows, leverage HPC resources, and apply bioinformatics tools to analyze biological datasets. By the end of the course, students will gain hands-on experience in combining computational power with cutting-edge bioinformatics approaches.

---

## Enviroment setup
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

----------------------

## Content
1. Data download (*fasterq-dump*)
2. Quality Control (*fastqc*)
3. Trimming (*trimmomatic*)
4. MultiQC (*multiqc*)
5. Alignment (*STAR* OR *Hisat2*)
6. Counting (*featureCounts*)
7. Differential expression analysis (*DESeq2* in R)

## References
- Course content is based on HBCTraining website (Harvard Chan Bioinformatics Core) - doi.org/10.5281/zenodo.5833880
- Differential expression analysis pipelines are influenced by Marta Perez Alcantra's content on [bulk RNA-seq analysis](https://mperalc.gitlab.io/bulk_RNA-seq_workshop_2021/index.html).
- Publicly available data is accessed through the Seqeunce Read Archive (SRA) based on [Himes *et al.*, 2014.](https://pubmed.ncbi.nlm.nih.gov/24926665/) - ([SRP033351](https://www.ncbi.nlm.nih.gov/Traces/study/?acc=PRJNA229998&o=acc_s%3Aa))







