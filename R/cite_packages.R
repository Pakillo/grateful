#' Cite R packages used in a project
#'
#' Find R packages used in a project, create a BibTeX file of citations, and
#' optionally generate an RMarkdown document of references.
#'
#' \code{cite_packages} is a wrapper function that collects package names
#' (\code{\link{scan_packages}}), gathers their citations
#' (\code{\link{get_citations}}), and generates a BibTeX file of those citations
#' (\code{\link{create_rmd}}). The function is designed to handle two different
#' use cases. In both cases, a BibTeX file is generated and saved to
#' \code{out.dir}.
#'
#' \code{generate.document = TRUE} generates an RMarkdown file which includes a
#' list of in-text citations for each package, as well as a references list.
#' This document can be knitted to various formats or left as a \code{.Rmd} file
#' via \code{out.format}. Best for creating a final document separate from R, to
#' just cut and paste citations.
#'
#' \code{generate.document = FALSE} returns a list of citation keys from the
#' BibTeX file. These citation keys can then be used programmatically or
#' manually to cite packages, including in a \code{nocite} block in an RMarkdown
#' document. To do so, include a reference to the generated \code{filename}
#' bibliography file in the YAML header of the RMarkdown document.
#'
#' @section Limitations: \code{all.pkgs = TRUE} fails if run within
#'   \code{\link[knitr]{knit}} when compiling an RMarkdown document.
#'   \code{\link[checkpoint]{scanForPackages}} is unable to search for packages
#'   within the temporary directory used by \code{\link[knitr]{knit}}.
#'
#'   \code{include.RStudio = TRUE} fails if run from an R session that is not in
#'   an RStudio interactive session, including being run by
#'   \code{\link[knitr]{knit}}, even when initiated by knitting in RStudio. The
#'   function \code{RStudio.Version()} is only defined in RStudio interactive
#'   sessions.
#'
#'   Citation keys are not guaranteed to be preserved when regenerated,
#'   particularly when packages are updated. This instability is not an issue
#'   when citations are used programmatically, as in the example below. But if
#'   references are put into the text manually, they may need to be updated
#'   periodically.
#'
#' @param generate.document Logical. If \code{TRUE} (default), generate a .Rmd
#'   file with the citations. Otherwise, simply build the .bib file and return
#'   the list of package citation keys.
#' @param all.pkgs Logical. Include all packages used in scripts within the
#'   project/folder (the default), or only packages used in the current session?
#'   If \code{TRUE}, uses \code{\link[checkpoint]{scanForPackages}}, otherwise
#'   uses \code{\link[utils]{sessionInfo}}.
#' @param filename Optional. Name of BibTeX file containing packages references.
#'   Defaults to \code{pkg-refs.bib}
#' @param include.rmd Logical. Include packages used in Rmarkdown documents?
#'   (default is \code{TRUE}, requires \code{knitr} package).
#' @param citation_style Optional. Citation style to format references. See
#'   \url{http://citationstyles.org/styles/}.
#' @param out.format Output format, either "docx" (Word), "pdf", "html", or "md"
#'   (markdown).
#' @param out.dir Directory to save the output document and a BibTeX file with
#'   the references. Defaults to working directory.
#' @param include.RStudio Logical. If \code{TRUE}, adds a citation for the
#'   current version of RStudio, if run within RStudio interactively.
#'
#' @param ... Other parameters passed to
#'   \code{\link[checkpoint]{scanForPackages}}.
#'
#' @return A document with rendered citations in the desired format, plus a file
#'   ("pkg-refs.bib") containing references in BibTeX format.
#' @export
#'
#' @examples
#' \dontrun{
#' library(grateful)
#'
#' ## To build a standalone document for citations:
#' cite_packages()
#' cite_packages(citation_style = "ecology", out.format = "docx")
#'
#' ## To include citations in an RMarkdown file:
#' # include in YAML header: bibliography: pkg-refs.bib
#'
#' # get the citations for all packages currently loaded when knitting the .Rmd
#' citerefs <- cite_packages(generate.document = FALSE, all.pkgs = FALSE)
#'
#' # To include citations in your references list, include this metadata block
#' in the text of your RMarkdown document (not in a code chunk):
#' ---
#' nocite: |
#'   `r paste0("@", citerefs, collapse = ", ")`
#' ...
#' }
cite_packages <- function(generate.document = TRUE, all.pkgs = TRUE,
                          include.rmd = TRUE, filename = "pkg-refs.bib",
                          citation_style = NULL, out.format = "html",
                          out.dir = getwd(), include.RStudio = FALSE, ...) {
  pkgs <- scan_packages(all.pkgs = all.pkgs, include.Rmd = include.rmd, ...)
  cites <- get_citations(pkgs, out.dir = out.dir, filename = filename,
                         include_rstudio = include.RStudio)
  if (generate.document == TRUE) {
    rmd <- create_rmd(cites, csl = citation_style, out.dir = out.dir,
                      out.format = out.format)
  } else {
    return(cites)
  }
}
