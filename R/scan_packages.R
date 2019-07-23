#' Scan a project or folder for packages used
#'
#' @param all.pkgs Logical. Include all packages used in scripts within the project/folder (the default), or only packages used in the current session? If TRUE, uses \code{\link[checkpoint]{scanForPackages}}, otherwise uses \code{\link[utils]{sessionInfo}}.
#' @param include.Rmd Logical. Include packages used in Rmarkdown documents? (default is TRUE, requires \code{knitr} package).
#' @param ... Other parameters passed to \code{\link[checkpoint]{scanForPackages}}.
#'
#' @return a character vector of package names
#' @export
#'
#' @examples
#' library(grateful)
#' scan_packages()
scan_packages <- function(all.pkgs = TRUE, include.Rmd = FALSE, ...) {

  if (all.pkgs == TRUE) {
    pkgs <- checkpoint::scanForPackages(use.knitr = include.Rmd, ...)$pkgs
  } else {
    pkgs <- names(utils::sessionInfo()$otherPkgs)
  }

  # Only cite base R once
  base_pkgs <- utils::sessionInfo()$basePkgs
  pkgs <- c("base", setdiff(pkgs, base_pkgs))

}
