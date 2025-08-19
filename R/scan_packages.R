#' Scan a project or folder for packages used
#'
#' @inheritParams cite_packages
#' @param ... Other parameters passed to [renv::dependencies()].
#'
#' @return a data.frame with package names and versions
#' @export
#'
#' @examplesIf interactive()
#' scan_packages()
#' scan_packages(pkgs = "Session")
#' scan_packages(pkgs = c("renv", "remotes", "knitr"))


scan_packages <- function(pkgs = "All",
                          omit = c("grateful"),
                          cite.tidyverse = TRUE,
                          dependencies = FALSE,
                          desc.path = NULL,
                          ...) {

  stopifnot(is.character(pkgs))
  stopifnot(is.null(omit) | is.character(omit))
  stopifnot(is.logical(cite.tidyverse))
  stopifnot(is.logical(dependencies))

  if (is.null(desc.path)) {
    desc.path <- getwd()
  }
  stopifnot(is.character(desc.path))

  pkgnames <- pkgs

  if (length(pkgs) == 1 && pkgs == "All") {
    pkgnames <- unique(renv::dependencies(progress = FALSE, ...)$Package)
    pkgnames <- pkgnames[pkgnames != "R"]
  }

  if (length(pkgs) == 1 && pkgs == "Session") {
    pkgnames <- names(utils::sessionInfo()$otherPkgs)
  }

  # If reading pkg dependencies from DESCRIPTION file
  if (any(c("Depends", "Imports", "Suggests", "LinkingTo") %in% pkgs)) {
    # pkgnames <- remotes::local_package_deps(dependencies = pkgs)
    pkgdeps <- desc::desc_get_deps(file = desc.path)
    pkgdeps$package[pkgdeps$package == "R"] <- "base"
    pkgdeps$version[pkgdeps$version == "*"] <- NA_character_
    pkgnames <- pkgdeps[pkgdeps$type %in% pkgs, ]$package
    cite.tidyverse <- FALSE   # do not collapse package names into tidyverse
  }


  # Include recursive dependencies?
  if (isTRUE(dependencies)) {
    pkgnames <- remotes::package_deps(pkgnames)$package
  }


  # Collapse tidyverse packages into single citation?
  # tidy.pkgs list provided in 'tidyverse.R'
  if (cite.tidyverse && any(pkgnames %in% tidy.pkgs)) {
    pkgnames <- pkgnames[!pkgnames %in% tidy.pkgs]
    pkgnames <- pkgnames[pkgnames != "tidyverse"]
    pkgnames <- c(pkgnames, "tidyverse")
  }


  ## If 'pkgs' is not a vector of pkg names...

  if ((length(pkgs) == 1 && pkgs == "All") ||
      (length(pkgs) == 1 && pkgs == "Session")) {

    # Only cite base R once
    base_pkgs <- utils::sessionInfo()$basePkgs
    pkgnames <- c("base", setdiff(pkgnames, base_pkgs))


    # Omit packages
    if (!is.null(omit)) {
      stopifnot(is.character(omit))  # omit must be a character vector of pkg names
      pkgnames <- pkgnames[!pkgnames %in% omit]
    }
  }



  # Important to sort pkgnames to match versions later
  pkgnames <- sort(pkgnames)


  ## Get package versions

  # Some people may not have the 'tidyverse' package installed locally
  # First, get versions for all packages except 'tidyverse'
  pkgs.notidy <- pkgnames[pkgnames != "tidyverse"]
  versions <- pkgVersion(pkgs.notidy)
  versions <- unlist(lapply(versions, as.character))

  # Then add 'tidyverse' version
  # If not installed, assume version "2.0.0" (last in CRAN)
  if ("tidyverse" %in% pkgnames) {
    tidy.version <- tryCatch(as.character(utils::packageVersion("tidyverse")),
                             error = function(e) {'2.0.0'})
    names(tidy.version) <- "tidyverse"
    versions <- c(versions, tidy.version)
    versions <- versions[sort(names(versions))]
  }

  pkgs.df <- data.frame(pkg = pkgnames, version = versions, row.names = NULL)

  ## If listing packages from DESCRIPTION, use those versions
  if (exists("pkgdeps")) {
    pkgdeps <- data.frame(pkg = pkgdeps$package, version = pkgdeps$version)
    pkgs.df <- pkgs.df[, "pkg", drop = FALSE]
    pkgs.df <- merge(pkgs.df, pkgdeps, all.x = TRUE)
  }

  pkgs.df

}


pkgVersion <- Vectorize(utils::packageVersion, SIMPLIFY = FALSE)
