# based on earowang/thesis
options(warn = 1)

paper <- "./vignettes/fluentGenomics.Rmd"

# spell check
wordlist <- readLines("WORDLIST")
spell_res <- spelling::spell_check_files(paper, wordlist, "en_US")
if (length(spell_res$word) > 0) {
  print(spell_res)
  stop("Can you please fix typos listed above first?", call. = FALSE)
}

# compile 
if (Sys.getenv("RSTUDIO") != "1" && Sys.info()['sysname'] == "Darwin") {
  Sys.setenv('RSTUDIO_PANDOC' = '/Applications/RStudio.app/Contents/MacOS/pandoc')
}


formats <- commandArgs(trailingOnly = TRUE)
if (length(formats) == 0) {
  formats <- "rmarkdown::html_document"
}

for (fmt in formats)
  rmarkdown::render(paper, fmt, output_dir = "./docs/", quiet = FALSE)
