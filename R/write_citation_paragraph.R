write_citation_paragraph <- function(df, include.RStudio = FALSE) {

  df.pkgs <- df[df$pkg != "base", ]

  if ("base" %in% df$pkg) {
    rversion <- paste0("R version ",
                       get_version("base", df), " ",
                       get_citekeys("base", df),
                       " and ")
  } else {
    rversion <- ""
  }

  parag <- paste0(
    "We used ",
    rversion,
    "the following R packages: ",
    paste(format_pkg_citation(pkgname = df.pkgs$pkg, df), collapse = ", ")
  )

  if (include.RStudio) {
    parag <- paste0(parag, ", running in RStudio v. ", rstudioapi::versionInfo()$version,
                    " [@rstudio].")
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

    pkginfo <- paste(pkgname,
                     "v.", get_version(pkgname, df = df),
                     get_citekeys(pkgname, df = df))

  },

  vectorize.args = "pkgname")
