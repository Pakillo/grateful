#' Cite R packages used in a project
#'
#' Find R packages used in a project, create a BibTeX file of citations,
#' and optionally generate a document with formatted package references
#' or a paragraph citing all packages used, suitable to be used directly within
#' an Rmarkdown document (see examples).
#'
#' \code{cite_packages} is a wrapper function that collects package names and versions
#' and saves their citation information in a BibTeX file
#' (using \code{\link{get_pkgs_info}}).
#'
#' Then, the function is designed to handle three different use cases:
#'
#' If \code{output = "file"}, \code{cite_packages()} will generate an RMarkdown file
#' which includes a paragraph with in-text citations of all packages,
#' as well as a references list.
#' This document can be knitted to various formats via \code{out.format}.
#' References can be formatted for a particular journal using \code{citation.style}.
#' Thus, \code{output = "file"} is best for obtaining a document separate from R,
#' to just cut and paste citations.
#'
#' If \code{output = "paragraph"}, \code{cite_packages()} will return
#' a paragraph with in-text citations of all packages,
#' suitable to be used directly in an Rmarkdown document (see README).
#' To do so, include a reference to the generated \code{bib.file}
#' bibliography file in the YAML header of the Rmarkdown document.
#'
#' Finally, you can use \code{output = "citekeys"} to obtain a vector of citation keys,
#' and then call \code{\link{nocite_references()}} within an Rmarkdown document
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
#' @param output. Either "file" to generate a separate document with formatted citations
#' for all packages; "paragraph" to return a paragraph with in-text citations of
#' used packages, suitable to be used within an Rmarkdown document;
#' or "citekeys" to return a vector with citation keys.
#' In all cases, a BibTeX file with package references is saved on disk
#' (see \code{bib.file}).
#'
#' @param out.format Output format when \code{output = "file"}:
#' either "html" (the default), docx" (Word), "pdf", or "md" (markdown).
#' (Note that choosing "pdf" requires a working installation of LaTeX).
#'
#' @param citation.style Optional. Citation style to format references for a
#' particular journal. See \url{https://www.zotero.org/styles}.
#'
#' @param all.pkgs Logical. Include all packages used in scripts within the
#'   project/folder (the default), or only packages used in the current session?
#'   If \code{TRUE}, uses \code{\link[renv]{dependencies}}, otherwise
#'   uses \code{\link[utils]{sessionInfo}}.
#'
#' @param include.RStudio Logical. If \code{TRUE}, adds a citation for the
#'   current version of RStudio.
#'
#' @param out.dir Directory to save the output document and a BibTeX file with
#'   the references. Default is the working directory.
#'
#' @param bib.file Desired name for the BibTeX file containing packages references
#' ("grateful-refs.bib" by default).
#'
#' @param Rmd.file Desired name of the Rmarkdown document to be created if
#' \code{output = "file"}. Default is "grateful-report.Rmd".
#'
#' @param out.name Desired name of the output file containing the formatted
#' references ("grateful-citations" by default).
#'
#' @param ... Other parameters passed to \code{\link[renv]{dependencies}}.
#'
#' @return A file containing package references in BibTeX format, plus
#' a file with formatted citations, or a paragraph with in-text citations of all packages,
#' suitable to be used within Rmarkdown documents.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library(grateful)
#'
#' #### To build a standalone document for citations ####
#' cite_packages()
#'
#' # Formatting for a particular journal:
#' cite_packages(citation_style = "peerj")
#'
#' # Choosing different output format:
#' cite_packages(out.format = "docx")
#'
#' # Citing only packages currently loaded
#' cite_packages(all.pkgs = FALSE)
#'
#'
#' #### To include citations in an RMarkdown file ####
#'
#' # include this in YAML header: bibliography: grateful-refs.bib
#'
#' # then call cite_packages within a chunk with chunk option results = "asis"
#' cite_packages(output = "paragraph")
#'
#'
#' # To include package citations in the reference list of an Rmarkdown document
#' without citing them in the text, include this in a chunk:
#' nocite_references(cite_packages(output = "citekeys"))
#' }

cite_packages <- function(output = c("file", "paragraph", "citekeys"),
                          out.format = "html",
                          citation.style = NULL,
                          all.pkgs = TRUE,
                          include.RStudio = FALSE,
                          out.dir = getwd(),
                          bib.file = "grateful-refs.bib",
                          Rmd.file = "grateful-report.Rmd",
                          out.name = "grateful-citations",
                          ...) {

  output <- match.arg(output)

  pkgs.df <- get_pkgs_info(all.pkgs = all.pkgs,
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
                      out.name = out.name)
  }

  if (output == "paragraph") {
    cat(write_citation_paragraph(pkgs.df, include.RStudio = include.RStudio))
  }

  if (output == "citekeys") {
    return(citekeys)
  }

}
