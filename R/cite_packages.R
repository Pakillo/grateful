#' Cite R packages used in a project
#'
#' This is a wrapper function.
#'
#' @param all.pkg Logical. Include all packages used in scripts within the
#' project/folder (the default), or only packages used in the current session?
#' If TRUE, uses \code{\link[renv]{dependencies}},
#' otherwise uses \code{\link[utils]{sessionInfo}}.
#' @param style Optional. Citation style to format references. See \url{https://www.zotero.org/styles}.
#' @param out.format Output format, either "docx", "pdf", "html", or "Rmd" (Rmarkdown).
#' @param out.dir Directory to save the output document and a BibTeX file with the references.
#' Defaults to working directory.
#' @param ... Other parameters passed to \code{\link[renv]{dependencies}}.
#'
#' @return A document with rendered citations in the desired format,
#' plus a file ("pkg-refs.bib") containing references in BibTeX format.
#' @export
#'
#' @examples
#' \dontrun{
#' library(grateful)
#' cite_packages()
#' cite_packages(style = "ecology", out.format = "docx")
#' }
cite_packages <- function(all.pkg = TRUE,
                          style = NULL,
                          out.format = "html",
                          out.dir = getwd(),
                          ...) {
  pkgs <- scan_packages(all.pkgs = all.pkg, ...)
  cites <- get_citations(pkgs, out.dir = out.dir) # produces "pkg-refs.bib" file
  rmd <- create_rmd(cites, csl = style, out.dir = out.dir) # produces "refs.Rmd"

  if (out.format == "rmd" | out.format == "Rmd") {
    return(rmd) # Keep the rmarkdown file and return the file object
  }
  else {
    render_citations(rmd, output = out.format, out.dir = out.dir)
    file.remove(rmd)
  }
}
