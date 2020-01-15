options(warn = 1)
library(rmarkdown)

paper <- "./vignettes/fluentGenomics.Rmd"

# spell check
wordlist <- readLines("WORDLIST")
spell_res <- spelling::spell_check_files(paper, wordlist, "en_US")
if (length(spell_res$word) > 0) {
  print(spell_res)
  stop("Can you please fix typos listed above first?", call. = FALSE)
}

# compile as pdf to docs folder
if (Sys.getenv("RSTUDIO") != "1" && Sys.info()['sysname'] == "Darwin") {
  Sys.setenv('RSTUDIO_PANDOC' = '/Applications/RStudio.app/Contents/MacOS/pandoc')
}

output_dir <- "./docs/"

pdfdoc <- function(...) {
  bookdown::pdf_document2(toc = FALSE, 
                          highlight = "pygments",
                          fig_width = 5,
                          keep_tex = TRUE)
}
  

render(paper,
       output_format = pdfdoc(),
       output_dir = "./docs/",
       quiet = FALSE)
