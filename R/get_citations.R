#' Get citations for packages
#'
#' @param pkgs Character vector of package names, e.g. obtained by [scan_packages()].
#' @inheritParams cite_packages
#'
#' @return A file on the specified `out.dir` containing the package references
#' in BibTeX format. If assigned a name, `get_citations` will also return a list
#'  with citation keys for each package (without @@).
#'
#' @export
#'
#' @examplesIf interactive()
#' citekeys <- get_citations(c("knitr", "renv"), out.dir = tempdir())
#'
#' pkgs <- scan_packages()
#' citekeys <- get_citations(pkgs$pkg, out.dir = tempdir())

get_citations <- function(pkgs = NULL,
                          out.dir = NULL,
                          bib.file = "grateful-refs",
                          include.RStudio = FALSE) {

  if (!is.character(pkgs)) {
    stop("Please provide a character vector of package names")
  }

  if (is.null(out.dir)) {
    stop("Please specify where to save the BibTeX references, e.g. out.dir = getwd()")
  }

  if (!is.character(bib.file)) {
    stop("Please provide a name for the BibTeX file (without the .bib extension)")
  }

  stopifnot(is.logical(include.RStudio))



  # Some people may not have the tidyverse pkg installed locally,
  # so giving tidyverse citation directly
  # (tidyverse citation included in grateful package)

  pkgs.notidy <- pkgs[pkgs != "tidyverse"]
  cites.bib <- lapply(pkgs.notidy, get_citation_and_citekey)
  names(cites.bib) <- pkgs.notidy

  if ("tidyverse" %in% pkgs) {
    cites.bib$tidyverse <- add_citekey("tidyverse", tidyverse.citation)
  }

  if (include.RStudio == TRUE) {
    # Put an RStudio citation on the end
    if (!requireNamespace("rstudioapi")) {
      stop("Please install the {rstudioapi} package to cite RStudio.")
    } else {
      rstudio_cit <- tryCatch(rstudioapi::versionInfo()$citation,
                              error = function(e) NULL)
      if (!is.null(rstudio_cit)) {
        cites.bib$rstudio <- add_citekey("rstudio", rstudio_cit)
      }
    }
  }

  ## write bibtex references to file
  writeLines(enc2utf8(unlist(cites.bib)),
             con = file.path(out.dir, paste0(bib.file, ".bib")),
             useBytes = TRUE)

  # get the citekeys for each package
  get_pkg_citekeys <- function(pkg) {
    citekeys <- unname(grep("\\{[[:alnum:]_-]+,$", pkg, value = TRUE))
    citekeys <- gsub(".*\\{([[:alnum:]_-]+),$", "\\1", citekeys)
    return(citekeys)
  }
  pkg_citekeys <- lapply(cites.bib, get_pkg_citekeys)

  invisible(pkg_citekeys)
}
