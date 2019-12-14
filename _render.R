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

# overwrite yaml header
f1000_rmd <- "docs/fluentGenomics.Rmd"
f1000_yaml <- readLines("_paper.yml")

content <- readLines(paper)

content_yaml <-  grep("^---$", content)
content <- c(f1000_yaml, content[-seq(content_yaml[1], content_yaml[2])])

writeLines(content, f1000_rmd)

rmarkdown::render(f1000_rmd,  quiet = FALSE)


