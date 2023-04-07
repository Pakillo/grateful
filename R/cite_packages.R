#' Cite R packages used in a project
#'
#' Find R packages used in a project, create a BibTeX file of citations,
#' and generate a document with formatted package references. Alternatively,
#' `cite_packages` can be run directly within an Rmarkdown document to
#' automatically include a paragraph citing all used packages and generate
#' a bibliography.
#'
#' `cite_packages` is a wrapper function that collects package names and versions
#' and saves their citation information in a BibTeX file
#' (using [get_pkgs_info()]).
#'
#' Then, the function is designed to handle different use cases:
#'
#' If `output = "file"`, `cite_packages()` will generate an RMarkdown file
#' which includes a paragraph with in-text citations of all packages,
#' as well as a references list.
#' This document can be knitted to various formats via `out.format`.
#' References can be formatted for a particular journal using `citation.style`.
#' Thus, `output = "file"` is best for obtaining a document separate from R,
#' to just cut and paste citations.
#'
#' If `output = "paragraph"`, `cite_packages()` will return
#' a paragraph with in-text citations of all packages,
#' suitable to be used directly in an Rmarkdown document.
#' To do so, include a reference to the generated `bib.file`
#' bibliography file in the YAML header of the Rmarkdown document
#' (see <https://pakillo.github.io/grateful/index.html#using-grateful-within-rmarkdown>).
#'
#' Alternatively, if `output = "table"`, `cite_packages()` will return
#' a table with package names, versions, and citations. Thus, if using Rmarkdown,
#' you can choose between getting a table or a text paragraph citing all packages.
#'
#' Finally, you can use `output = "citekeys"` to obtain a vector of citation keys,
#' and then call [nocite_references()] within an Rmarkdown document
#' to cite these packages in the reference list without mentioning them in the text.
#'
#'
#' @section Limitations:
#'
#'   Citation keys are not guaranteed to be preserved when regenerated,
#'   particularly when packages are updated. This instability is not an issue
#'   when citations are used programmatically, as in the example below. But if
#'   references are put into the text manually, they may need to be updated
#'   periodically.
#'
#' @param output Either
#'
#' - "file" to generate a separate document with formatted citations
#' for all packages;
#'
#' - "paragraph" to return a paragraph with in-text citations of used packages,
#' suitable to be used within an Rmarkdown document;
#'
#' - "table" to return a table with package name, version, and citations, to be used
#' in Rmarkdown;
#'
#' - "citekeys" to return a vector with citation keys.
#'
#' In all cases, a BibTeX file with package references is saved on disk
#' (see `bib.file`).
#'
#' @param out.format Output format when `output = "file"`:
#' either "html" (the default), "docx" (Word), "pdf", "Rmd", or "md" (markdown).
#' (Note that choosing "pdf" requires a working installation of LaTeX,
#' see https://yihui.org/tinytex/).
#'
#' @param citation.style Optional. Citation style to format references for a
#' particular journal. See <https://bookdown.org/yihui/rmarkdown-cookbook/bibliography.html>.
#'
#' @param pkgs Character. Either "All" to include all packages used in scripts within
#' the project/folder (the default), or "Session" to include only packages
#' used in the current session.
#' Alternatively, `pkgs` can also be a character vector of package names to
#' get citations for (see examples).
#'
#' @param cite.tidyverse Logical. If `TRUE`, all tidyverse packages (dplyr, ggplot2, etc)
#' will be collapsed into a single citation of the 'tidyverse'.
#'
#' @param cite.grateful Logical. Cite `grateful` package? Default is FALSE.
#'
#' @param dependencies Logical. Include the dependencies of your used packages?
#' If `TRUE`, will include all the packages that your used packages depend on.
#'
#' @param include.RStudio Logical. If `TRUE`, adds a citation for the
#'   current version of RStudio.
#'
#' @param out.dir Directory to save the output document and a BibTeX file with
#'   the references. Default is the working directory.
#'
#' @param bib.file Desired name for the BibTeX file containing packages references
#' ("grateful-refs.bib" by default).
#'
#' @param Rmd.file Desired name of the Rmarkdown document to be created if
#' `output = "file"`. Default is "grateful-report.Rmd".
#'
#' @param out.name Desired name of the output file containing the formatted
#' references ("grateful-citations" by default).
#'
#' @param ... Other parameters passed to [renv::dependencies()].
#'
#' @return A file containing package references in BibTeX format, plus
#' a file with formatted citations, or a table or paragraph with in-text citations
#' of all packages, suitable to be used within Rmarkdown documents.
#'
#' @note Before running `grateful` you might want to run
#' [funchir::stale_package_check()] on your scripts to check for unused packages
#' before citing them.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' #### To build a standalone document for citations
#' cite_packages()
#'
#' # Formatting for a particular journal:
#' cite_packages(citation_style = "peerj")
#'
#' # Choosing different output format:
#' cite_packages(out.format = "docx")
#'
#' # Citing only packages currently loaded
#' cite_packages(pkgs = "Session")
#'
#' # Citing only user-provided packages
#' cite_packages(pkgs = c("lme4", "vegan", "mgcv"))
#'
#'
#' #### To include citations in an RMarkdown file
#'
#' # include this in YAML header: bibliography: grateful-refs.bib
#'
#' # then call cite_packages within an R chunk:
#' cite_packages(output = "paragraph")
#'
#'
#' # To include package citations in the reference list of an Rmarkdown document
#' without citing them in the text, include this in a chunk:
#' nocite_references(cite_packages(output = "citekeys"))
#' }

cite_packages <- function(output = c("file", "paragraph", "table", "citekeys"),
                          out.format = c("html", "docx", "pdf", "Rmd", "md"),
                          citation.style = NULL,
                          pkgs = "All",
                          cite.tidyverse = TRUE,
                          cite.grateful = FALSE,
                          dependencies = FALSE,
                          include.RStudio = FALSE,
                          out.dir = getwd(),
                          bib.file = "grateful-refs.bib",
                          Rmd.file = "grateful-report.Rmd",
                          out.name = "grateful-citations",
                          ...) {

  output <- match.arg(output)
  out.format <- match.arg(out.format)

  pkgs.df <- get_pkgs_info(pkgs = pkgs,
                           cite.tidyverse = cite.tidyverse,
                           cite.grateful = cite.grateful,
                           dependencies = dependencies,
                           out.dir = out.dir,
                           bib.file = bib.file,
                           include.RStudio = include.RStudio,
                           ...)


  if (output == "file") {
    rmd <- create_rmd(pkgs.df,
                      bib.file = bib.file,
                      csl = citation.style,
                      Rmd.file = Rmd.file,
                      out.dir = out.dir,
                      out.format = out.format,
                      out.name = out.name,
                      include.RStudio = include.RStudio)
  }

  if (output == "paragraph") {
    paragraph <- write_citation_paragraph(pkgs.df,
                                          include.RStudio = include.RStudio)
    return(knitr::asis_output(paragraph))
  }

  if (output == "table") {
    return(output_table(pkgs.df))
  }

  if (output == "citekeys") {
    return(unlist(pkgs.df$citekeys))
  }

}




