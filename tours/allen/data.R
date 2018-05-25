library(scRNAseq)
data(allen)

# Example data
library(scater)
sce <- as(allen, "SingleCellExperiment")
counts(sce) <- assay(sce, "tophat_counts")
sce <- normalize(sce)

sce <- runPCA(sce)
sce <- runTSNE(sce)
rowData(sce)$ave_count <- rowMeans(counts(sce))
rowData(sce)$n_cells <- rowSums(counts(sce)>0)

saveRDS(sce,file="sce.rds")
