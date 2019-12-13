f1000paper:
	Rscript --quiet _render.R

install:
	Rscript --quiet -e "devtools::install()"
	