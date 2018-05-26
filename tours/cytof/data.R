suppressPackageStartupMessages({
    library(HDCytoData)
    library(SingleCellExperiment)
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

saveRDS(file="sce.rds", bcrxl)
