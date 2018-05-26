library(SingleCellExperiment)
library(ExperimentHub)
library(scater)
library(irlba)
library(Rtsne)
library(edgeR)

# Preprocessing

ehub <- ExperimentHub::ExperimentHub()
eh1 <- ehub[["EH1"]] # an ExpressionSet
se1 <- as(eh1, "SummarizedExperiment")
sce <- as(se1, "SingleCellExperiment")
assayNames(sce) <- "counts"

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
