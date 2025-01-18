if (!require(rmarkdown)) {
  install.packages("rmarkdown")
  library(rmarkdown)

}

# Carga el paquete
render("reports/report.github.rmd",
       output_format = "md_document",
       output_file = "../README.md")