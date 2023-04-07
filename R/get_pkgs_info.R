
#' Get information about packages used in a project
#'
#' This function scans the project for R packages used, saves a BibTeX file with
#' package references, and returns a data frame with package names, version,
#' and citation keys.
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
#' get_pkgs_info(pkgs = c("lme4", "mgcv"))
#' }

get_pkgs_info <- function(pkgs = "All",
                          cite.tidyverse = TRUE,
                          cite.grateful = FALSE,
                          dependencies = FALSE,
                          out.dir = getwd(),
                          bib.file = "grateful-refs.bib",
                          include.RStudio = FALSE,
                          ...) {

  pkgs.df <- scan_packages(pkgs = pkgs,
                           cite.tidyverse = cite.tidyverse,
                           cite.grateful = cite.grateful,
                           dependencies = dependencies,
                           ...)

  citekeys <- get_citations(pkgs.df$pkg,
                            out.dir = out.dir,
                            bib.file = bib.file,
                            include.RStudio = include.RStudio)


  # Group all citations from same package
  pkgs.df$citekeys <- lapply(pkgs.df$pkg, function(pkg) {
    pkgname_clean <- gsub("[^[:alnum:]]", "", pkg)
    citekeys[grep(paste0("^", pkgname_clean, "(\\d{4}[a-z]?)?$"), citekeys, perl = TRUE)]
  })

  pkgs.df

}
