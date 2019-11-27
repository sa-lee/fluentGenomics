#' Summarised ATAC-seq peaks as a GRanges object
#' 
#' A GRanges object containing approximately 300,000 differential
#' accessiblity peaks estimated via limma. A description of how
#' this object was generated can be found in the vignette.
#' 
#' 
#' #' @format A GRanges with 296220 rows and 3 metadata columns:
#' \describe{
#'   \item{peak_id}{the ATAC peak identifer}
#'   \item{da_log2FC}{the estimated log2 fold change}
#'   \item{da_padj}{the estimated differential accessibility FDR adjusted p-value}
#' }
#' 
"peaks"