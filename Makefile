f1000paper:
	Rscript --quiet _render.R "BiocWorkflowTools::f1000_article"

htmlpaper:
	Rscript --quiet _render.R "rmarkdown::html_document"
