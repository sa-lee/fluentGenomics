# Fluent genomics with plyranges and tximeta 

<!-- badges: start -->
[![R build status](https://github.com/sa-lee/fluentGenomics/workflows/R-CMD-check-bioc/badge.svg)](https://github.com/sa-lee/fluentGenomics/actions)
<!-- badges: end -->

In *fluentGenomics* we explore the use of the Bioconductor packages plyranges and tximeta through integrating results from an experiment using RNA-seq and ATAC-seq data. Readers will learn how to perform genomic range based operations in a principled way using *plyranges* and how to cleanly import quantification and differential expression data into R using *tximeta*. 

## Installation

The `fluentGenomics` package is available on Bioconductor:

```r
# install.packages("BiocManager")
BiocManager::install('fluentGenomics')
```

To install `fluentGenomics` from github with associated dependencies use

``` r
BiocManager::install('sa-lee/fluentGenomics', 
                     build_vignettes = TRUE,
                     dependencies = TRUE)
```

To install `fluentGenomics` from Bioconductor's devel branch use:
``` r
BiocManager::install('fluentGenomics',  version = 'devel')
```

## Workflow

Once the package has been installed, you can work through
the vignette directly from R/Rstudio with:

``` r
vignette("fluentGenomics")
```

Or you can read it online 
[here](https://bioconductor.org/packages/devel/workflows/vignettes/fluentGenomics/inst/doc/fluentGenomics.html)

## Course

You can use the package as course material directly with the `usethis`
package:

```{r}
usethis::use_course("sa-lee/fluentGenomics")
```
