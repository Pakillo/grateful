
#' Get information about packages used in a project
#'
#' This function scans the project for R packages used and returns a data frame
#' with package names, version, and citation keys.
#'
#' @inheritParams scan_packages
#' @inheritParams get_citations
#' @inheritDotParams scan_packages
#'
#' @return A data.frame with package info,
#' and a file containing package references in BibTeX format.
#' @export
#'
#' @examples
#' \dontrun{
#' get_pkgs_info()
#' }

get_pkgs_info <- function(all.pkgs = TRUE,
                          out.dir = getwd(),
                          bib.file = "grateful-refs.bib",
                          include.RStudio = FALSE,
                          ...) {

  pkgs.df <- scan_packages(all.pkgs = all.pkgs, ...)

  citekeys <- get_citations(pkgs.df$pkg,
                            out.dir = out.dir,
                            bibfile = bib.file,
                            include.RStudio = include.RStudio)

  # Group all citations from same package
  pkgs.df$citekeys <- lapply(pkgs.df$pkg, function(x) {
    citekeys[grep(x, citekeys)]
  })

  pkgs.df

}
