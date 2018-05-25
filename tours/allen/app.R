library(iSEE)

# Read in the data and the tour
sce <- readRDS("sce.rds")
tour <- read.delim(system.file("extdata", "intro_firststeps.txt",package = "iSEE"),
    sep=";", stringsAsFactors = FALSE,row.names = NULL)

# Edit step 1 to give a note on how to restart the tour
tour$intro[1] <- paste0(tour$intro[1], '<br/><br/><font color="##FF0000"><strong>NOTE:</strong></font> if the tour is not jumping to the correct UI elements, exit by clicking anywhere else on the app, and click on the top-right question mark to start a new tour.')

# Launch the app
iSEE(sce,tour = tour,appTitle = "Demonstrating iSEE on the Allen scRNA-seq data")
