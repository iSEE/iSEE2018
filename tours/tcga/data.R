library(SingleCellExperiment)
library(ExperimentHub)
library(scater)
library(irlba)
library(Rtsne)
library(edgeR)

# Preprocessing

ehub <- ExperimentHub::ExperimentHub()
eh1 <- ehub[["EH1"]] # an ExpressionSet
eh1044 <- ehub[["EH1044"]] # a SummarizedExperiment

se1 <- as(eh1, "SummarizedExperiment")
sce1 <- as(se1, "SingleCellExperiment")
sce1044 <- as(eh1044, "SingleCellExperiment")


eh1044_colData <- colData(se1)
eh1044_colData <- eh1044_colData[seq_len(ncol(sce1044)),]
for (colname in colnames(eh1044_colData)) {
    eh1044_colData[[colname]] <- NA
}
eh1044_colData$CancerType <- "CNTL"
rownames(eh1044_colData) <- colnames(sce1044)
colData(sce1044) <- eh1044_colData

assayNames(sce1) <- "counts"
assayNames(sce1044) <- "counts"

sce <- cbind(sce1, sce1044)

colData(sce)[,"CancerType"] <- relevel(colData(sce)[,"CancerType"], "CNTL")

# Add library size and CPM

colData(sce)[,"librarySize"] <- colSums(assay(sce, "counts"))
assay(sce, "log2CPM") <- cpm(assay(sce, "counts"), log = TRUE, prior.count = 0.25)

# Dimensionality reduction

set.seed(12321)
sce <- runPCA(sce, exprs_values = "log2CPM")
irlba_out <- irlba(assay(sce, "log2CPM"))
tsne_out <- Rtsne(irlba_out$v, pca = FALSE, perplexity = 50, verbose = TRUE)
reducedDim(sce, "TSNE") <- tsne_out$Y

# Saving the results.

saveRDS(file="sce.rds", sce)
