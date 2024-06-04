#' Cite R packages used in a project
#'
#' Find R packages used in a project, create a BibTeX file of references,
#' and generate a document with formatted package citations. Alternatively,
#' `cite_packages` can be run directly within an 'R Markdown' or 'Quarto' document to
#' automatically include a paragraph citing all used packages and generate
#' a bibliography.
#'
#' `cite_packages` is a wrapper function that collects package names and versions
#' and saves their citation information in a BibTeX file
#' (using [get_pkgs_info()]).
#'
#' Then, the function is designed to handle different use cases:
#'
#' If `output = "file"`, `cite_packages()` will generate an 'R Markdown' file
#' which includes a paragraph with in-text citations of all packages,
#' as well as a references list.
#' This document can be knitted to various formats via `out.format`.
#' References can be formatted for a particular journal using `citation.style`.
#' Thus, `output = "file"` is best for obtaining a document separate from R,
#' to just cut and paste citations.
#'
#' If `output = "paragraph"`, `cite_packages()` will return
#' a paragraph with in-text citations of all packages,
#' suitable to be used directly in an 'R Markdown' or 'Quarto' document.
#' To do so, include a reference to the generated `bib.file`
#' bibliography file in the YAML header of the document
#' (see <https://pakillo.github.io/grateful/index.html#using-grateful-within-rmarkdown>).
#'
#' Alternatively, if `output = "table"`, `cite_packages()` will return
#' a table with package names, versions, and citations. Thus, if using 'R Markdown'
#' or 'Quarto', you can choose between getting a table or a text paragraph citing all packages.
#'
#' Finally, you can use `output = "citekeys"` to obtain a vector of citation keys,
#' and then call [nocite_references()] within an 'R Markdown' or 'Quarto' document
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
#' suitable to be used within an 'R Markdown' or 'Quarto' document;
#'
#' - "table" to return a table with package name, version, and citations, to be used
#' in 'R Markdown' or 'Quarto';
#'
#' - "citekeys" to return a vector with citation keys.
#'
#' In all cases, a BibTeX file with package references is saved on disk
#' (see `bib.file`).
#'
#' @param out.dir Directory to save the output document and a BibTeX file with
#'   the references. It is recommended to set `out.dir = getwd()`.
#'
#' @param out.format Output format when `output = "file"`:
#' either "html" (the default), "docx" (Word), "pdf", "Rmd", or "md" (markdown).
#' (Note that choosing "pdf" requires a working installation of LaTeX,
#' see <https://yihui.org/tinytex/>).
#'
#' @param citation.style Optional. Citation style to format references for a
#' particular journal
#' (see <https://bookdown.org/yihui/rmarkdown-cookbook/bibliography.html>).
#' If the CSL is not available in `out.dir`, it will be downloaded
#' automatically from the official
#' [GitHub repository](https://github.com/citation-style-language/styles)
#' using [get_csl()].
#' If using [cite_packages()] within an R Markdown or Quarto
#' document, `citation.style` should be `NULL` (the default). The citation style
#' should instead be defined in the YAML metadata of the document
#' (see <https://pakillo.github.io/grateful/#using-grateful-with-rmarkdown-or-quarto>).
#'
#' @param pkgs Character. Either "All" to include all packages used in scripts
#' within the project/folder (the default), or "Session" to include only packages
#' used in the current session.
#' Alternatively, `pkgs` can also be a character vector of package names to
#' get citations for. To cite R as well as the given packages,
#' include "base" in `pkgs` (see examples).
#'
#' @param omit Character vector of package names to be omitted from the citation
#' report. `grateful` is omitted by default. Use `omit = NULL` to include all
#' packages.
#'
#' @param cite.tidyverse Logical. If `TRUE`, all tidyverse packages
#' (dplyr, ggplot2, etc) will be collapsed into a single citation
#' of the 'tidyverse', as recommended by the tidyverse team.
#'
#' @param dependencies Logical. Include the dependencies of your used packages?
#' If `TRUE`, will include all the packages that your used packages depend on.
#'
#' @param include.RStudio Logical. If `TRUE`, adds a citation for the
#'   current version of RStudio.
#'
#' @param passive.voice Logical. If `TRUE`, uses passive voice in any paragraph
#'   generated for citations.
#'
#' @param out.file Desired name of the citation report to be created if
#' `output = "file"`. Default is "grateful-report" (without extension).
#'
#' @param bib.file Desired name for the BibTeX file containing packages references
#' ("grateful-refs" by default).
#'
#' @param ... Other parameters passed to [renv::dependencies()].
#'
#' @return If `output = "file"`, `cite_packages` will save two files in `out.dir`:
#' a BibTeX file containing package references and a citation report with formatted
#' citations. `cite_packages` will return the path to the citation report invisibly.
#' If `output = "table"` or `output = "paragraph"`, `cite_packages` will return
#' a table or paragraph with package citations suitable to be used
#' within 'R Markdown' or 'Quarto' documents.
#'
#'
#' @export
#'
#' @examplesIf interactive()
#'
#' # To build a standalone document for citations
#' cite_packages(out.dir = tempdir())
#'
#' # Format references for a particular journal:
#' cite_packages(citation.style = "peerj", out.dir = tempdir())
#'
#' # Choose different output format:
#' cite_packages(out.format = "docx", out.dir = tempdir())
#'
#' # Cite only packages currently loaded:
#' cite_packages(pkgs = "Session", out.dir = tempdir())
#'
#' # Cite only user-provided packages:
#' cite_packages(pkgs = c("renv", "remotes", "knitr"), out.dir = tempdir())
#'
#' # Cite R as well as user-provided packages
#' cite_packages(pkgs = c("base", "renv", "remotes", "knitr"), out.dir = tempdir())
#'
#'
#' # To include citations in an R Markdown or Quarto file
#'
#' # include this in YAML header:
#' # bibliography: grateful-refs.bib
#'
#' # then call cite_packages within an R chunk:
#' cite_packages(output = "paragraph", out.dir = tempdir())
#'
#' # To include package citations in the reference list of an Rmarkdown document
#' # without citing them in the text, include this in a chunk:
#' nocite_references(cite_packages(output = "citekeys", out.dir = tempdir()))


