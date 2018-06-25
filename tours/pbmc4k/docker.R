timestamp()
message("* Started")

# The container does not include this package yet; it must be installed at runtime
BiocInstaller::biocLite("org.Hs.eg.db")

out <- source("app.R")
shiny::runApp(out$value, port = 1234, host = "0.0.0.0")

message("* Completed")
timestamp()
