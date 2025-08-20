write_citation_paragraph <- function(df = NULL,
                                     include.RStudio = FALSE,
                                     passive.voice = FALSE,
                                     text.start = NULL,
                                     text.pkgs = NULL,
                                     text.RStudio = NULL) {

  if (is.null(text.start)) {
    if (isTRUE(passive.voice)) {
      text.start <- "This work was completed using"
    } else {
      text.start <- "We used"
    }
  }
  stopifnot(is.character(text.start))

  if (is.null(text.pkgs)) {
    text.pkgs <- "the following R packages"
    if ("base" %in% df$pkg) {
      text.pkgs <- paste("and", text.pkgs)
    }
  }
  stopifnot(is.character(text.pkgs))

  if (is.null(text.RStudio)) {
    text.RStudio = "running in"
  }
  if (!is.null(text.RStudio)) {
    stopifnot(is.character(text.RStudio))
  }

  df.pkgs <- df[df$pkg != "base", ]

  rversion <- ""

  if ("base" %in% df$pkg) {
    rversion <- paste0("R v. ",
                       get_version("base", df), " ",
                       get_citekeys("base", df),
                       " ")
  }


  parag <- paste0(text.start, " ", rversion, text.pkgs, ": ",
                  paste(format_pkg_citation(pkgname = df.pkgs$pkg, df), collapse = ", "))

  if (include.RStudio) {
    parag <- paste0(parag, ", ", text.RStudio, " RStudio v. ",
                    rstudioapi::versionInfo()$version, " [@rstudio].")
  } else {
    parag <- paste0(parag, ".")
  }

  parag
}


get_version <- function(pkgname, df) {
  df$version[df$pkg == pkgname]
}

get_citekeys <- function(pkgname, df) {
  citekeys <- sort(unlist(df$citekeys[df$pkg == pkgname], use.names = FALSE))
  citk <- paste0("@", citekeys)
  citk <- paste(citk, collapse = "; ")
  citks <- paste0("[", citk, "]")
}

format_pkg_citation <- Vectorize(

  function(pkgname, df) {

    version <- get_version(pkgname, df = df)
    if (is.na(version)) {
      version.msg <- " "
    } else {
      version.msg <- paste0(" v. ", version, " ")
    }

    pkginfo <- paste0(pkgname,
                      # "v.", get_version(pkgname, df = df),
                      version.msg,
                      get_citekeys(pkgname, df = df))

  },

  vectorize.args = "pkgname")
