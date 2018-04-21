# Interactive visualization with iSEE

This repository contains the code required to construct the tours described in the _iSEE_ paper by Rue-Albrecht _et al._

# Setting up the tours

## PBMC 4K

This is somewhat more involved as the relevant data, while publicly available, need to be processed and analyzed.
This can be achieved by following these steps:

1. Download and unpack the PBMC 4K dataset from the [10X Genomics website](http://cf.10xgenomics.com/samples/cell-exp/2.1.0/pbmc4k/pbmc4k_raw_gene_bc_matrices.tar.gz).
2. Run the [analysis script](https://github.com/MarioniLab/EmptyDrops2017/tree/master/analysis/pbmc4k/analysis.Rmd).
Modify the `fname` variable according to the path to the unpacked PBMC data files.
3. Move the generated `sce.rds` object into `tours/` and run `pbmc4k_app.R`.