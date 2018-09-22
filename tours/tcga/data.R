library(SingleCellExperiment)
library(ExperimentHub)
library(scater)
library(irlba)
library(Rtsne)
library(edgeR)
library(HDF5Array)

# Preprocessing

ehub <- ExperimentHub::ExperimentHub()
eh1 <- ehub[["EH1"]] # an ExpressionSet
eh1044 <- ehub[["EH1044"]] # a SummarizedExperiment

se1 <- as(eh1, "SummarizedExperiment")
sce1 <- as(se1, "SingleCellExperiment")
sce1044 <- as(eh1044, "SingleCellExperiment")

# Prepare colData of identical dimensions prior to merging
# In addition, add a "CNTL" colData field to differentiate control and cancer samples

sce1044_colData <- DataFrame(matrix(
  data = NA, nrow = ncol(sce1044), ncol = ncol(colData(sce1)),
  dimnames = list(colnames(sce1044), colnames(colData(sce1)))
  ))
sce1044_colData$bcr_patient_barcode <- rownames(sce1044_colData)
sce1044_colData$CancerType <- sce1044$type
sce1044_colData$CNTL <- factor(TRUE, c(TRUE, FALSE))
colData(sce1044) <- sce1044_colData

sce1$CNTL <- factor(FALSE, c(TRUE, FALSE))

# Keep only controls for the available cancer types
sce1044 <- sce1044[,sce1044$CancerType %in% sce1$CancerType]
sce1044$CancerType <- droplevels(sce1044$CancerType)

# Rename identical "counts" assay names prior to merging

assayNames(sce1) <- "counts"
assayNames(sce1044) <- "counts"

# Merge the two objects

sce <- cbind(sce1, sce1044)

# Add library size and CPM

colData(sce)[,"librarySize"] <- colSums(assay(sce, "counts"))
assay(sce, "log2CPM") <- cpm(assay(sce, "counts"), log = TRUE, prior.count = 0.25)

# Dimensionality reduction

set.seed(12321)
sce <- runPCA(sce, exprs_values = "log2CPM")
irlba_out <- irlba(assay(sce, "log2CPM"))
tsne_out <- Rtsne(irlba_out$v, pca = FALSE, perplexity = 50, verbose = TRUE)
reducedDim(sce, "TSNE") <- tsne_out$Y

# Saving the assay as HDF5-backed arrays

h5filename <- "sce.hdf5"
assay(sce, "counts") <- writeHDF5Array(assay(sce, "counts"), h5filename, "counts", chunkdim = c(100, 100), verbose=TRUE)
assay(sce, "log2CPM") <- writeHDF5Array(assay(sce, "log2CPM"), h5filename, "log2CPM", chunkdim = c(100, 100), verbose=TRUE)

# Saving the results.

saveRDS(file="sce.rds", sce)
