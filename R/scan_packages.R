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
                          skip.missing = FALSE,
                          ...) {

  stopifnot(is.character(pkgs))
  stopifnot(is.null(omit) | is.character(omit))
  stopifnot(is.logical(cite.tidyverse))
  stopifnot(is.logical(dependencies))

  if (is.null(desc.path)) {
    desc.path <- getwd()
  }
  stopifnot(is.character(desc.path))

  ## Manage warnings when scan_packages is called from get_pkgs_info ("inherited")
  if (isTRUE(skip.missing)) {
    warning("Setting 'skip.missing = TRUE': will issue a warning in case some package(s) are used in the project but not currently installed (hence their version/citation cannot be retrieved, and they will not be cited).",
            call. = FALSE)
  }
  if (skip.missing == "inherited") {
    skip.missing <- TRUE
  }
  stopifnot(is.logical(skip.missing))




  pkgnames <- pkgs

  if (length(pkgs) == 1 && pkgs == "All") {
    pkgnames <- unique(renv::dependencies(progress = FALSE, ...)$Package)
    pkgnames <- pkgnames[pkgnames != "R"]
  }

  if (length(pkgs) == 1 && pkgs == "Session") {
    pkgnames <- names(utils::sessionInfo()$otherPkgs)
  }

  # If 'pkgs' is a path to an R script, Rmd or qmd, scan only pkgs there.
  # In the unfortunate coincidence that the name of a single package coincides with
  # the name of an existing R/Rmd/qmd file (eg. 'lambda.R'), priority will be given to file
  if (length(pkgs) == 1 && is_file(pkgs)) {
    pkgnames <- unique(renv::dependencies(path = pkgs, progress = FALSE, ...)$Package)
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
    if (length(pkgnames) <= 20) {
      pkgnames <- remotes::package_deps(pkgnames)$package
    } else {
      # If more than 20 pkgs, introduce Sys.sleep to avoid github block (#61)
      message("Obtaining package dependencies...")
      # https://stackoverflow.com/a/7060331
      block  <- rep(1:ceiling(length(pkgnames)/20), each = 20)[seq_len(length(pkgnames))]
      pkg.list <- split(pkgnames, block)
      dep.list <- lapply(pkg.list,
                         function(x) {
                           Sys.sleep(1)
                           remotes::package_deps(x)$package
                         }
      )
      pkgnames <- unique(unlist(dep.list))
    }
  }


  # Collapse tidyverse packages into single citation?
  # tidy.pkgs list provided in 'tidyverse.R'
  if (cite.tidyverse && any(pkgnames %in% tidy.pkgs)) {
    pkgnames <- pkgnames[!pkgnames %in% tidy.pkgs]
    pkgnames <- pkgnames[pkgnames != "tidyverse"]
    pkgnames <- c(pkgnames, "tidyverse")
  }


  ## If 'pkgs' is not a vector of pkg names...
  if (length(pkgs) == 1) {
    if (pkgs == "All" || pkgs == "Session" || is_file(pkgs)) {

      # Only cite base R once
      base_pkgs <- utils::sessionInfo()$basePkgs
      pkgnames <- c("base", setdiff(pkgnames, base_pkgs))

      # Omit packages
      if (!is.null(omit)) {
        stopifnot(is.character(omit))  # omit must be a character vector of pkg names
        pkgnames <- pkgnames[!pkgnames %in% omit]

      }
    }
  }


  # Sort pkgnames
  pkgnames <- sort(pkgnames)


  ## Get package versions

  # Some users may not have the 'tidyverse' package installed locally
  # First, get versions for all packages except 'tidyverse'
  pkgs.notidy <- pkgnames[pkgnames != "tidyverse"]
  versions <- pkgVersion(pkgs.notidy, skip.missing = skip.missing)
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

  ## Merge and prepare output
  pkgnames.df <- data.frame(pkg = pkgnames)
  versions.df <- data.frame(pkg = names(versions), version = versions)
  pkgs.df <- merge(pkgnames.df, versions.df, all.x = TRUE)

  if (isTRUE(skip.missing)) {
    # message("Packages ", paste0(pkgs.df$pkg[is.na(pkgs.df$version)], collapse = ", "),
    #         " have been skipped as they are unavailable.")
    pkgs.df <- pkgs.df[!is.na(pkgs.df$version), ]
  }

  if (nrow(pkgs.df) == 0) {
    message("No packages detected.")
    return(data.frame(pkg = character(0), version = character(0)))
  }

  ## If listing packages from DESCRIPTION, use those versions
  if (exists("pkgdeps")) {
    pkgdeps <- data.frame(pkg = pkgdeps$package, version = pkgdeps$version)
    pkgs.df <- pkgs.df[, "pkg", drop = FALSE]
    pkgs.df <- merge(pkgs.df, pkgdeps, all.x = TRUE)
  }

  pkgs.df

}


is_file <- function(path) {
  stopifnot(is.character(path))
  if (file.exists(path) && grepl("\\.r$|\\.rmd$|\\.qmd$", tolower(basename(path)))) {
    out <- TRUE
  } else {
    out <- FALSE
  }
  out
}


# function to return the package version
pkgVers <- function(pkg_name, skip.missing) {

  if (isFALSE(skip.missing)) {
    return(utils::packageVersion(pkg_name))
  }

  if (isTRUE(skip.missing)) {
    # Use tryCatch to handle potential errors when retrieving versions from missing packages
    # Will issue a warning (and return NULL) for each missing package
    # For available packages will return version
    pkg_version <- tryCatch(
      {utils::packageVersion(pkg_name)},
      error = function(e) {
        warning(paste0("Could not retrieve version for package '", pkg_name, "'."), call. = FALSE)
        # Return NULL so this package is skipped
        return(NULL)
      })
  }
}

pkgVersion <- Vectorize({pkgVers}, vectorize.args = "pkg_name", SIMPLIFY = FALSE)