cite_packages <- function(output = c("file", "paragraph", "table", "citekeys"),
                          out.dir = NULL,
                          out.format = c("html", "docx", "pdf", "Rmd", "md"),
                          citation.style = NULL,
                          pkgs = "All",
                          omit = c("grateful"),
                          cite.tidyverse = TRUE,
                          dependencies = FALSE,
                          include.RStudio = FALSE,
                          passive.voice = FALSE,
                          out.file = "grateful-report",
                          bib.file = "grateful-refs",
                          ...) {

  if (is.null(out.dir)) {
    stop("Please specify where to save the citation report, e.g. out.dir = getwd()")
  }

  bib.file <- gsub(".bib", "", bib.file)

  if (out.file == bib.file) {
    stop("Please provide different names for out.file and bib.file")
  }

  output <- match.arg(output)
  out.format <- match.arg(out.format)

  pkgs.df <- get_pkgs_info(pkgs = pkgs,
                           out.dir = out.dir,
                           omit = omit,
                           cite.tidyverse = cite.tidyverse,
                           dependencies = dependencies,
                           bib.file = bib.file,
                           include.RStudio = include.RStudio,
                           ...)


  if (output == "file") {

    rmd <- create_rmd(pkgs.df,
                      bib.file = bib.file,
                      csl = citation.style,
                      Rmd.file = out.file,
                      out.dir = out.dir,
                      out.format = out.format,
                      include.RStudio = include.RStudio,
                      passive.voice = passive.voice)

    message(paste0("\nCitation report available at ", rmd))
    return(rmd)  # return path to file

  }


  if (output == "paragraph") {

    paragraph <- write_citation_paragraph(pkgs.df,
                                          include.RStudio = include.RStudio,
                                          passive.voice = passive.voice)
    return(knitr::asis_output(paragraph))

  }


  if (output == "table") {
    return(output_table(pkgs.df, include.RStudio = include.RStudio))
  }


  if (output == "citekeys") {
    return(unname(unlist(pkgs.df$citekeys)))
  }

}




