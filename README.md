# Fluent genomics with plyranges and tximeta 

<!-- badges: start -->
[![Travis build status](https://travis-ci.org/sa-lee/fluentGenomics.svg?branch=master)](https://travis-ci.org/sa-lee/fluentGenomics)
<!-- badges: end -->

In *fluentGenomics* we explore the use of the Bioconductor packages plyranges and tximeta through integrating results from an experiment using RNA-seq and ATAC-seq data. Readers will learn how to perform genomic range based operations in a principled way using *plyranges* and how to cleanly import quantification and differential expression data into R using *tximeta*. 

## Installation

Currently, `fluentGenomics` is available only on github,
install it and associated dependencies with

``` r
BiocManager::install('sa-lee/fluentGenomics', 
                     build_vignettes = TRUE,
                     dependencies = TRUE)
```

## Workflow

Once the package has been installed, you can work through
the vignette directly from R/Rstudio with:

``` r
browseVignettes(package = "fluentGenomics")
```

Or you can read it online [here](articles/index.html)

