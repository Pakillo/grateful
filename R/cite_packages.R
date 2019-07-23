#' Cite R packages used in a project
#'
#' This is a wrapper function.
#'
#' @param generate.document Logical. If TRUE (default), generate a .Rmd file with the citations. Otherwise, simply build the .bib file and return the list of package citation keys.
#' @param all.pkg Logical. Include all packages used in scripts within the project/folder (the default), or only packages used in the current session? If TRUE, uses \code{\link[checkpoint]{scanForPackages}}, otherwise uses \code{\link[utils]{sessionInfo}}.
#' @param include.rmd Logical. Include packages used in Rmarkdown documents? (default is TRUE, requires \code{knitr} package).
#' @param style Optional. Citation style to format references. See \url{http://citationstyles.org/styles/}.
#' @param out.format Output format, either "docx" (Word), "pdf", "html", or "md" (markdown).
#' @param out.dir Directory to save the output document and a BibTeX file with the references. Defaults to working directory.
#' @param include.RStudio Logical. If TRUE, adds a citation for the current version of RStudio, if run within RStudio interactively.
#'
#' @param ... Other parameters passed to \code{\link[checkpoint]{scanForPackages}}.
#'
#' @return A document with rendered citations in the desired format, plus a file ("pkg-refs.bib") containing references in BibTeX format.
#' @export
#'
#' @examples
#' \dontrun{
#' library(grateful)
#' cite_packages()
#' cite_packages(style = "ecology", out.format = "docx")
#' }
cite_packages <- function(generate.document = TRUE, all.pkg = TRUE,
                          include.rmd = TRUE, style = NULL,
                          out.format = "html", out.dir = getwd(),
                          include.RStudio = FALSE, ...) {
  pkgs <- scan_packages(all.pkgs = all.pkg, include.Rmd = include.rmd, ...)
  cites <- get_citations(pkgs, out.dir = out.dir,
                         include_rstudio = include.RStudio) # produces "pkg-refs.bib" file
  if (generate.document == TRUE) {
    rmd <- create_rmd(cites, csl = style, out.dir = out.dir)

    if (tolower(out.format) == "rmd") {
      return(rmd) # Keep the rmarkdown file and return the file object
    }
    else {
      render_citations(rmd, output = out.format, out.dir = out.dir)
      file.remove(rmd)
    }
  } else {
    return(cites)
  }
}
