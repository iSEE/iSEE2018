# Interactive visualization with iSEE

This repository contains the code required to construct the tours described in the _iSEE_ paper by Rue-Albrecht _et al._

**Note:** these tours can be resumed from within their respective iSEE application instance, using the _question mark_ icon in the top-right corner of the _Shiny_ application.

# Setting up the tours

Each tour is composed of three files:

- `*_data.R`: a script that contains the instructions to pre-process the data into a `SummarizedExperiment` or `SingleCellExperiment` object ready for _iSEE_
- `*_tour.txt`: a set of step-wise instructions attached to various UI elements in the _iSEE_ user interface.
- `*_app.R`: a script that uses the object pre-processed by `*_data.R` to configure the _iSEE_ application and launch the tour

To launch a tour, successively execute `*_data.R` and `*_app.R`.

## TCGA

This tour is launched by successively running the `tcga_data.R` and `tcga_app.R` scripts.
The only pre-requisite to run those scripts is that the current working directory is set to the `tours/` folder.

The script fetches the TCGA data set from the Bioconductor [ExperimentHub](http://bioconductor.org/packages/release/bioc/html/ExperimentHub.html) in the form of an `ExpressionSet`, and performs a small number of preprocessing steps (e.g., PCA, _t_-SNE) before launching the app and the tour.

**Note:** the first time that the script is run, it may take a few extra minutes, as it downloads and caches a copy of the data set if you haven't one already. Subsequent runs of the script will launch the tour significantly faster, as they will use the locally cached data set. Refer to the documentation of the [ExperimentHub](http://bioconductor.org/packages/release/bioc/html/ExperimentHub.html) for further details.

Demo: http://shiny.imbei.uni-mainz.de:3838/iSEE_TCGA/

## PBMC 4K

This is somewhat more involved as the relevant data, while publicly available, need to be processed and analyzed.
This can be achieved by following these steps:

1. Download and unpack the PBMC 4K dataset from the [10X Genomics website](http://cf.10xgenomics.com/samples/cell-exp/2.1.0/pbmc4k/pbmc4k_raw_gene_bc_matrices.tar.gz).
2. Run the [analysis script](https://github.com/MarioniLab/EmptyDrops2017/tree/master/analysis/pbmc4k/analysis.Rmd).
Modify the `fname` variable according to the path to the unpacked PBMC data files.
3. Move the generated `sce.rds` object into `tours/` and run `pbmc4k_app.R`.

Demo: http://shiny.imbei.uni-mainz.de:3838/iSEE_PBMC4k/

## CyTOF

This tour is launched by the `cytof_app.R` script. The only pre-requisite is that the current working directory is set to the `tours/` folder. The script downloads a preprocesed version of the data set from [Bodenmiller et al (2012)](https://www.nature.com/articles/nbt.2317). See the [`HDCytoData`](http://bioconductor.org/packages/HDCytoData/) package for more information about how the data was processed. 

Demo: http://shiny.imbei.uni-mainz.de:3838/iSEE_cytof/
