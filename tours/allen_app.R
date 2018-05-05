library(iSEE)
# read in the data and the tour
sce <- readRDS("allen_sce.rds")
tour <- read.delim(system.file("extdata", "intro_firststeps.txt",package = "iSEE"),
                   sep=";", stringsAsFactors = FALSE,row.names = NULL)
# edit step1 to give a note on how to restart the tour
tour$intro[1] <- paste0(tour$intro[1],"<br/><br/><b>NOTE:</b> if the tour doesn't run properly at first, exit and click on the top-right question mark to start a new tour.")
# launch the app
iSEE(sce,tour = tour,appTitle = "iSEE - demo on the allen dataset")
