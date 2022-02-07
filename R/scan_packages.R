#' Scan a project or folder for packages used
#'
#' @param pkgs Character. Either "All" to include all packages used in scripts within
#' the project/folder (the default), or "Session" to include only packages
#' used in the current session.
#' \code{pkgs} can also be a character vector of package names to get citations for
#' (see examples).
#' @param ... Other parameters passed to \code{\link[renv]{dependencies}}.
#'
#' @return a data.frame with package names and versions
#' @export
#'
#' @examples
#' scan_packages()
#' scan_packages(pkgs = "Session")
#' scan_packages(pkgs = c("lme4", "vegan", "mgcv"))

scan_packages <- function(pkgs = "All", ...) {

  if (length(pkgs) == 1 && pkgs == "All") {
    pkgs <- unique(renv::dependencies(progress = FALSE, ...)$Package)
    pkgs <- pkgs[pkgs != "R"]
  }

  if (length(pkgs) == 1 && pkgs == "Session") {
    pkgs <- names(utils::sessionInfo()$otherPkgs)
  }

  # If pkgs != "All" nor "Session", use them directly as vector of pkg names

  # Only cite base R once
  base_pkgs <- utils::sessionInfo()$basePkgs
  pkgs <- c("base", setdiff(pkgs, base_pkgs))

  # add grateful
  if (!"grateful" %in% pkgs) {
    pkgs <- c(pkgs, "grateful")
  }
  pkgs <- sort(pkgs)

  # Get package versions
  pkgVersion <- Vectorize(utils::packageVersion, SIMPLIFY = FALSE)
  versions <- pkgVersion(pkgs)
  versions <- unlist(lapply(versions, as.character))

  pkgs.df <- data.frame(pkg = pkgs, version = versions, row.names = NULL)

  pkgs.df

}
