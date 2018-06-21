timestamp()
message("* Started")

stopifnot(require(iSEE))
stopifnot(require(SingleCellExperiment))

sce <- readRDS("sce.rds")
message("* SingleCellExperiment object size: ", format(object.size(sce), units = "MB"))

# Setting up defaults for all panels.
redDim <- DataFrame(Type="TSNE", ColorBy="Column data", ColorByColData="Detection")
colData <- DataFrame(YAxis="log10_total_counts", XAxis="Column data", XAxisColData="Cluster", ColorBy="Column data", ColorByColData="Detection")
featAssay <- DataFrame(YAxisFeatName="PF4", XAxis="Column data", XAxisColData="Cluster", ColorBy="Column data", ColorByColData="log10_total_counts")
heatMap <- DataFrame(FeatName=I(list(c("PF4", "PPBP", "TMSB4X", "B2M", "ACTB", "SDPR"))), 
                     ColData=I(list(c("Cluster"))), Lower=-5, Upper=5)
rowStat <- DataFrame(Search="PF4", Selected="PF4")

# Setting up links between plots.
colData$SelectByPlot <- "Reduced dimension plot 1"
colData$SelectEffect <- "Transparent"
colData$SelectAlpha <- 0

featAssay$SelectByPlot <- "Reduced dimension plot 1"
featAssay$SelectEffect <- "Transparent"
featAssay$SelectAlpha <- 0
featAssay$YAxisRowTable <- "Row statistics table 1"

heatMap$SelectByPlot <- "Reduced dimension plot 1"

# Installation required at runtime, as not included in container yet
BiocInstaller::biocLite("org.Hs.eg.db")
stopifnot(require(org.Hs.eg.db))
# Setting up the annotation function.
annot.fun <- annotateEnsembl(sce, orgdb=org.Hs.eg.db, keytype="ENSEMBL", rowdata_col="ID")

# Setting up the initial panels.
init <- DataFrame(Name=c("Reduced dimension plot 1",
                         "Column data plot 1",
                         "Feature assay plot 1",
                         "Row statistics table 1",
                         "Heat map 1"),
                  Width=c(4,4,4,8,4))

# Setting up a tour.
tour <- read.delim("tour.txt", header=TRUE, sep=";", comment.char="", quote="")

# Running the app.
app <- iSEE(sce, redDimArgs=redDim, colDataArgs=colData, featAssayArgs=featAssay, heatMapArgs=heatMap, rowDataMax=0, rowStatArgs=rowStat,
    appTitle="Running emptyDrops on the PBMC 4K dataset", initialPanels=init, annotFun=annot.fun, tour=tour, runLocal=FALSE)
shiny::runApp(app, port = 1234, host = "0.0.0.0")

message("* Completed")
timestamp()