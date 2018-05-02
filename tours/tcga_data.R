
# Librarires ----

stopifnot(requireNamespace("ExperimentHub"))
stopifnot(require(SingleCellExperiment))
stopifnot(requireNamespace("scater"))
stopifnot(requireNamespace("irlba"))
stopifnot(requireNamespace("Rtsne"))

# Preprocessing ----

# Vignette demo

ehub <- ExperimentHub::ExperimentHub()
eh1 <- ehub[["EH1"]] # an ExpressionSet
se1 <- as(eh1, "SummarizedExperiment")
sce <- as(se1, "SingleCellExperiment")
sce <- scater::runPCA(sce, exprs_values = "exprs")
irlba_out <- irlba::irlba(assay(sce, "exprs"))
tsne_out <- Rtsne::Rtsne(
  irlba_out$v, pca = FALSE, perplexity = 50, verbose = TRUE)
reducedDim(sce, "TSNE") <- tsne_out$Y

# library size and CPM

colData(sce)[,"lib_size"] <- colSums(assay(sce, "exprs"))
assay(sce, "log2CPM") <-
  log2(1 + t(t(assay(sce, "exprs")) / colData(sce)[,"lib_size"]))
