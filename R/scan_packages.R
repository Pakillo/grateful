#' Scan a project or folder for packages used
#'
#' @param all.pkgs Logical. Include all packages used in scripts within
#' the project/folder (the default), or only packages used in the current session?
#' If TRUE, uses \code{\link[renv]{dependencies}},
#' otherwise uses \code{\link[utils]{sessionInfo}}.
#' @param ... Other parameters passed to \code{\link[renv]{dependencies}}.
#'
#' @return a character vector of package names
#' @export
#'
#' @examples
#' library(grateful)
#' scan_packages()
scan_packages <- function(all.pkgs = TRUE, ...) {

  if (all.pkgs) {
    pkgs <- unique(renv::dependencies(...)$Package)
  } else {
    pkgs <- names(utils::sessionInfo()$otherPkgs)
  }

  # Only cite base R once
  base_pkgs <- utils::sessionInfo()$basePkgs
  pkgs <- c("base", setdiff(pkgs, base_pkgs))

}
