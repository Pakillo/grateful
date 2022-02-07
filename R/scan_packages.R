#' Scan a project or folder for packages used
#'
#' @param pkgs Character. Either "All" to include all packages used in scripts within
#' the project/folder (the default), or "Session" to include only packages
#' used in the current session.
#' \code{pkgs} can also be a character vector of package names to get citations for
#' (see examples).
#'
#' @param cite.tidyverse Logical. If \code{TRUE}, all tidyverse packages (dplyr, ggplot2, etc)
#' will be collapsed into a single citation of the 'tidyverse'.
#'
#' @param dependencies Logical. Include the dependencies of your used packages?
#' If \code{TRUE}, will include all the packages that your used packages depend on.
#'
#' @param ... Other parameters passed to \code{\link[renv]{dependencies}}.
#'
#' @return a data.frame with package names and versions
#' @export
#'
#' @examples
#' \dontrun{
#' scan_packages()
#' scan_packages(pkgs = "Session")
#' scan_packages(pkgs = c("lme4", "vegan", "mgcv"))
#' }

scan_packages <- function(pkgs = "All",
                          cite.tidyverse = FALSE,
                          dependencies = FALSE,
                          ...) {

  if (length(pkgs) == 1 && pkgs == "All") {
    pkgs <- unique(renv::dependencies(progress = FALSE, ...)$Package)
    pkgs <- pkgs[pkgs != "R"]
  }

  if (length(pkgs) == 1 && pkgs == "Session") {
    pkgs <- names(utils::sessionInfo()$otherPkgs)
  }

  # If pkgs != "All" nor "Session", use them directly as vector of pkg names

  # Collapse tidyverse packages into single citation?
  if (cite.tidyverse && any(pkgs %in% tidy.pkgs)) {
    pkgs <- pkgs[!pkgs %in% tidy.pkgs]
    pkgs <- c(pkgs, "tidyverse")
  }


  # Include dependencies
  if (dependencies) {
    pkgs <- remotes::package_deps(pkgs)$package
  }


  # Only cite base R once
  base_pkgs <- utils::sessionInfo()$basePkgs
  pkgs <- c("base", setdiff(pkgs, base_pkgs))

  # add grateful
  if (!"grateful" %in% pkgs) {
    pkgs <- c(pkgs, "grateful")
  }

  # Important to sort pkgs to match versions later
  pkgs <- sort(pkgs)

  # Get package versions

  # Some people may not have the 'tidyverse' package installed locally
  # First, get versions for all packages except 'tidyverse'
  pkgs.notidy <- pkgs[pkgs != "tidyverse"]
  versions <- pkgVersion(pkgs.notidy)
  versions <- unlist(lapply(versions, as.character))

  # Then add 'tidyverse' version
  # If not installed, assume version "1.3.1" (last in CRAN)
  if ("tidyverse" %in% pkgs) {
    tidy.version <- tryCatch(utils::packageVersion("tidyverse"),
                             error = function(e) {'1.3.1'})
    names(tidy.version) <- "tidyverse"
    versions <- c(versions, tidy.version)
    versions <- versions[sort(names(versions))]
  }

  pkgs.df <- data.frame(pkg = pkgs, version = versions, row.names = NULL)

  pkgs.df

}


pkgVersion <- Vectorize(utils::packageVersion, SIMPLIFY = FALSE)
