library(SingleCellExperiment)
library(ExperimentHub)
library(scater)
library(irlba)
library(Rtsne)

# Preprocessing

ehub <- ExperimentHub::ExperimentHub()
eh1 <- ehub[["EH1"]] # an ExpressionSet
se1 <- as(eh1, "SummarizedExperiment")
sce <- as(se1, "SingleCellExperiment")

# Vignette demo

set.seed(12321)
sce <- runPCA(sce, exprs_values = "exprs")
irlba_out <- irlba(assay(sce, "exprs"))
tsne_out <- Rtsne(irlba_out$v, pca = FALSE, perplexity = 50)
reducedDim(sce, "TSNE") <- tsne_out$Y

# library size and CPM

colData(sce)[,"lib_size"] <- colSums(assay(sce, "exprs"))
assay(sce, "log2CPM") <-
  log2(1 + t(t(assay(sce, "exprs")) / colData(sce)[,"lib_size"]))

# Saving the results.

saveRDS(file="sce.rds", sce)  
