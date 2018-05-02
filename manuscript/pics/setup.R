##############################
# Setting up the Allen data. #
##############################

library(scRNAseq)
data(allen)
class(allen)

library(scater)
sce <- as(allen, "SingleCellExperiment")
counts(sce) <- assay(sce, "tophat_counts")

# Reduced dimensionality results.
sce <- normalize(sce)
sce <- runPCA(sce)

# Adding feature-level metadata.
rowData(sce)$ave_count <- rowMeans(counts(sce))
rowData(sce)$n_cells <- rowSums(counts(sce)>0)

library(org.Mm.eg.db)
rowData(sce)$description <- mapIds(org.Mm.eg.db, keys=rownames(sce), keytype="SYMBOL", column="GENENAME")

# # Choosing an interesting gene)
# library(dynamicTreeCut)
# mat <- dist(reducedDim(sce))
# tree <- hclust(mat)
# clusters <- cutreeDynamic(tree, distM=as.matrix(mat), minClusterSize=50)
# library(scran)
# markers <- findMarkers(sce, clusters)

############################
# Setting up iSEE options. #
############################

redDim <- DataFrame(ColorBy="Feature name", ColorByFeatName="Cux2",
                    FontSize=1.5, PointSize=1.5)
colData <- DataFrame(YAxis="NALIGNED", XAxis="Column data", XAxisColData="PRIMER",
                     ColorBy="Column data", ColorByColData="passes_qc_checks_s",
					 FontSize=1.5, PointSize=1.5)
featAssay <- DataFrame(YAxisFeatName="Cux2", ColorBy="Column data", ColorByColData="driver_1_s",
					 FontSize=1.5, PointSize=1.5)
heatMap <- DataFrame(FeatName=I(list(c("Fam19a1", "Cacna2d3", "Cux2", "Rorb", "Ptn", "Lmo3", "Foxp2", "Lamp5", "Etv1"))),
                     ColData=I(list(c("driver_1_s"))))
rowStat <- DataFrame(Selected="Cux2", Search="homeobox 2")

init <- data.frame(Name=c("Reduced dimension plot 1", "Column data plot 1", "Feature assay plot 1",
                          "Row statistics table 1", "Heat map 1"),
                   Width=c(4,4,4,8,4))

library(iSEE)
iSEE(sce, redDimArgs=redDim, colDataArgs=colData, featAssayArgs=featAssay, heatMapArgs=heatMap, rowDataMax=0, rowStatArgs=rowStat, initialPanels=init)
