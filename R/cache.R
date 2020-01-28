# Internal methods for downloading and caching
# ATAC seq data. Modified from the
# BiocFileCache vignette

#' Download, retrieve and cache macrophage ATAC seq results
#' 
#' @param verbose Provide progress bar for downloading and updating the cache?
#' (Default is FALSE)
#' 
#' @details This code generates the SummarizedExperiment object
#' used for ATAC seq peaks data analysis as discussed in the vignette.
#' 
#' @source \url{https://zenodo.org/record/1188300/files/}
#' 
#' @return the path to the .rds file containing the SummarizedExperiment 
#' @importFrom stats relevel
#' @importFrom readr read_tsv
#' @importFrom SummarizedExperiment SummarizedExperiment
#' @importFrom dplyr select mutate
#' @importFrom plyranges as_granges set_genome_info
#' @importFrom utils download.file
#' @rdname cache-se
#' @export
#' @examples
#' if (interactive()) {
#'  path_to_se <- cache_atac_se()
#'  atac <- readRDS(path_to_se)
#' }
cache_atac_se <- function(verbose = FALSE) {
  dir_url <- "https://zenodo.org/record/1188300/files/"
  
  bfc <- retrieve_cache()
  
  resource <- "macrophage_atac_se"
  
  
  
  res <- BiocFileCache::bfcquery(bfc, resource)
  if (BiocFileCache::bfccount(res) == 0L) {
    if (verbose) {
      message("Preparing summarised experiment, now downlading files")
    }
    
    atac_coldata <- prep_coldata(dir_url, 
                                 verbose)
    peaks_gr <- prep_peaks(dir_url, verbose)
    atac_mat <- prep_mat(dir_url, verbose, 
                         atac_coldata[["sample_id"]])
    
    se <- SummarizedExperiment(
      list(cqndata = atac_mat), 
      rowRanges = peaks_gr, 
      colData = atac_coldata)
    saveRDS(se, BiocFileCache::bfcnew(bfc, 
                                      resource, ext = ".rds"))
  }
  # the path of the file to load
  BiocFileCache::bfcrpath(bfc, resource)
}

retrieve_cache <- function() {
  if (!requireNamespace("rappdirs", quietly = TRUE)) {
    stop("Please install rappdirs to set cache directory")
  }
  cache <- rappdirs::user_cache_dir(appname = "fluentGenomics")
  
  if (!requireNamespace("BiocFileCache", quietly = TRUE)) {
    stop("Please install BiocFileCache to generate new cache.")
  }
  BiocFileCache::BiocFileCache(cache)
}

prep_coldata <- function(dir_url, verbose) {
  coldata <- paste0(dir_url, "ATAC_sample_metadata.txt.gz?download=1")
  # avoid global variable warning
  sample_id <- donor <- condition_name <- NULL
  # download sample metadata
  tmp_coldata <- tempfile(fileext = "txt.gz")
  download.file(coldata, tmp_coldata, quiet = !verbose)
  atac_coldata <- readr::read_tsv(tmp_coldata, 
                                  progress = verbose)
  atac_coldata <- dplyr::select(atac_coldata, 
                                sample_id, donor, condition = condition_name)
  atac_coldata[["condition"]] <- relevel(factor(atac_coldata[["condition"]]), 
                                         "naive")
  
  on.exit(unlink(tmp_coldata))
  atac_coldata
}

prep_peaks <- function(dir_url, verbose) {
  peaks <- paste0(dir_url, "ATAC_peak_metadata.txt.gz?download=1")
  chr <- gene_id <- NULL
  # download atac peaks
  tmp_peaks <- tempfile(fileext = ".txt.gz")
  download.file(peaks, tmp_peaks, quiet = !verbose)
  peaks_df <- readr::read_tsv(tmp_peaks, col_types = c("cidciicdc"))
  peaks_gr <- plyranges::as_granges(peaks_df, 
                                    seqnames = chr)
  peaks_gr <- dplyr::select(peaks_gr, peak_id = gene_id)
  peaks_gr <- plyranges::set_genome_info(peaks_gr, 
                                         genome = "GRCh38")
  on.exit(unlink(tmp_peaks))
  peaks_gr
}

prep_mat <- function(dir_url, verbose, sample_id) {
  cqn_matrix <- paste0(dir_url, "ATAC_cqn_matrix.txt.gz?download=1")
  # download matrix
  mat_file <- tempfile(fileext = ".txt.gz")
  download.file(cqn_matrix, mat_file, quiet = !verbose)
  atac_mat <- readr::read_tsv(mat_file, skip = 1, 
                              col_names = c("rownames", sample_id))
  rownames <- atac_mat[["rownames"]]
  atac_mat <- as.matrix(atac_mat[, -1])
  rownames(atac_mat) <- rownames
  
  on.exit(unlink(mat_file))
  atac_mat
}
