
#' Get information about packages used in a project
#'
#' This function scans the project for R packages used, saves a BibTeX file with
#' package references, and returns a data frame with package names, version,
#' and citation keys.
#'
#' @param out.dir Directory to save the BibTeX file with references.
#' It is recommended to set `out.dir = getwd()`.
#' @inheritParams cite_packages
#' @param ... Other parameters passed to [renv::dependencies()].
#'
#' @return A data.frame with package info,
#' and a file containing package references in BibTeX format.
#' @export
#'
#' @examplesIf interactive()
#' get_pkgs_info(out.dir = tempdir())
#' get_pkgs_info(pkgs = c("renv", "remotes"), out.dir = tempdir())


get_pkgs_info <- function(pkgs = "All",
                          out.dir = NULL,
                          omit = c("grateful"),
                          cite.tidyverse = TRUE,
                          dependencies = FALSE,
                          bib.file = "grateful-refs",
                          include.RStudio = FALSE,
                          ...) {

  pkgs.df <- scan_packages(pkgs = pkgs,
                           omit = omit,
                           cite.tidyverse = cite.tidyverse,
                           dependencies = dependencies,
                           ...)

  citekeys <- get_citations(pkgs.df$pkg,
                            out.dir = out.dir,
                            bib.file = bib.file,
                            include.RStudio = include.RStudio)

  if (isTRUE(include.RStudio)) {
    citekeys <- citekeys[names(citekeys) != "rstudio"]
  }

  pkgs.df$citekeys <- citekeys

  pkgs.df

}
