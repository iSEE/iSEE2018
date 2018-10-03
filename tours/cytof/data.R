suppressPackageStartupMessages({
    library(HDCytoData)
    library(SingleCellExperiment)
    library(HDF5Array)
})

## Load the data from the HDCytoData package
bcrxl <- Bodenmiller_BCR_XL_SE()

## Transpose the data and apply an arcsinh transform with cofactor 5 to the
## observed measurements
bcrxl <- SingleCellExperiment(
    assays = list(exprs = asinh(t(assay(bcrxl, "exprs"))/5)),
    colData = rowData(bcrxl),
    rowData = colData(bcrxl)
)

## Save the assay as HDF5-backed array
h5filename <- "sce.h5"
assay(bcrxl, "exprs") <- writeHDF5Array(assay(bcrxl, "exprs"), h5filename, "exprs",
                                        chunkdim = c(1, 2500), verbose=TRUE)

saveRDS(file="sce.rds", bcrxl)
