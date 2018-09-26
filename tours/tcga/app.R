library(iSEE)

sce <- readRDS("sce.rds")

# Reset the path to the HDF5 file relative to the container
path(assay(sce, "counts")) <- "/app/sce.hdf5"
path(assay(sce, "log2CPM")) <- "/app/sce.hdf5"

tour <- read.delim("tour.txt", sep=";", stringsAsFactors = FALSE, row.names = NULL)

# Panel 1: colData (phenotype selection)
# Y = CancerType
# X = Gender
# select breast cancer female patients

cd <- colDataPlotDefaults(sce, 2)
# data
cd$DataBoxOpen <- c(TRUE, FALSE)
cd$YAxis <-  c("CancerType", "her2_status_by_ihc")
cd$XAxis <- c("Column data", "Column data")
cd$XAxisColData <- c("CNTL","CNTL")
# visual
cd$VisualBoxOpen <- c(TRUE, FALSE)
cd$ColorBy <- c("Column data", "None")
cd$ColorByColData <- c("CancerType", "CancerType")
cd$VisualChoices <- list(
    c("Color", "Points", "Other"),
    c("Color")
)
cd$PointAlpha <- c(0.25, 1)
cd$Downsample <- TRUE
cd$SampleRes <- 200
cd$LegendPosition <- c("Right", "Bottom")
# point selection
cd$BrushData <- list(
  # (female BRCA patients)
  list(
      xmin = 0.45, xmax = 2.55, ymin = 1.45, ymax = 2.55, mapping = list(x = "X", y = "Y"),
      domain = list(left = 0.4, right = 2.6, bottom = 0.4, top = 20.6),
      range = list(left = 55.8972468964041, right = 253.520547945205, bottom = 432.984589041096, top = 24.0290131340161),
      log = list(x = NULL, y = NULL), direction = "xy",
      brushId = "colDataPlot1_Brush", outputId = "colDataPlot1"),
  list(
      xmin = 1.45, xmax = 2.55, ymin = 4.45, ymax = 6.55, mapping = list(x = "X", y = "Y"),
      domain = list(left = 0.4, right = 2.6, bottom = 0.4, top = 6.6),
      range = list(left = 95.3796687714041, right = 368.520547945205, bottom = 543.693573416096, top = 24.8879973724842),
      log = list(x = NULL, y = NULL), direction = "xy",
    brushId = "colDataPlot2_Brush", outputId = "colDataPlot2")
)
cd$SelectBoxOpen <- c(FALSE, TRUE)
cd$SelectByPlot <- c("---", "Column data plot 1")
cd$SelectEffect <- c("Transparent", "Restrict")

# Panel 2: reduced dimensions (overview)
# selection: tSNE
# color: colData > CancerType
# downsample for speed (tSNE): 100
# panel width: 5
# legend position: right
rd <- redDimPlotDefaults(sce, 1)
# data
rd$Type <- "TSNE"
# visual
rd$VisualBoxOpen <- TRUE
rd$VisualChoices[[1]] <- c("Color", "Points", "Other")
rd$ColorBy <- "Column data"
rd$ColorByColData <- "CNTL"
rd$Downsample <- TRUE
rd$SampleRes <- 200
rd$LegendPosition <- "Bottom"
# select
rd$SelectBoxOpen <- TRUE
rd$SelectByPlot <- c("Column data plot 1")
rd$SelectAlpha <- 0.05

# Panel 3: feature assay (analysis)
fe <- featAssayPlotDefaults(sce, 1)
# data
fe$DataBoxOpen <- TRUE
fe$Assay <- 2
fe$XAxis <- "Column data"
fe$XAxisColData <- "CNTL"
fe$YAxisFeatName <- match("ERBB2", rownames(sce))
# visual
fe$VisualBoxOpen <- TRUE
fe$VisualChoices[[1]] <- c("Points")
fe$Downsample <- TRUE
fe$SampleRes <- 200
# select
fe$SelectBoxOpen <- TRUE
fe$SelectByPlot <- c("Column data plot 1")
fe$SelectEffect <- "Restrict"

hm <-  heatMapPlotDefaults(sce, 1)
# feature data
hm$FeatNameBoxOpen <- TRUE
hm$Assay <- 2
heatmaFeatureNames <- rev(c(
  "ERBB2","HSPA7","HSPA6","GDF6","DNAJA4","KPRP","EEF1A2","TNFAIP2","PDGFB",
  "TSPAN18","HSPA1A","ATP6V0A4","CFB","HSPA1B","EPGN","CALB2","PNMA2","SAA2",
  "CRYAB","KRT80","SRMS","GPR1","UCA1","TNFRSF11B","FAM83A","EPHA3",
  "CXCL5","RGS2","DDAH1","ULBP1","AKAP12","SOD2","KRT19","TLR3","SHC4","PPP1R3C",
  "PTK6","SPON1","MYADM","BST2","GRAMD2","SAA1","HSP90AA1","KRT18","EPHA4",
  "PIK3C2B","KLK6","CXCR1","PGM2L1","ANGPTL4","PAQR7","DAPK1","FAM198B",
  "SERPINB13","GBP6","VWA1","SLC1A1","HSPH1","KITLG","GPRC5A"))
heatmaFeatureIndex <- match(heatmaFeatureNames, rownames(sce))
hm$FeatName <- list(heatmaFeatureIndex)
# scaling
hm$CenterScale <- list(c("Centered", "Scaled"))
hm$Lower <- -2
hm$Upper <- 2
# column data
hm$ColDataBoxOpen <- TRUE
hm$ColData <- list(c("her2_status_by_ihc"))
# select
hm$SelectBoxOpen <- TRUE
hm$SelectByPlot <- c("Column data plot 2")
hm$SelectEffect <- "Restrict"

# Panel setup

initialPanels = DataFrame(
    Name = c(
      "Column data plot 1",
      "Reduced dimension plot 1",
      "Feature assay plot 1",
      "Column data plot 2",
      "Heat map 1",
      "Row statistics table 1"
    ),
    Width = c(
      3, # colData (1)
      4, # reducedDim
      5, # featAssays
      3, # colData (2)
      6, # heatMapPlot
      3 # rowStatTable
    ),
    Height = c(rep(500, 3), rep(600, 3))
  )

iSEE(
  sce, tour = tour,
  redDimArgs = rd, colDataArgs = cd, featAssayArgs = fe,
  rowStatArgs = NULL, rowDataArgs = NULL, heatMapArgs = hm,
  redDimMax = 1, colDataMax = 2, featAssayMax = 1,
  rowStatMax = 1, rowDataMax = 1, heatMapMax = 1,
  initialPanels = initialPanels,
  appTitle = "Exploring the TCGA RNA-seq data after re-processing")
