f1000paper:
	Rscript --quiet _render.R

install:
	Rscript --quiet -e "devtools::install(upgrade = FALSE)"

bccheck:
	Rscript --quiet -e "BiocCheck::BiocCheck('.')"
	
check:
	Rscript --quiet -e "devtools::check('.')"
